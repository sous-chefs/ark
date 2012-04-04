user 'foobarbaz'

ark_cherry_pick 'jaxrpc' do
  url "http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.1.0%20GA1/liferay-portal-client-6.1.0-ce-ga1-20120106155615760.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Flportal%2Ffiles%2FLiferay%2520Portal%2F6.1.0%2520GA1%2F&ts=1329490764&use_mirror=ignum"
  pick "jaxrpc.jar"
  checksum 'd6b7f7801b02dafad318f2fb9a92cb9a7f0fe000f47590cc74d1c28cc17802f6'
  path '/usr/local/foobar'
  owner 'foobarbaz'
  ignore_failure true
end

ark "haproxy" do
  url  "http://haproxy.1wt.eu/download/1.5/src/snapshot/haproxy-ss-20120403.tar.gz"
  version "1.5"
  checksum 'ba0424bf7d23b3a607ee24bbb855bb0ea347d7ffde0bec0cb12a89623cbaf911'
  make_opts [ 'TARGET=linux26' ]
  action :install_with_make
  ignore_failure true
end


# ark "maven" do
#   url "http://www.apache.org/dist/maven/binaries/apache-maven-2.2.1-bin.tar.gz"
#   checksum  "b9a36559486a862abfc7fb2064fd1429f20333caae95ac51215d06d72c02d376"
#   version '2.2.1'
#   path "/usr/local"
#   append_env_path true
# end


# ark_dump "liferay_client_dependencies" do
#   url "http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.1.0%20GA1/liferay-portal-client-6.1.0-ce-ga1-20120106155615760.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Flportal%2Ffiles%2FLiferay%2520Portal%2F6.1.0%2520GA1%2F&ts=1329490764&use_mirror=ignum"
#   checksum 'd6b7f7801b02dafad318f2fb9a92cb9a7f0fe000f47590cc74d1c28cc17802f6'
#   path '/usr/local/foo'
#   creates 'wsdl4j.jar'
#   owner 'root'
# end

# ark_cherry_pick 'mysql-connector-java-5.0.8-bin.jar' do
#   url 'http://gd.tuwien.ac.at/db/mysql/Downloads/Connector-J/mysql-connector-java-5.0.8.tar.gz'
#   checksum '660a0e2a2c88a5fe65f1c5baadb20535095d367bc3688e7248a622f4e71ad68d'
#   path '/usr/local/foo'
#   owner 'root'
# end

# ark_cherry_pick 'mysql-connector' do
#   url 'http://gd.tuwien.ac.at/db/mysql/Downloads/Connector-J/mysql-connector-java-5.0.8.tar.gz'
#   pick "mysql-connector-java-5.0.8-bin.jar"
#   checksum '660a0e2a2c88a5fe65f1c5baadb20535095d367bc3688e7248a622f4e71ad68d'
#   path '/usr/local/bar'
#   owner 'root'
# end
 
# ark_cherry_pick 'jaxrpc.jar' do
#   url "http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.1.0%20GA1/liferay-portal-client-6.1.0-ce-ga1-20120106155615760.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Flportal%2Ffiles%2FLiferay%2520Portal%2F6.1.0%2520GA1%2F&ts=1329490764&use_mirror=ignum"
#   checksum 'd6b7f7801b02dafad318f2fb9a92cb9a7f0fe000f47590cc74d1c28cc17802f6'
#   path '/usr/local/baz'
#   owner 'root'
# end


# ark 'jboss-test' do
#   url  "http://download.jboss.org/jbossas/7.1/jboss-as-7.1.0.Final/jboss-as-7.1.0.Final.tar.gz"
#   checksum  "3a8ee8e3ab10003a5330e27d87e5ba38b90fbf8d6132055af4dd9a288d459bb7"
#   home_dir "/usr/local/jboss-test"
#   version "7.1.0"
#   owner "esb"
# end

# ark "tomcat" do
#   version "7.0.26"
#   url 'http://apache.mirrors.tds.net/tomcat/tomcat-7/v7.0.26/bin/apache-tomcat-7.0.26.tar.gz'
#   checksum '89ba5fde0c596db388c3bbd265b63007a9cc3df3a8e6d79a46780c1a39408cb5'
# end

