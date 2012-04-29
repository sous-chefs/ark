task :vagrant_test => [:vagrant_up, :vagrant_provision] do
  puts "testing with vagrant"
end

task :vagrant_up do
  require 'vagrant' 
  puts "About to put vagrant up"
  env = Vagrant::Environment.new
  env.cli("up")
end

task :vagrant_provision do
  require 'vagrant' 
  puts "About to put vagrant up"
  env = Vagrant::Environment.new
  env.cli("provision")
end

task :vagrant_destroy do
  require 'vagrant'
  puts "Provisioning vagrant vm"
  env = Vagrant::Environment.new
  env.cli("destroy")
end
