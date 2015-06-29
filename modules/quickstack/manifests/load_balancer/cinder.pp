 class quickstack::load_balancer::cinder (
  $frontend_pub_host,
  $frontend_priv_host,
  $frontend_admin_host,
  $backend_server_names,
  $backend_server_addrs,
  $api_port = '8776',
  $api_mode = 'tcp',
  $backend_port = '8776',
  $backend_ssl_port = '8776 ssl crt /etc/ssl/horizon.pem',
  $log = 'tcplog',
) {

  include quickstack::load_balancer::common

  if str2bool("$::haproxy_cert_exist") {

  quickstack::load_balancer::proxy { 'cinder-api':
    addr                 => [ $frontend_priv_host,
                              $frontend_admin_host ],
    port                 => "$api_port",
    mode                 => "$api_mode",
    listen_options       => { 'option' => [ "$log" ] },
    member_options       => [ 'check inter 1s' ],
    backend_server_addrs => $backend_server_addrs,
    backend_server_names => $backend_server_names,
  }
  quickstack::load_balancer::proxy { 'cinder-api-pub':
    addr                 => [ $frontend_pub_host ],
    port                 => "$backend_ssl_port",
    mode                 => "$api_mode",
    listen_options       => { 'option' => [ "$log" ] },
    member_options       => [ 'check inter 1s' ],
    backend_port         => $backend_port,
    backend_server_addrs => $backend_server_addrs,
    backend_server_names => $backend_server_names,
  }
 }
 else {
   quickstack::load_balancer::proxy { 'cinder-api':
    addr                 => [ $frontend_pub_host,
                              $frontend_priv_host,
                              $frontend_admin_host ],
    port                 => "$api_port",
    mode                 => "$api_mode",
    listen_options       => { 'option' => [ "$log" ] },
    member_options       => [ 'check inter 1s' ],
    backend_server_addrs => $backend_server_addrs,
    backend_server_names => $backend_server_names,
  }
 }

}
