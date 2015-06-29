class quickstack::load_balancer::glance (
  $frontend_pub_host,
  $frontend_priv_host,
  $frontend_admin_host,
  $backend_server_names,
  $backend_server_addrs,
  $api_port = '9292',
  $api_ssl_port = '9292 ssl crt /etc/ssl/openstack.pem',
  $api_mode = 'tcp',
  $registry_port = '9191',
  $registry_ssl_port = '9191 ssl crt /etc/ssl/openstack.pem',
  $registry_mode = 'tcp',
  $log = 'tcplog',
) {

  include quickstack::load_balancer::common

  if str2bool("$::haproxy_cert_exist") {

   quickstack::load_balancer::proxy { 'glance-api':
    addr                 => [ $frontend_priv_host,
                              $frontend_admin_host ],
    port                 => "$api_port",
    mode                 => "$api_mode",
    listen_options       => { 'option' => [ "$log" ] },
    member_options       => [ 'check inter 1s' ],
    backend_server_addrs => $backend_server_addrs,
    backend_server_names => $backend_server_names,
   }
   quickstack::load_balancer::proxy { 'glance-api-pub':
    addr                 => [ $frontend_pub_host,],
    port                 => "$api_ssl_port",
    mode                 => "$api_mode",
    listen_options       => { 'option' => [ "$log" ] },
    member_options       => [ 'check inter 1s' ],
    backend_server_addrs => $backend_server_addrs,
    backend_server_names => $backend_server_names,
   }
   quickstack::load_balancer::proxy { 'glance-registry':
    addr                 => [ $frontend_priv_host,
                              $frontend_admin_host ],
    port                 => "$registry_port",
    mode                 => "$registry_mode",
    listen_options       => { 'option' => [ "$log" ] },
    member_options       => [ 'check inter 1s' ],
    backend_server_addrs => $backend_server_addrs,
    backend_server_names => $backend_server_names,
   }
   quickstack::load_balancer::proxy { 'glance-registry-pub':
    addr                 => [ $frontend_pub_host,],
    port                 => "$registry_ssl_port",
    mode                 => "$registry_mode",
    listen_options       => { 'option' => [ "$log" ] },
    member_options       => [ 'check inter 1s' ],
    backend_server_addrs => $backend_server_addrs,
    backend_server_names => $backend_server_names,
   }
}
  else {
   quickstack::load_balancer::proxy { 'glance-api':
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

  quickstack::load_balancer::proxy { 'glance-registry':
    addr                 => [ $frontend_pub_host,
                              $frontend_priv_host,
                              $frontend_admin_host ],
    port                 => "$registry_port",
    mode                 => "$registry_mode",
    listen_options       => { 'option' => [ "$log" ] },
    member_options       => [ 'check inter 1s' ],
    backend_server_addrs => $backend_server_addrs,
    backend_server_names => $backend_server_names,
  }
 }
}
