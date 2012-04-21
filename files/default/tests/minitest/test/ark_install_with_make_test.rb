unless RUBY_PLATFORM =~ /freebsd/

class TestArkInstallWithMake < MiniTest::Chef::TestCase

  def path
    "/usr/local/haproxy-1.5"
  end

  def home_dir
    "/usr/local/haproxy"
  end
  
  def test_install_dir_exists
    assert File.exists?(path)
  end

  def test_homedir_symlink
    assert File.readlink(home_dir) == path
  end

  def test_bin_made
    assert File.exists? "#{path}/haproxy"
  end
  
  def test_bin_installed
    assert File.exists? "/usr/local/sbin/haproxy"
  end

  def test_bin_executable
    assert File.executable? "#{path}/haproxy"
  end

end

end