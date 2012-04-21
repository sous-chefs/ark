user 'foobarbaz'

directory "/opt/bin" do
  recursive true
end

ark 'mysql-connector-put' do
  url 'http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.19.tar.gz/from/http://it.mysql.contactlab.it/'
  checksum '4c79f0ca2617b9561f854743d8fc4bc20c5c3e4cd06954d799db926614e61e62'
  owner 'foobarbaz'
  group 'foobarbaz'
  action :put
end

ark "liferay_client_dependencies" do
  url "http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.1.0%20GA1/liferay-portal-client-6.1.0-ce-ga1-20120106155615760.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Flportal%2Ffiles%2FLiferay%2520Portal%2F6.1.0%2520GA1%2F&ts=1329490764&use_mirror=ignum"
  checksum 'd6b7f7801b02dafad318f2fb9a92cb9a7f0fe000f47590cc74d1c28cc17802f6'
  path '/usr/local/foo'
  creates 'wsdl4j.jar'
  action :dump
  owner 'foobarbaz'
  group 'foobarbaz'
end

ark 'mysql-connector' do
  url 'http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.19.tar.gz/from/http://it.mysql.contactlab.it/'
  checksum '4c79f0ca2617b9561f854743d8fc4bc20c5c3e4cd06954d799db926614e61e62'
  path '/usr/local/foozball'
  owner 'foobarbaz'
  group 'foobarbaz'
  creates "mysql-connector-java-5.1.19-bin.jar"
  action :cherry_pick
end


ark "maven" do
  url "http://apache.mirrors.tds.net/maven/binaries/apache-maven-2.2.1-bin.tar.gz"
  checksum  "b9a36559486a862abfc7fb2064fd1429f20333caae95ac51215d06d72c02d376"
  version '2.2.1'
  prefix_root "/usr/local"
  owner "foobarbaz"
  group 'foobarbaz'
  has_binaries [ 'bin/mvn' ]
  action :install
end

ark "tomcat" do
  version "7.0.26"
  url 'http://apache.mirrors.tds.net/tomcat/tomcat-7/v7.0.26/bin/apache-tomcat-7.0.26.tar.gz'
  checksum '89ba5fde0c596db388c3bbd265b63007a9cc3df3a8e6d79a46780c1a39408cb5'
  append_env_path true
  action :install
end

ark "tomcat7" do
  version "7.0.26"
  url 'http://apache.mirrors.tds.net/tomcat/tomcat-7/v7.0.26/bin/apache-tomcat-7.0.26.tar.gz'
  checksum '89ba5fde0c596db388c3bbd265b63007a9cc3df3a8e6d79a46780c1a39408cb5'
  has_binaries [ 'bin/catalina.sh', 'bin/daemon.sh' ]
  action :install
end


ark "fooball" do
  url 'https://github.com/bryanwb/chef-ark/raw/refactor_actions/files/default/foo.tar.gz'
  version '1'
  action :install
  strip_leading_dir false
end


ark "haproxy" do
  url  "http://haproxy.1wt.eu/download/1.5/src/snapshot/haproxy-ss-20120403.tar.gz"
  version "1.5"
  checksum 'ba0424bf7d23b3a607ee24bbb855bb0ea347d7ffde0bec0cb12a89623cbaf911'
  make_opts [ 'TARGET=linux26' ]
  action :install_with_make
end unless platform?("freebsd")

ark "maven2" do
  url "http://apache.mirrors.tds.net/maven/binaries/apache-maven-2.2.1-bin.tar.gz"
  checksum  "b9a36559486a862abfc7fb2064fd1429f20333caae95ac51215d06d72c02d376"
  version '2.2.1'
  prefix_root "/opt"
  prefix_home "/opt"
  prefix_bin "/opt/bin"
  owner "foobarbaz"
  group 'foobarbaz'
  has_binaries [ 'bin/mvn' ]
  action :install
end


 
# ark 'jaxrpc.jar' do
#   url "http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.1.0%20GA1/liferay-portal-client-6.1.0-ce-ga1-20120106155615760.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Flportal%2Ffiles%2FLiferay%2520Portal%2F6.1.0%2520GA1%2F&ts=1329490764&use_mirror=ignum"
#   checksum 'd6b7f7801b02dafad318f2fb9a92cb9a7f0fe000f47590cc74d1c28cc17802f6'
#   path '/usr/local/baz'
#   owner 'root'
#   action :cherry_pick
#   creates 'jaxrpc.jar'
# end



