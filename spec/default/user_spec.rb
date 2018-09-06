require 'spec_helper'

describe user('concourse') do
  it { should exist }
  it { should belong_to_group 'concourse' }
  it { should have_uid 14500 }
  it { should have_login_shell '/bin/false' }
end

describe group('concourse') do
  it { should exist }
  it { should have_gid 14500 }
end

describe file('/home/concourse') do
  it { should_not exist }
end
