class TestArkCherryPick < MiniTest::Chef::TestCase

  def test_cherry_pick_in_place
    path = "/usr/local/foobar/jaxrpc.jar"
    assert File.exists?(path)
  end

  def test_cherry_pick_owner
    require 'etc'
    path = "/usr/local/foobar/jaxrpc.jar"
    assert File.stat(path).uid == Etc.getpwnam("foobarbaz").uid
    assert File.stat(path).gid == Etc.getpwnam("foobarbaz").gid
  end

end
