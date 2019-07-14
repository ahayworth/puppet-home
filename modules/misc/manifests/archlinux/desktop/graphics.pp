class misc::archlinux::desktop::graphics {
  $packages = [
    'intel-media-driver',
    'libva-utils',
    'vulkan-intel',
    'vulkan-icd-loader',
    'vulkan-tools',
    'mesa-demos',
  ]

  $packages.each |String $pkg| {
    package { $pkg:
      ensure => installed,
    }
  }

  file { '/etc/modprobe.d/i915.conf':
    content => 'options i915 enable_guc=3 enable_fbc=1'
  }

  augeas { 'LIBVA_DRIVER_NAME':
    changes => [
      'set /files/etc/environment/LIBVA_DRIVER_NAME iHD',
    ]
  }
}
