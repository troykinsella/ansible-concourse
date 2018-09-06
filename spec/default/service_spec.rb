require 'spec_helper'

describe service('concourse-web') do
  it { should be_enabled }
  it { should be_running }
end

describe service('concourse-worker') do
  it { should be_enabled }
  it { should be_running }
end
