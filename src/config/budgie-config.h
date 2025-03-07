/*
 * This file is part of budgie-desktop
 *
 * Copyright Budgie Desktop Developers
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 */

#ifndef _BUDGIE_CONFIG_H_
#define _BUDGIE_CONFIG_H_

#include <stdbool.h>

/* i.e. /usr/lib/budgie-desktop */
extern const char* BUDGIE_MODULE_DIRECTORY;

/* i.e. /usr/share/budgie-desktop/plugins */
extern const char* BUDGIE_MODULE_DATA_DIRECTORY;

/* i.e. /usr/lib/budgie-desktop/raven-plugins */
extern const char* BUDGIE_RAVEN_PLUGIN_LIBDIR;

/* i.e. /usr/share/budgie-desktop/raven-plugins */
extern const char* BUDGIE_RAVEN_PLUGIN_DATADIR;

extern const bool BUDGIE_HAS_SECONDARY_PLUGIN_DIRS;
extern const char* BUDGIE_MODULE_DIRECTORY_SECONDARY;
extern const char* BUDGIE_MODULE_DATA_DIRECTORY_SECONDARY;
extern const char* BUDGIE_RAVEN_PLUGIN_LIBDIR_SECONDARY;
extern const char* BUDGIE_RAVEN_PLUGIN_DATADIR_SECONDARY;

/* i.e. /usr/share/ */
extern const char* BUDGIE_DATADIR;

extern const char* BUDGIE_VERSION;

extern const char* BUDGIE_WEBSITE;

extern const char* BUDGIE_LOCALEDIR;

extern const char* BUDGIE_GETTEXT_PACKAGE;

/* sysconfdir */
extern const char* BUDGIE_CONFDIR;

#endif
