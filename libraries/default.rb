#
# Cookbook Name:: ark
# Library:: default
#
# Author:: Bryan W. Berry <bryan.berry@gmail.com>
# Copyright 2012, Bryan W. Berry
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


def parse_url(url)
  # construct the url if we use the auto-magic apache patterns
  unless url =~ /^(http|ftp).*$/
    url = set_apache_url(url)
  end
  # the url 'http://apache.org/pig/pig-0.8.0.tar.gz' has
  # release_basename 'pig-0.8.0' and release_ext 'tar.gz'
  release_basename, release_ext = parse_file_name(url)
  [ url, release_basename, release_ext ]
end

def set_ark_put_paths(path, name, release_ext)
  install_dir      = ::File.join(path, "#{name}")
  release_file     = ::File.join(install_dir,  "#{name}.#{release_ext}")
  [ install_dir, release_file ]
end

def get_expand_cmd(release_ext)
  expand_cmd =
    case release_ext
    when 'tar.gz'  then untar_cmd('xzf')
    when 'tar.bz2' then untar_cmd('xjf')
    when /zip|war|jar/ then unzip_cmd
    else raise "Don't know how to expand #{url} which has extension '#{release_ext}'"
    end
end

def parse_file_name(url)
  release_basename = ::File.basename(url.gsub(/\?.*\z/, '')).gsub(/-bin\b/, '')
  # (\?.*)? accounts for a trailing querystring
  release_basename =~ %r{^(.+?)\.(tar\.gz|tar\.bz2|zip|war|jar)(\?.*)?}
  release_ext      = $2
  [release_basename, release_ext]
end

def unzip_cmd
  ::Proc.new {|r|
    FileUtils.mkdir_p r.install_dir
    if r.strip_leading_dir
      require 'tmpdir'
      tmpdir = Dir.mktmpdir
      system("unzip  -q -u -o '#{r.release_file}' -d '#{tmpdir}'")
      subdirectory_children = Dir.glob("#{tmpdir}/**")
      FileUtils.mv subdirectory_children, r.install_dir
      FileUtils.rm_rf tmpdir
    elsif r.junk_paths
      system("unzip  -q -u -o -j #{r.release_file} -d #{r.install_dir}")
    else
      system("unzip  -q -u -o #{r.release_file} -d #{r.install_dir}")
    end 
    FileUtils.chown_R r.owner, r.owner, r.install_dir
  }
end

def untar_cmd(sub_cmd)
  ::Proc.new {|r|
    FileUtils.mkdir_p r.install_dir
    if r.strip_leading_dir
      strip_argument = "--strip-components=1"
    else
      strip_argument = ""
    end
    system(%Q{tar '#{sub_cmd}' '#{r.release_file}' '#{strip_argument}' -C '#{r.install_dir}';})
    FileUtils.chown_R r.owner, r.owner, r.install_dir
  }
end

def ark_opened?(resource)
   if resource.stop_file and !(resource.stop_file.empty?)
     if  ::File.exist?(::File.join(resource.install_dir,
                                   resource.stop_file))
       true
     else
       false
     end
   elsif !::File.exists?(resource.install_dir) or
       ::File.stat("#{resource.install_dir}/").nlink == 2
      Chef::Log.debug("ark is empty")
     false
    else
      true
    end
end

def set_apache_url(url)
  raise "Missing required resource attribute url" unless url
  url.gsub!(/:name:/,          name.to_s)
  url.gsub!(/:version:/,       version.to_s)
  url.gsub!(/:apache_mirror:/, node['install_from']['apache_mirror'])
  url
end
