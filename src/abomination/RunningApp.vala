/*
 * This file is part of budgie-desktop
 *
 * Copyright Budgie Desktop Developers
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 */

namespace Budgie.Abomination {
	/**
	 * RunningApp is our wrapper for Wnck.Window with information
	 * needed by Budgie components.
	 */
	public class RunningApp : GLib.Object {
		public ulong id { get; private set; } // Window id
		public string name { get; private set; } // App name
		public DesktopAppInfo? app_info {
			owned get {
				return this.app_system.query_window(this.window);
			}
		}

		public unowned AppGroup group_object { get; private set; } // Actual AppGroup object
		public Workspace workspace { get; private set; }

		private Wnck.Window window; // Window of app
		private Budgie.AppSystem? app_system = null;
		private string current_icon = null; // Icon associated with this app
		private Gtk.IconTheme icon_theme = null;

		/**
		 * Signals
		 */
		public signal void icon_changed();
		public signal void renamed_app(string old_name, string new_name);
		public signal void app_info_changed(DesktopAppInfo? app_info);
		public signal void workspace_changed();

		internal RunningApp(Budgie.AppSystem app_system, Wnck.Window window, AppGroup group) {
			this.id = window.get_xid();
			this.name = window.get_name();
			this.group_object = group;
			this.workspace = new Workspace(window.get_workspace());
			this.icon_theme = Gtk.IconTheme.get_default();

			this.app_system = app_system;
			this.set_window(window);
			this.app_info_changed(this.app_info);

			this.icon_theme.changed.connect(() => {
				this.icon_theme = Gtk.IconTheme.get_default();
				this.icon_changed();
			});

			debug("Created app: %s", this.name);
		}

		public string get_group_name() {
			return this.group_object.get_name();
		}

		public Wnck.Window get_window() {
			return this.window;
		}

		public void toggle() {
			if (!this.window.is_active()) {
				var event_time = get_monotonic_time() / 1000;
				this.window.unminimize((uint32) event_time); // Ensure we unminimize it
				this.window.activate((uint32) event_time);
			} else {
				this.window.minimize();
			}
		}

		public void close() {
			this.window.close((uint32) get_monotonic_time() / 1000);
		}

		public Gdk.Pixbuf get_icon() {
			Gdk.Pixbuf pixbuf = null;

			var app_info = this.app_info; // sometime app_info disappear in the middle of getting the icon

			if (app_info is GLib.AppInfo && app_info.get_icon() != null) { // gicon is our best shoot as it respects user theme
				pixbuf = this.icon_theme.load_icon(app_info.get_icon().to_string(), Gtk.IconSize.INVALID, Gtk.IconLookupFlags.FORCE_REGULAR);
			} else {
				warning("Use pixbuf for %s", this.name);

				pixbuf = this.window.get_icon(); // FIXME: Pixbuf one is blurry. Could retry to get icon one more time and call icon_changed after that so that we catch the one we fail to match for whatever reason
			}

			if (pixbuf == null) {
				pixbuf = this.icon_theme.load_icon("image-missing", Gtk.IconSize.INVALID, Gtk.IconLookupFlags.FORCE_REGULAR);
			}

			return pixbuf.copy();
		}

		/**
		 * set_window will handle setting our window and its bindings
		 */
		private void set_window(Wnck.Window window) {
			if (window == null) { // Window provided is null
				return;
			}

			this.window = window;
			this.update_icon();
			this.update_name();

			this.window.class_changed.connect(() => {
				this.app_info_changed(this.app_info);
				this.update_icon();
				this.update_name();
			});

			this.window.icon_changed.connect(() => {
				this.update_icon();
			});

			this.window.name_changed.connect(() => this.update_name());
			this.window.state_changed.connect(() => this.update_name());
			this.window.workspace_changed.connect(() => {
				this.workspace = new Workspace(this.window.get_workspace());
				this.workspace_changed();
			});
		}

		/**
		 * update_icon will update our icon and notify that it changed
		 */
		private void update_icon() {
			var app_info = this.app_info; // sometime app_info disappear in the middle of updating the icon
			if (!(app_info is GLib.AppInfo) || (app_info is GLib.AppInfo && app_info.get_icon() == null)) {
				return;
			}

			string old_icon = this.current_icon;
			this.current_icon = app_info.get_icon().to_string();

			if (this.current_icon != old_icon) { // Actually changed
				debug("Icon changed for app %s", this.name);
				this.icon_changed();
			}
		}

		/**
		 * update_name will update the window name
		 */
		private void update_name() {
			if (this.window == null) {
				return;
			}

			string old_name = this.name;
			this.name = this.window.get_name();

			if (this.name != old_name) { // Actually changed
				debug("Renamed app %s into %s", old_name, this.name);
				this.renamed_app(old_name, this.name);
			}
		}
	}
}
