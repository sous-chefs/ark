class TestArkDump < MiniTest::Chef::TestCase

  def path
    "/usr/local/foo/wsdl4j.jar"
  end

  def owner
    "foobarbaz"
  end
  
  def test_creates_exists
    assert File.exists?(path) 
  end
  
  def test_dump_owner
    require 'etc'
    assert File.stat(path).uid == Etc.getpwnam(owner).uid
    assert File.stat(path).gid == Etc.getpwnam(owner).gid
  end
 
end
