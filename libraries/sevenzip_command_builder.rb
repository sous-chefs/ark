module Ark
  class SevenZipCommandBuilder
    def unpack
      sevenzip_command
    end

    def dump
      sevenzip_command_builder(resource.path, 'e')
    end

    def cherry_pick
      "#{sevenzip_command_builder(resource.path, 'e')} -r #{resource.creates}"
    end

    def initialize(resource)
      @resource = resource
    end

    private

    attr_reader :resource

    def sevenzip_command
      if resource.strip_components <= 0
        return sevenzip_command_builder(resource.path, 'x')
      end

      tmpdir = make_temp_directory
      cmd = sevenzip_command_builder(tmpdir, 'e')

      cmd += ' && '
      currdir = tmpdir.tr('/', '\\')

      1.upto(resource.strip_components).each do |count|
        cmd += "for /f %#{count} in ('dir /ad /b \"#{currdir}\"') do "
        currdir += "\\%#{count}"
      end

      cmd += "#{ENV.fetch('SystemRoot')}\\System32\\xcopy \"#{currdir}\" \"#{resource.home_dir}\" /s /e"
    end

    def sevenzip_binary
      @tar_binary ||= node['ark']['sevenzip_binary'] ||
                      "\"#{::Win32::Registry::HKEY_LOCAL_MACHINE.open(
                        'SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\7zFM.exe', ::Win32::Registry::KEY_READ).read_s('Path')}\\7z.exe\""
    end

    def sevenzip_command_builder(dir, command)
      "#{sevenzip_binary} #{command} \"#{resource.release_file}\"#{extension_is_tar} -o\"#{dir}\" -uy"
    end

    def extension_is_tar
      if resource.extension =~ /tar.gz|tgz|tar.bz2|tbz|tar.xz|txz/
        " -so | #{sevenzip_binary} x -aoa -si -ttar"
      else
        ''
      end
    end

    def make_temp_directory
      require 'tmpdir'
      Dir.mktmpdir
    end
  end
end
