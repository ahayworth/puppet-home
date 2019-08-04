require 'puppet/provider/package'

Puppet::Type.type(:package).provide :swupd, :parent => Puppet::Provider::Package do
  desc "Support for swupd, used in Clear Linux.

  commands :swupd => "/usr/bin/swupd"

  confine     :operatingsystem => [:clearlinux]
  defaultfor  :operatingsystem => [:clearlinux]
  has_feature :install_options
  has_feature :uninstall_options
  # All swupd packages are bundles; which are akin to virtual_packages
  has_feature :virtual_packages
  
  def install
    resource_name = @resource[:name]

    cmd = %w{--quiet --no-progress}
    cmd += install_options if @resource[:install_options]
    cmd << "bundle-add"
    cmd << resource_name

    swupd(*cmd)

    unless self.query
      fail(_("Could not find package '%{name}'") % { name: @resource[:name] })
    end
  end

  # Fetch the list of packages and package groups that are currently installed on the system.
  # Only package groups that are fully installed are included. If a group adds packages over time, it will not
  # be considered as fully installed any more, and we would install the new packages on the next run.
  # If a group removes packages over time, nothing will happen. This is intended.
  def self.instances
    instances = []

    # Get the installed packages
    installed_packages = get_installed_packages
    installed_packages.each do |package, version|
      instances << new(to_resource_hash(package, version))
    end

    instances
  end

  # returns a hash package => version of installed packages
  def self.get_installed_packages
    begin
      packages = {}
      execpipe([command(:swupd), "bundle-list"]) do |pipe|
        pipe.each_line do |line|
          packages[line.chomp] = 'latest'
        end
      end
      packages
    rescue Puppet::ExecutionFailure
      fail(_("Error getting installed packages"))
    end
  end

  # Queries information for a package or package group
  def query
    installed_packages = self.class.get_installed_packages
    resource_name = @resource[:name]
    version = installed_packages[resource_name]
    return nil if version.nil?

    self.class.to_resource_hash(resource_name, version)
  end

  def self.to_resource_hash(name, version)
    {
      :name     => name,
      :ensure   => version,
      :provider => self.name
    }
  end

  # Removes a package from the system.
  def uninstall
    resource_name = @resource[:name]
    
    cmd = %w{--quiet --no-progress}
    cmd += uninstall_options if @resource[:uninstall_options]
    cmd << "bundle-remove"
    cmd << resource_name
    swupd(*cmd)
  end

  private

  def install_options
    join_options(@resource[:install_options])
  end

  def uninstall_options
    join_options(@resource[:uninstall_options])
  end
end
