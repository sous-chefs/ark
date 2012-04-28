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
    unless RUBY_PLATFORM =~ /freebsd/
      bin_path = "/usr/local/tomcat-7.0.26/bin"
      bin_path_present = !ENV['PATH'].scan(bin_path).empty?
      assert bin_path_present
    end
  end
  
  def test_owner
    require 'etc'
    assert File.stat(path).uid == Etc.getpwnam("foobarbaz").uid
    assert File.stat(path).gid == Etc.getpwnam("foobarbaz").gid
  end

  def test_strip_leading_dir
    assert File.exists? "/usr/local/fooball/foo_sub"
  end

  def test_multiple_has_binaries
    real_path = "/usr/local/tomcat7-7.0.26/bin"
    link_path = '/usr/local/bin'
    assert File.readlink("#{link_path}/catalina.sh") == "#{real_path}/catalina.sh"
    assert File.readlink("#{link_path}/daemon.sh") == "#{real_path}/daemon.sh"
  end

  def test_alt_prefix_bin
    link_path = "/opt/maven2"
    real_path = "/opt/maven2-2.2.1"
    bin_link_path = "/opt/bin/mvn"
    bin_real_path = "/opt/maven2-2.2.1/bin/mvn"
    assert File.readlink("#{link_path}") == "#{real_path}"
    assert File.readlink("#{bin_link_path}") == "#{bin_real_path}"
  end
  
end

