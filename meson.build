project('nautilus-sendto-tailscale', ['c', 'vala'],
  version: '0.1.0',
  meson_version: '>= 0.50.0',
  default_options: [
    'warning_level=2',
  ],
)

add_project_arguments('--enable-experimental-non-null', language: 'vala')

i18n = import('i18n')
add_project_arguments(
  '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language: 'c'
)

subdir('src')
