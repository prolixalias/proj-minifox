
require 'spec_helper'

describe 'minifox::policy::baseline' do
  include BoltSpec::Plans

  describe 'basic functionality' do
    it 'runs successfully with no parameters passed' do
      expect_plan('minifox::policy::baseline::time')
      expect_plan('minifox::policy::app::sensu::client').not_be_called
    end
  end

  describe 'with monitoring enabled' do
    let(:params) do
      { 'enable_monitoring' => true }
    end

    it 'has sensu client' do
      expect_plan('minifox::policy::baseline::time')
      expect_plan('minifox::policy::app::sensu::client')
    end
  end

  describe 'with monitoring disabled' do
    let(:params) do
      { 'enable_monitoring' => false }
    end

    it 'does not have sensu client' do
      expect_plan('minifox::policy::baseline::time')
      expect_plan('minifox::policy::app::sensu::client').not_be_called
    end
  end

  context 'on darwin-21-x86_64' do
    let(:facts) do
      {
        osfamily: 'Darwin',
        operatingsystem: 'Darwin',
        operatingsystemmajrelease: '21',
      }
    end

    it 'contains Darwin baseline' do
      expect_plan('minifox::policy::baseline::darwin')
      expect_plan('minifox::policy::baseline::linux').not_be_called
      expect_plan('minifox::policy::baseline::windows').not_be_called
    end
  end

  context 'on ubuntu-20.04-x86_64' do
    let(:facts) do
      {
        osfamily: 'Debian',
        operatingsystem: 'Ubuntu',
        operatingsystemmajrelease: '20.04',
      }
    end

    it 'contains Linux baseline' do
      expect_plan('minifox::policy::baseline::darwin').not_be_called
      expect_plan('minifox::policy::baseline::linux')
      expect_plan('minifox::policy::baseline::windows').not_be_called
    end
  end

  context 'on redhat-8-x86_64' do
    let(:facts) do
      {
        osfamily: 'RedHat',
        operatingsystem: 'RedHat',
        operatingsystemmajrelease: '8',
      }
    end

    it 'contains Linux baseline' do
      expect_plan('minifox::policy::baseline::darwin').not_be_called
      expect_plan('minifox::policy::baseline::linux')
      expect_plan('minifox::policy::baseline::windows').not_be_called
    end
  end

  context 'on windows-2019-x86_64' do
    let(:facts) do
      {
        osfamily: 'windows',
        operatingsystem: 'windows',
        operatingsystemmajrelease: '2019',
      }
    end

    it 'contains Windows baseline' do
      expect_plan('minifox::policy::baseline::darwin').not_be_called
      expect_plan('minifox::policy::baseline::linux').not_be_called
      expect_plan('minifox::policy::baseline::windows')
    end
  end
end
