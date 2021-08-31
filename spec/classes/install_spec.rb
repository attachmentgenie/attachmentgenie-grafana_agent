require 'spec_helper'
describe 'grafana_agent' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with archive_source set to special.tar.gz' do
        let(:params) do
          {
            archive_source: 'special.tar.gz',
            install_method: 'archive',
          }
        end

        it { is_expected.to raise_error(%r{expects a match for Stdlib::HTTPUrl}) }
      end

      context 'with archive_source set to http://localhost/special.tar.gz' do
        let(:params) do
          {
            archive_source: 'http://localhost/special.tar.gz',
            install_method: 'archive',
          }
        end

        it { is_expected.to contain_archive('grafana_agent archive').with_source('http://localhost/special.tar.gz') }
      end

      context 'with group set to myspecialgroup' do
        let(:params) do
          {
            group: 'myspecialgroup',
            manage_user: true,
          }
        end

        it { is_expected.to contain_group('grafana_agent').with_name('myspecialgroup') }
      end

      context 'with group set to myspecialgroup and install_method set to archive' do
        let(:params) do
          {
            group: 'myspecialgroup',
            install_dir: '/opt/grafana_agent',
            install_method: 'archive',
            manage_user: true,
          }
        end

        it { is_expected.to contain_file('grafana_agent install dir').with_group('myspecialgroup') }
        it { is_expected.to contain_archive('grafana_agent archive').with_group('myspecialgroup') }
      end

      context 'with group set to myspecialgroup and install_method set to archive and manage_user set to true' do
        let(:params) do
          {
            group: 'myspecialgroup',
            install_dir: '/opt/grafana_agent',
            install_method: 'archive',
            manage_user: true,
          }
        end

        it { is_expected.to contain_file('grafana_agent install dir').with_group('myspecialgroup').that_requires('Group[myspecialgroup]') }
        it { is_expected.to contain_archive('grafana_agent archive').with_group('myspecialgroup') }
      end

      context 'with group set to myspecialgroup and install_method set to archive and manage_user set to false' do
        let(:params) do
          {
            group: 'myspecialgroup',
            install_dir: '/opt/grafana_agent',
            install_method: 'archive',
            manage_user: false,
          }
        end

        it { is_expected.to contain_file('grafana_agent install dir').with_group('myspecialgroup').that_requires(nil) }
        it { is_expected.to contain_archive('grafana_agent archive').with_group('myspecialgroup') }
      end

      context 'with install_dir set to /opt/special' do
        let(:params) do
          {
            install_dir: '/opt/special',
            install_method: 'archive',
          }
        end

        it { is_expected.to contain_file('grafana_agent install dir').with_path('/opt/special') }
        it { is_expected.to contain_archive('grafana_agent archive').with_creates('/opt/special/grafana_agent') }
        it { is_expected.to contain_archive('grafana_agent archive').with_extract_path('/opt/special') }
        it { is_expected.to contain_archive('grafana_agent archive').that_requires('File[/opt/special]') }
      end

      context 'with install_dir set to /opt/special and manage_user set to true' do
        let(:params) do
          {
            install_dir: '/opt/special',
            install_method: 'archive',
            manage_user: true,
            user: 'grafana_agent',
          }
        end

        it { is_expected.to contain_user('grafana_agent').with_home('/opt/special') }
        it { is_expected.to contain_file('grafana_agent install dir').with_path('/opt/special').that_requires('User[grafana_agent]') }
      end

      context 'with install_method set to archive' do
        let(:params) do
          {
            install_dir: '/opt/grafana_agent',
            install_method: 'archive',
            package_name: 'grafana_agent',
          }
        end

        it { is_expected.to contain_file('grafana_agent install dir').that_comes_before('Archive[grafana_agent archive]') }
        it { is_expected.to contain_archive('grafana_agent archive') }
        it { is_expected.not_to contain_package('grafana_agent') }
      end

      context 'with install_method set to package' do
        let(:params) do
          {
            install_dir: '/opt/grafana_agent',
            install_method: 'package',
            package_name: 'grafana_agent',
          }
        end

        it { is_expected.not_to contain_file('grafana_agent install dir').that_comes_before('Archive[grafana_agent archive]') }
        it { is_expected.not_to contain_archive('grafana_agent archive') }
        it { is_expected.to contain_package('grafana_agent') }
      end

      context 'with manage_user set to true' do
        let(:params) do
          {
            group: 'grafana_agent',
            manage_user: true,
            user: 'grafana_agent',
          }
        end

        it { is_expected.to contain_user('grafana_agent') }
        it { is_expected.to contain_group('grafana_agent') }
      end

      context 'with manage_user set to false' do
        let(:params) do
          {
            manage_user: false,
          }
        end

        it { is_expected.not_to contain_user('grafana_agent') }
        it { is_expected.not_to contain_group('grafana_agent') }
      end

      context 'with package_name set to specialpackage' do
        let(:params) do
          {
            install_method: 'package',
            package_name: 'specialpackage',
          }
        end

        it { is_expected.to contain_package('grafana_agent').with_name('specialpackage') }
      end

      context 'with package_name set to specialpackage and manage_service set to true' do
        let(:params) do
          {
            install_method: 'package',
            manage_service: true,
            package_name: 'specialpackage',
            service_name: 'grafana_agent',
          }
        end

        it { is_expected.to contain_package('grafana_agent').with_name('specialpackage') }
      end

      context 'with package_version set to 42.42.42' do
        let(:params) do
          {
            install_method: 'package',
            package_name: 'grafana_agent',
            package_version: '42.42.42',
          }
        end

        it { is_expected.to contain_package('grafana_agent').with_ensure('42.42.42') }
      end

      context 'with user set to myspecialuser' do
        let(:params) do
          {
            manage_user: true,
            user: 'myspecialuser',
          }
        end

        it { is_expected.to contain_user('grafana_agent').with_name('myspecialuser') }
      end

      context 'with user set to myspecialuser and install_method set to archive' do
        let(:params) do
          {
            install_dir: '/opt/grafana_agent',
            install_method: 'archive',
            manage_user: true,
            user: 'myspecialuser',
          }
        end

        it { is_expected.to contain_file('grafana_agent install dir').with_owner('myspecialuser') }
        it { is_expected.to contain_archive('grafana_agent archive').with_user('myspecialuser') }
      end

      context 'with user set to myspecialuser and install_method set to archive and manage_user set to true' do
        let(:params) do
          {
            install_dir: '/opt/grafana_agent',
            install_method: 'archive',
            manage_user: true,
            user: 'myspecialuser',
          }
        end

        it { is_expected.to contain_file('grafana_agent install dir').with_owner('myspecialuser').that_requires('User[myspecialuser]') }
        it { is_expected.to contain_archive('grafana_agent archive').with_user('myspecialuser') }
      end

      context 'with user set to myspecialuser and install_method set to archive and manage_user set to false' do
        let(:params) do
          {
            install_dir: '/opt/grafana_agent',
            install_method: 'archive',
            manage_user: false,
            user: 'myspecialuser',
          }
        end

        it { is_expected.to contain_file('grafana_agent install dir').with_owner('myspecialuser').that_requires(nil) }
        it { is_expected.to contain_archive('grafana_agent archive').with_user('myspecialuser') }
      end
    end
  end
end
