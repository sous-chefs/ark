Vagrant::Config.run do |config|
  config.vm.box     = "ubuntu-1110-server-amd64"
  config.vm.box_url = "http://timhuegdon.com/vagrant-boxes/ubuntu-11.10.box"

  config.vm.provision :chef_solo do |chef|
        # point Vagrant at the location of cookbooks you are going to
# use,
        # for example, a clone of your fork of
    # github.com/travis-ci/travis-cookbooks
    chef.cookbooks_path = ["/home/hitman/chef-repo-opscode/site-cookbooks/",
                           "/home/hitman/chef-repo-opscode/cookbooks/"
                          ]

    # Turn on verbose Chef logging if necessary
    chef.log_level      = :debug

    # List the recipies you are going to work on/need.
#    chef.add_recipe     "build-essential"
    chef.add_recipe     "chef_handler"
    chef.add_recipe     "minitest-handler"
    chef.add_recipe     "ark"
    chef.add_recipe     "ark::test"

  end
end

