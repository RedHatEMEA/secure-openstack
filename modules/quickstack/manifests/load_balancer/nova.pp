class quickstack::load_balancer::nova (
  $frontend_pub_host,
  $frontend_priv_host,
  $frontend_admin_host,
  $backend_server_names,
  $backend_server_addrs,
  $api_port         = '8774',
  $api_mode         = 'tcp',
  $metadata_port    = '8775',
  $metadata_mode    = 'tcp',
  $novncproxy_port  = '6080',
  $novncproxy_mode  = 'tcp',
  $xvpvncproxy_port = '6081',
  $xvpvncproxy_mode = 'tcp',
  $log = 'tcplog',
) {

  include quickstack::load_balancer::common

  quickstack::load_balancer::proxy { 'nova-api':
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

  quickstack::load_balancer::proxy { 'nova-metadata':
    addr                 => [ $frontend_pub_host,
                              $frontend_priv_host,
                              $frontend_admin_host ],
    port                 => "$metadata_port",
    mode                 => "$metadata_mode",
    listen_options       => { 'option' => [ "$log" ] },
    member_options       => [ 'check' ],
    backend_server_addrs => $backend_server_addrs,
    backend_server_names => $backend_server_names,
  }

  if str2bool("$::haproxy_cert_exist") {
    quickstack::load_balancer::proxy { 'nova-novncproxy':
      addr                 => [ $frontend_pub_host,
                                $frontend_priv_host,
                                $frontend_admin_host ],
      port                 => "6080 ssl crt /etc/ssl/horizon.pem ciphers AES256+EECDH force-tlsv12",
      mode                 => "$novncproxy_mode",
      listen_options       => { 'option'  => [ "$log" ],
                                'timeout' => [ "client 15m",
                                               "server 15m" ] },
      member_options       => [ 'check inter 1s' ],
      backend_port         => $novncproxy_port,
      backend_server_addrs => $backend_server_addrs,
      backend_server_names => $backend_server_names,
    }

    quickstack::load_balancer::proxy { 'nova-novncproxy_http':
      addr                 => [ $frontend_pub_host,
                                $frontend_priv_host,
                                $frontend_admin_host ],
      port                 => "$novncproxy_port",
      mode                 => "$novncproxy_mode",
      listen_options       => { 'option'   => [ "$log" ],
                                'reqadd'   => 'X-Forwarded-Proto:\ http',
                                'redirect' => 'scheme https if !{ ssl_fc }',
                                'timeout'  => [ "client 15m",
                                               "server 15m" ] },
      member_options       => [ 'check inter 1s' ],
      backend_server_addrs => undef,
      backend_server_names => undef,
    }
   }
  else {
    quickstack::load_balancer::proxy { 'nova-novncproxy':
      addr                 => [ $frontend_pub_host,
                                $frontend_priv_host,
                                $frontend_admin_host ],
      port                 => "$novncproxy_port",
      mode                 => "$novncproxy_mode",
      listen_options       => { 'option'  => [ "$log" ],
                                'timeout' => [ "client 15m",
                                               "server 15m" ] },
      member_options       => [ 'check inter 1s' ],
      backend_server_addrs => $backend_server_addrs,
      backend_server_names => $backend_server_names,
    }
  }

  quickstack::load_balancer::proxy { 'nova-xvpvncproxy':
    addr                 => [ $frontend_pub_host,
                              $frontend_priv_host,
                              $frontend_admin_host ],
    port                 => "$xvpvncproxy_port",
    mode                 => "$xvpvncproxy_mode",
    listen_options       => { 'option' => [ "$log" ] },
    member_options       => [ 'check inter 1s' ],
    backend_server_addrs => $backend_server_addrs,
    backend_server_names => $backend_server_names,
  }
}
