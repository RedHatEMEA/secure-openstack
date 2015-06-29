if FileTest.file?("/etc/ssl/openstack.pem")
    Facter.add(:haproxy_cert_exist) do
        setcode { true }
    end
end
