class TestArkInstall < MiniTest::Chef::TestCase

  def home_dir
    "/usr/local/maven"
  end

  def path
    "/usr/local/maven-2.2.1"
  end
  
  def test_install_dir_exists
    assert File.exists?(path)
  end

  def test_homedir_symlink
    assert File.readlink(home_dir) == path
  end

  def test_has_binaries_mvn
    link_path = "/usr/local/bin/mvn"
    real_path = "#{path}/bin/mvn"
    assert File.readlink(link_path) == real_path
  end

  def test_append_env_path
    bin_path = "/usr/local/tomcat-7.0.26/bin"
    bin_path_present = !ENV['PATH'].scan(bin_path).empty?
    assert bin_path_present
  end
  
  def test_owner
    require 'etc'
    assert File.stat(path).uid == Etc.getpwnam("foobarbaz").uid
    assert File.stat(path).gid == Etc.getpwnam("foobarbaz").gid
  end

  def test_strip_leading_dir
    assert File.exists? "/usr/local/fooball/foo_sub"
  end

end


