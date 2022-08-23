require 'spec_helper'
describe 'grafana_agent' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('grafana_agent') }
        it { is_expected.to contain_class('grafana_agent::install').that_comes_before('Class[grafana_agent::Config]') }
        it { is_expected.to contain_class('grafana_agent::config').that_notifies('Class[grafana_agent::Service]') }
        it { is_expected.to contain_class('grafana_agent::service') }
        it { is_expected.to contain_group('grafana-agent') }
        it { is_expected.to contain_service('grafana-agent') }
        it { is_expected.to contain_user('grafana-agent') }
      end
    end
  end
end
