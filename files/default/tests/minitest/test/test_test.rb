# class TestArkCherryPick < MiniTest::Chef::TestCase

#   def test_cherry_pick_in_place
#     path = "/usr/local/foobar/jaxrpc.jar"
#     assert File.exists?(path)
#   end

#   def test_cherry_pick_owner
#     require 'etc'
#     path = "/usr/local/foobar/jaxrpc.jar"
#     assert File.stat(path).uid == Etc.getpwnam("foobarbaz").uid
#     assert File.stat(path).gid == Etc.getpwnam("foobarbaz").gid
#   end

#   def test_haproxy_unpack
#     path = "/usr/local/haproxy"
#     assert File.exists? path
#     assert File.exists? "#{path}/haproxy"
#   end

#   def test_haproxy_mode
#     path = "/usr/local/haproxy"
#     assert File.stat("#{path}/haproxy").mode  == 0100755
#   end

#   def test_haproxy_installed
#     path = "/usr/local/sbin/haproxy"
#     assert File.exists? path
#   end
  
# end
class TestArkDump < MiniTest::Chef::TestCase
  
  def test_creates_exists
    assert File.exists? "/usr/local/foo/wsdl4j.jar"
  end
  
  def test_dump_owner
    require 'etc'
    assert File.stat("/usr/local/foo/wsdl4j.jar").uid == Etc.getpwnam(@owner).uid
    assert File.stat("/usr/local/foo/wsdl4j.jar").gid == Etc.getpwnam(@owner).gid
  end
  
end
