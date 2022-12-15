# ark cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/ark.svg)](https://supermarket.chef.io/cookbooks/ark)
[![CI State](https://github.com/sous-chefs/ark/workflows/ci/badge.svg)](https://github.com/sous-chefs/ark/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

## Overview

This cookbook provides `ark`, a resource for managing software archives. It manages the fetch-unpack-configure-build-install process common to installing software from source, or from binary distributions that are not fully fledged OS packages.

This cookbook started its life as a modified version of Infochimp's install_from cookbook. It has since been heavily refactored and extended to meet different use cases.

Given a simple project archive available at a url:

```ruby
ark 'pig' do
  url 'http://apache.org/pig/pig-0.8.0.tar.gz'
end
```

The `ark` resource will:

- fetch it to to `/var/cache/chef/`
- unpack it to the default path (`/usr/local/pig-0.8.0`)
- create a symlink for `:home_dir` (`/usr/local/pig`) pointing to path
- add specified binary commands to the environment `PATH` variable

By default, the ark will not run again if the `:path` is not empty. Ark provides many actions to accommodate different use cases, such as `:dump`, `:cherry_pick`, `:put`, and `:install_with_make`.

For remote files ark supports URLs using the [remote_file](http://docs.chef.io/resource_remote_file.html) resource. Local files are accessed with the `file://` syntax.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- Debian/Ubuntu
- RHEL/CentOS/Scientific/Oracle
- Fedora
- FreeBSD
- SmartOS
- macOS
- openSUSE / SUSE Linux Enterprises
- Windows

Should work on common Unix/Linux systems with typical userland utilities like tar, gzip, etc. May require the installation of build tools for compiling from source, but that installation is outside the scope of this cookbook.

### Chef

- Chef 14+

### Cookbooks

- seven_zip

## Attributes

Customize the attributes to suit site specific conventions and defaults.

- `node['ark']['apache_mirror']` - if the URL is an apache mirror, use the attribute as the default. default: `http://apache.mirrors.tds.net`
- `node['ark']['prefix_root']` - default base location if the `prefix_root` is not passed into the resource. default: `/usr/local`
- `node['ark']['prefix_bin']` - default binary location if the `prefix_bin` is not passed into the resource. default: `/usr/local/bin`
- `node['ark']['prefix_home']` - default home location if the `prefix_home` is not passed into the resource. default: `/usr/local`
- `node['ark']['package_dependencies']` - prerequisite system packages that need to be installed to support ark. default: varies based on platform
- `node['ark']['tar']` - allows overriding the default path to the tar binary, which varies based on platform
- `node['ark']['sevenzip_binary']` - allows overriding the default path to the 7zip binary, which is determined based on registry key value

## Resources

- `ark` - does the extract/build/configure

### Actions

- `:install`: extracts the file and creates a 'friendly' symbolic link to the extracted directory path
- `:configure`: configure ahead of the install action
- `:install_with_make`: extracts the archive to a path, runs `configure`, `make`, and `make install`.
- `:dump`: strips all directories from the archive and dumps the contained files into a specified path
- `:cherry_pick`: extract a specified file from an archive and places in specified path
- `:put`: extract the archive to a specified path, does not create any symbolic links
- `:remove`: removes the extracted directory and related symlink #TODO
- `:setup_py`: runs the command "python setup.py" in the extracted directory
- `:setup_py_build`: runs the command "python setup.py build" in the extracted directory
- `:setup_py_install`: runs the command "python setup.py install" in the extracted directory

### :cherry_pick

Extract a specified file from an archive and places in specified path.

#### Relevant Attribute Parameters for :cherry_pick

- `path`: directory to place file in.
- `creates`: specific file to cherry-pick.

### :dump

Strips all directories from the archive and dumps the contained files into a specified path.

NOTE: This currently only works for zip archives

#### Attribute Parameters for :dump

- `path`: path to dump files to.
- `mode`: file mode for `app_home`, as an integer.

   - Example: `0775`

- `creates`: if you are appending files to a given directory, ark needs a condition to test whether the file has already been extracted. You can specify with creates, a file whose existence indicates the ark has previously been extracted and does not need to be extracted again.

### :put

Extract the archive to a specified path, does not create any symbolic links.

#### Attribute Parameters for :put

- `path`: path to extract to.

   - Default: `/usr/local`

- `append_env_path`: boolean, if true, append the `./bin` directory of the extracted directory to the global `PATH` variable for all users.

### Attribute Parameters

- `name`: name of the package, defaults to the resource name.
- `url`: url for tarball, `.tar.gz`, `.bin` (oracle-specific), `.war`, and `.zip` currently supported. Also supports special syntax
- `:name:version:apache_mirror:` that will auto-magically construct download url from the apache mirrors site.
- `version`: software version, defaults to `1`.
- `mode`: file mode for `app_home`, is an integer.
- `prefix_root`: default `prefix_root`, for use with `:install*` actions.
- `prefix_home`: default directory prefix for a friendly symlink to the path.

   - Example: `/usr/local/maven` -> `/usr/local/maven-2.2.1`

- `prefix_bin`: default directory to place a symlink to a binary command.

   - Example: `/opt/bin/mvn` -> `/opt/maven-2.2.1/bin/mvn`, where the `prefix_bin` is `/opt/bin`

- `path`: path to extract the ark to. The `:install*` actions overwrite any user-provided values for `:path`.

   - Default: `/usr/local/<name>-<version>` for the `:install`, `:install_with_make` actions

- `home_dir`: symbolic link to the path `:prefix_root/:name-:version`, does not apply to `:dump`, `:put`, or `:cherry_pick` actions.

   - Default: `:prefix_root/:name`

- `has_binaries`: array of binary commands to symlink into `/usr/local/bin/`, you must specify the relative path.

   - Example: `[ 'bin/java', 'bin/javaws' ]`

- `append_env_path`: boolean, similar to `has_binaries` but less granular. If true, append the `./bin` directory of the extracted directory to. the `PATH` environment variable for all users, by placing a file in `/etc/profile.d/`. The commands are symbolically linked into `/usr/bin/*`. This option provides more granularity than the boolean option.

   - Example: `mvn`, `java`, `javac`, etc.

- `environment`: hash of environment variables to pass to invoked shell commands like `tar`, `unzip`, `configure`, and `make`.

- `strip_components`: number of components in path to strip when extracting archive. With default value of `1`, ark strips the leading directory from an archive, which is the default for both `unzip` and `tar` commands.

- `autoconf_opts`: an array of command line options for use with the GNU `autoconf` script.

   - Example: `[ '--include=/opt/local/include', '--force' ]`

- `make_opts`: an array of command line options for use with `make`.

   - Example: `[ '--warn-undefined-variables', '--load-average=2' ]`

- `owner`: owner of extracted directory.

   - Default: `root`

- `group`: group of extracted directory.

   - Default: `root`

- `backup`: The number of backups to be kept in /var/chef/backup (for UNIX- and Linux-based platforms) or C:/chef/backup (for the Microsoft Windows platform). Set to false to prevent backups from being kept.

   - Default: `5`

#### Examples

This example copies `ivy.tar.gz` to `/var/cache/chef/ivy-2.2.0.tar.gz`, unpacks its contents to `/usr/local/ivy-2.2.0/` -- stripping the leading directory, and symlinks `/usr/local/ivy` to `/usr/local/ivy-2.2.0`

```ruby
 # install Apache Ivy dependency resolution tool
 ark "ivy" do
   url 'http://someurl.example.com/ivy.tar.gz'
   version '2.2.0'
   checksum '89ba5fde0c596db388c3bbd265b63007a9cc3df3a8e6d79a46780c1a39408cb5'
   action :install
 end
```

This example copies `jdk-7u2-linux-x64.tar.gz` to `/var/cache/chef/jdk-7.2.tar.gz`, unpacks its contents to `/usr/local/jvm/jdk-7.2/` -- stripping the leading directory, symlinks `/usr/local/jvm/default` to `/usr/local/jvm/jdk-7.2`, and adds `/usr/local/jvm/jdk-7.2/bin/` to the global `PATH` for all users. The user 'foobar' is the owner of the `/usr/local/jvm/jdk-7.2` directory:

```ruby
 ark 'jdk' do
   url 'http://download.example.com/jdk-7u2-linux-x64.tar.gz'
   version '7.2'
   path "/usr/local/jvm/"
   home_dir "/usr/local/jvm/default"
   checksum  '89ba5fde0c596db388c3bbd265b63007a9cc3df3a8e6d79a46780c1a39408cb5'
   append_env_path true
   owner 'foobar'
 end
```

Install Apache Ivy dependency resolution tool in `/resource_name` in this case `/usr/local/ivy`, do not symlink, and strip any leading directory if one exists in the tarball:

```ruby
 ark "ivy" do
    url 'http://someurl.example.com/ivy.tar.gz'
    checksum '89ba5fde0c596db388c3bbd265b63007a9cc3df3a8e6d79a46780c1a39408cb5'
    action :put
 end
```

Install Apache Ivy dependency resolution tool in `/home/foobar/ivy`, strip any leading directory if one exists, don't keep backup copies of `ivy.tar.gz`:

```ruby
 ark "ivy" do
   path "/home/foobar"
   url 'http://someurl.example.com/ivy.tar.gz'
   checksum '89ba5fde0c596db388c3bbd265b63007a9cc3df3a8e6d79a46780c1a39408cb5'
   action :put
   backup false
 end
```

Strip all directories and dump files into path specified by the path attribute. You must specify the `creates` attribute in order to keep the extraction from running every time. The directory path will be created if it doesn't already exist:

```ruby
 ark "my_jars" do
   url  "http://example.com/bunch_of_jars.zip"
   path "/usr/local/tomcat/lib"
   creates "mysql.jar"
   owner "tomcat"
   action :dump
 end
```

Extract specific files from a tarball (currently only handles one named file):

```ruby
 ark 'mysql-connector-java' do
   url 'http://oracle.com/mysql-connector.zip'
   creates 'mysql-connector-java-5.0.8-bin.jar'
   path '/usr/local/tomcat/lib'
   action :cherry_pick
 end
```

Build and install haproxy and use alternative values for `prefix_root`, `prefix_home`, and `prefix_bin`:

```ruby
 ark "haproxy" do
   url  "http://haproxy.1wt.eu/download/1.5/src/snapshot/haproxy-ss-20120403.tar.gz"
   version "1.5"
   checksum 'ba0424bf7d23b3a607ee24bbb855bb0ea347d7ffde0bec0cb12a89623cbaf911'
   make_opts [ 'TARGET=linux26' ]
   prefix_root '/opt'
   prefix_home '/opt'
   prefix_bin  '/opt/bin'
   action :install_with_make
 end
```

You can also supply the file extension in case the file extension can not be determined by the URL:

```ruby
 ark "test_autogen" do
   url 'https://github.com/zeromq/libzmq/tarball/master'
   extension "tar.gz"
   action :install_with_make
 end
```

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
