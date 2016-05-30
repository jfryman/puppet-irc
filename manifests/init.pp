# Class: irc
#
# Description
#   This module is designed to install and manage IRC Hybrid, an IRC server
#
#   This module has been built and tested on RHEL systems.
#
# Parameters:
#  $network_name: The FQDN of the host where this server will reside.
#  $network_desc: A friendly descriptor of the IRC server
#  $admin_name: Friendly name of the Admin of the IRC server
#  $admin_email: Email address of the Admin
#  $listen_ip: Default IP for IRCD to listen on. Defaults to 127.0.0.1 if not set.
#  $auth_domains: domains that are authorized to be in the local user class.
#  $spoof_domain: domain used to spoof users that do not have domains.
#  $operator_name: admin account for IRC management
#  $operator_pass: admin password for IRC management.
#
# Actions:
#   This module will install a single IRC and configure it for usage.
#
# Requires:
#  - Class[stdlib]. This is Puppet Labs standard library to include additional methods for use within Puppet. [https://github.com/puppetlabs/puppetlabs-stdlib]
#
# Sample Usage:
#  class { 'irc':
#    network_name  => 'irc.frymanandassociates.net',
#    network_desc  => 'Fryman and Associates, Inc - IRC Server',
#    admin_name    => 'James Fryman',
#    admin_email   => 'james@frymanandassociates.net',
#    listen_ip     => '127.0.0.1',
#    auth_domains  => ['frymanandassociates.net', 'frymanet.com'],
#    spoof_domain  => 'frymanandassociates.net',
#    operator_name => 'admin',
#    operator_pass => 'password',
#  }
class irc (
  $network_name  = $irc::params::ic_network_name,
  $network_desc  = $irc::params::ic_network_desc,
  $admin_name    = $irc::params::ic_admin_name,
  $admin_email   = $irc::params::ic_admin_email,
  $listen_ip     = $irc::params::ic_listen_ip,
  $auth_domains  = $irc::params::ic_auth_domains,
  $spoof_domain  = $irc::params::ic_spoof_domain,
  $operator_name = $irc::params::ic_operator_name,
  $operator_pass = $irc::params::ic_operator_pass,
) inherits irc::params {
  include stdlib

  ### Begin Flow Logic ###
  anchor { 'irc::begin': } ->
  class { 'irc::package': } ->
  class { 'irc::config':
    network_name  => $network_name,
    network_desc  => $network_desc,
    admin_name    => $admin_name,
    admin_email   => $admin_email,
    listen_ip     => $listen_ip,
    auth_domains  => $auth_domains,
    spoof_domain  => $spoof_domain,
    operator_name => $operator_name,
    operator_pass => $operator_pass,
    module_paths  => $irc::params::ic_module_paths,
  } ~>
  class { 'irc::service': } ->
  anchor { 'irc::end': }
}
