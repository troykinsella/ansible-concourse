require 'spec_helper'

# General

describe file('/opt/concourse') do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'concourse' }
  it { should be_grouped_into 'concourse'}
  it { should be_mode 755 }
end

describe file('/opt/concourse/concourse') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'concourse' }
  it { should be_grouped_into 'concourse'}
  it { should be_mode 750 }
end

# Web

describe file('/opt/concourse/cli-artifacts') do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'concourse' }
  it { should be_grouped_into 'concourse'}
  it { should be_mode 755 }
end

describe file('/opt/concourse/concourse-web') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'concourse' }
  it { should be_grouped_into 'concourse'}
  it { should be_mode 700 }
end

describe file('/opt/concourse/authorized_worker_keys') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'concourse' }
  it { should be_grouped_into 'concourse'}
  it { should be_mode 400 }

  puts "FREAKIN PATH: #{File.join(Dir.pwd, "spec/default/fixtures/worker_key.pub")}"

  fixture = File.read(File.join(Dir.pwd, "spec/default/fixtures/worker_key.pub")).strip + "\n"
  its(:content) { should eq fixture }
end

describe file('/opt/concourse/host_key') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'concourse' }
  it { should be_grouped_into 'concourse'}
  it { should be_mode 400 }

  fixture = File.read(File.join(Dir.pwd, "spec/default/fixtures/host_key")).strip
  its(:content) { should eq fixture }
end

describe file('/opt/concourse/session_signing_key') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'concourse' }
  it { should be_grouped_into 'concourse'}
  it { should be_mode 400 }

  fixture = File.read(File.join(Dir.pwd, "spec/default/fixtures/session_signing_key")).strip
  its(:content) { should eq fixture }
end

# Worker

describe file('/opt/concourse/work') do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'concourse' }
  it { should be_grouped_into 'concourse'}
  it { should be_mode 750 }
end

describe file('/opt/concourse/concourse-worker') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'concourse' }
  it { should be_grouped_into 'concourse'}
  it { should be_mode 700 }
end

describe file('/opt/concourse/worker_key') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'concourse' }
  it { should be_grouped_into 'concourse'}
  it { should be_mode 400 }

  fixture = File.read(File.join(Dir.pwd, "spec/default/fixtures/worker_key")).strip
  its(:content) { should eq fixture }
end

describe file('/opt/concourse/host_key.pub') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'concourse' }
  it { should be_grouped_into 'concourse'}
  it { should be_mode 400 }

  fixture = File.read(File.join(Dir.pwd, "spec/default/fixtures/host_key.pub")).strip
  its(:content) { should eq fixture }
end
