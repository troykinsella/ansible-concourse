script = <<-SCRIPT
sudo apt-get install -y \
  postgresql \
  python-minimal

sudo -u postgres createuser concourse || true
sudo -u postgres createdb --owner=concourse atc || true
sudo -u postgres psql -U postgres -d atc -c "alter user concourse with password 'concourse';"
SCRIPT

Vagrant.require_version ">= 2.1.2"
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "private_network", ip: "192.168.66.10"
  config.vm.network "forwarded_port", guest: 22, host: 22
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.ssh.insert_key = false

  config.vm.provision "shell", inline: script

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "test-playbook.yml"
  end
end
