class TestArkDump < MiniTest::Chef::TestCase

  def test_creates_exists
    assert File.exists?("/usr/local/foo/wsdl4j.jar") 
  end
  
  def test_dump_owner
    require 'etc'
    assert File.stat("/usr/local/foo/wsdl4j.jar").uid == Etc.getpwnam("foobarbaz").uid
    assert File.stat("/usr/local/foo/wsdl4j.jar").gid == Etc.getpwnam("foobarbaz").gid
  end
 
end

class TestArkCherryPick < MiniTest::Chef::TestCase

  def test_creates_exists
    assert File.exists?("/usr/local/foozball/mysql-connector-java-5.1.19-bin.jar") 
  end
  
  def test_owner
    require 'etc'
    assert File.stat("/usr/local/foozball/mysql-connector-java-5.1.19-bin.jar").uid == Etc.getpwnam("foobarbaz").uid
    assert File.stat("/usr/local/foozball/mysql-connector-java-5.1.19-bin.jar").gid == Etc.getpwnam("foobarbaz").gid
  end
 
end


class TestArkPut < MiniTest::Chef::TestCase

  def test_creates_exists
    assert File.exists?("/usr/local/mysql-connector-put/mysql-connector-java-5.1.19-bin.jar") 
  end
  
  def test_owner
    require 'etc'
    assert File.stat("/usr/local/mysql-connector-put/mysql-connector-java-5.1.19-bin.jar").uid == Etc.getpwnam("foobarbaz").uid
    assert File.stat("/usr/local/mysql-connector-put/mysql-connector-java-5.1.19-bin.jar").gid == Etc.getpwnam("foobarbaz").gid
  end
 
end

class TestArkInstall < MiniTest::Chef::TestCase

  def test_install_dir_exists
    assert File.exists?("/usr/local/maven-2.2.1")
  end

  def test_homedir_symlink
    link_path = "/usr/local/maven"
    real_path = "/usr/local/maven-2.2.1"
    assert File.readlink(link_path) == real_path
  end

  def test_has_binaries_mvn
    link_path = "/usr/local/bin/mvn"
    real_path = "/usr/local/maven-2.2.1/bin/mvn"
    assert File.readlink(link_path) == real_path
  end

  def test_append_env_path
    bin_path = "/usr/local/tomcat-7.0.26/bin"
    bin_path_present = ENV['PATH'].scan(bin_path).empty?
    assert bin_path_present
  end
  
  def test_owner
    require 'etc'
    assert File.stat("/usr/local/maven-2.2.1").uid == Etc.getpwnam("foobarbaz").uid
    assert File.stat("/usr/local/maven-2.2.1").gid == Etc.getpwnam("foobarbaz").gid
  end

end

