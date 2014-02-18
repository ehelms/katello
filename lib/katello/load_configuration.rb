#
# Copyright 2013 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH << path unless $LOAD_PATH.include? path

require 'katello/configuration'
require 'katello/app_config'
require 'util/password'

module Katello

  # TODO: clean up this method
  # rubocop:disable MethodLength, BlockAlignment, HashMethods
  # @return [Configuration::Loader] configured for Katello
  def self.configuration_loader

    @configuration_loader ||= Configuration::Loader.new(
      :config_file_paths        => %W(#{Rails.root}/config/settings.plugins.d/katello.yaml),
      :default_config_file_path => "#{Katello::Engine.root}/config/katello_defaults.yaml",

      :validation               => lambda do |*_|
        has_keys(*%w(candlepin notification
                     use_cp simple_search_tokens headpin?
                     use_pulp cdn_proxy katello?
                     redhat_repository_url search
                     elastic_url rest_client_timeout elastic_index
                     katello_version pulp profiling logging))

        has_values :app_mode, %w(katello headpin)

        validate :logging do
          has_keys(*%w(console_inline colorize log_trace loggers))

          validate :loggers do
            has_keys 'root'
            validate :root do
              has_keys 'level'
              if config[:type] == 'file'
                has_keys(*%w(age keep pattern filename))
                has_keys 'path' unless early?
              end
            end
          end
        end

        are_booleans :use_cp, :use_pulp, :use_elasticsearch

      end,

      :config_post_process      => lambda do |config, environment|
        config[:katello?] = lambda { config.app_mode == 'katello' }
        config[:headpin?] = lambda { config.app_mode == 'headpin' }

        config[:use_cp] = true if config[:use_cp].nil?
        config[:use_pulp] = config.katello? if config[:use_pulp].nil?
        config[:use_elasticsearch] = true if config[:use_elasticsearch].nil?

        root = config.logging.loggers.root
        root[:path] = "#{Rails.root}/log" unless root.key?(:path) if environment
        root[:type] ||= 'file'

        config[:katello_version] ||= if git_checkout?
                                       git_commit_hash
                                     elsif can_do_shell_command?(:rpm)
                                       rpm_package_name(config)
                                     else
                                       N_("Unknown")
                                     end
      end)
  end

  # @see Katello::Configuration::Loader#config
  def self.config
    configuration_loader.config
  end

  # @see Katello::Configuration::Loader#early_config
  def self.early_config
    configuration_loader.early_config
  end

  def self.can_do_shell_command?(cmd)
    system("which #{cmd.to_s} >/dev/null 2>&1")
  end

  def self.git_checkout?
    can_do_shell_command?(:git) && system("cd #{File.dirname(__FILE__)} && git rev-parse --git-dir >/dev/null 2>&1")
  end

  def self.git_commit_hash
    hash = %x{cd #{File.dirname(__FILE__)} && git rev-parse HEAD 2>/dev/null}.chop
    $?.exitstatus.zero? ? "git: #{hash}" : N_("Unknown") # rubocop:disable SpecialGlobalVars
  end

  def self.rpm_package_name(config)
    package = config.katello? ? 'katello' : 'katello-headpin'
    rpm = %x{rpm -q #{package} --queryformat '%{VERSION}-%{RELEASE}' 2>&1}
    $?.exitstatus.zero? ? rpm : N_("Unknown") # rubocop:disable SpecialGlobalVars
  end
end
