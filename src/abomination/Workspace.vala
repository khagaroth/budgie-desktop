namespace Budgie.Abomination {
	/**
	 * Workspace is our wrapper for Wnck.Workspace with information
	 * needed by Budgie components. As we are planning on getting rid of Wnck,
	 * we need to isolate every bits in Abomination where we can later
	 * easily swap to a better system.
	 */
	public class Workspace : GLib.Object {

		private Wnck.Workspace? workspace;

		/**
		 * Signals
		 */
		public signal void name_changed(string name);

		internal Workspace(Wnck.Workspace workspace) {
			this.workspace = workspace;

			this.workspace.name_changed.connect(() => this.name_changed(this.get_name()));
		}

		public void activate() {
			this.workspace.activate((uint32) get_monotonic_time() / 1000);
		}

		public string get_name() {
			return this.workspace.get_name();
		}

		public void update_name(string name) {
			this.workspace.change_name(name);
		}

		public int get_number() {
			return this.workspace.get_number();
		}
	}
}
