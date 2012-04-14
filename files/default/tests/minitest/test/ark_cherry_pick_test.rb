class TestArkCherryPick < MiniTest::Chef::TestCase

  def path
    "/usr/local/foozball/mysql-connector-java-5.1.19-bin.jar"
  end
  
  def test_creates_exists
    assert File.exists?(path) 
  end
  
  def test_owner
    require 'etc'
    assert File.stat(path).uid == Etc.getpwnam("foobarbaz").uid
    assert File.stat(path).gid == Etc.getpwnam("foobarbaz").gid
  end
 
end
