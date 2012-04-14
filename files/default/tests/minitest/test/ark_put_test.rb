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
