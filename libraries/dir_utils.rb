module Ark
  module DirUtils
    # Delete all files and directories inside the given directory.
    # @param work_dir Path of the directory to be cleaned up.
    def delete_files_and_directories_inside(work_dir)
      # Ensure we only have "/"-like separators in the provided path
      # (windows path separator is not supported by Dir)
      directory_content_pattern = ::File.join(work_dir, '*').gsub(/\\/, '/')

      ::Dir[directory_content_pattern].each do |path|
        ::FileUtils.rm_rf(path)
      end
    end
  end
end
