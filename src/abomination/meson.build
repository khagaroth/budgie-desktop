# libabomination

libabomination_sources = [
    'abomination.vala',
    'RunningApp.vala',
    'AppGroup.vala',
    'utils.vala',
]

libabomination_deps = [
    dep_giounix,
    dep_gtk3,
    dep_gdkx11,
    dep_wnck,
	link_libappsys,
]

libabomination = shared_library(
    'abomination',
    libabomination_sources,
    dependencies: libabomination_deps,
    vala_args: [
        '--pkg', 'gio-unix-2.0',
        '--pkg', 'gtk+-3.0',
        '--pkg', 'gdk-x11-3.0',
        '--pkg', 'libwnck-3.0',
        '--vapidir', dir_libappsys,
    ],
    c_args: [
        '-DWNCK_I_KNOW_THIS_IS_UNSTABLE',
    ],
    version: '0.0.0',
    install: true,
)

link_libabomination = declare_dependency(
    link_with: libabomination,
    dependencies: libabomination_deps,
    include_directories: [
        include_directories('.'),
    ],
)

# Expose the current directory so that we can use vapidir
dir_libabomination = meson.current_build_dir()
