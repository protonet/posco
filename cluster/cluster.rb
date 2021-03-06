
begin
  require 'pry'
rescue LoadError
end

CONSTRUQT_PATH = ENV['CONSTRUQT_PATH'] || '../../../'
[
  "#{CONSTRUQT_PATH}/ipaddress/ruby/lib",
  "#{CONSTRUQT_PATH}/construqt/core/lib",
  "#{CONSTRUQT_PATH}/construqt/flavours/plantuml/lib",
  "#{CONSTRUQT_PATH}/construqt/flavours/gojs/lib",
  "#{CONSTRUQT_PATH}/construqt/flavours/nixian/core/lib",
  "#{CONSTRUQT_PATH}/construqt/flavours/nixian/dialects/ubuntu/lib",
  "#{CONSTRUQT_PATH}/construqt/flavours/nixian/dialects/coreos/lib",
  "#{CONSTRUQT_PATH}/construqt/flavours/mikrotik/lib",
  "#{CONSTRUQT_PATH}/construqt/flavours/ciscian/core/lib",
  "#{CONSTRUQT_PATH}/construqt/flavours/ciscian/dialects/hp/lib",
  "#{CONSTRUQT_PATH}/construqt/flavours/unknown/lib"
].each { |path| $LOAD_PATH.unshift(path) }
require 'rubygems'
require 'construqt'
require 'construqt/flavour/nixian'
require 'construqt/flavour/nixian/dialect/ubuntu'
require 'construqt/flavour/nixian/dialect/coreos'

require_relative 'ship.rb'
require_relative 'service.rb'
require_relative 'firewall.rb'

def setup_region(name, network)
  region = Construqt::Regions.add(name, network)
  nixian = Construqt::Flavour::Nixian::Factory.new
  nixian.add_dialect(Construqt::Flavour::Nixian::Dialect::Ubuntu::Factory.new)
  nixian.add_dialect(Construqt::Flavour::Nixian::Dialect::CoreOs::Factory.new)
  region.flavour_factory.add(nixian)
  if ARGV.include?('plantuml')
    require 'construqt/flavour/plantuml.rb'
    region.add_aspect(Construqt::Flavour::Plantuml.new)
  end

  region.network.ntp.add_server(region.network.addresses.add_ip('5.9.110.236').add_ip('178.23.124.2')).timezone('MET')
  region.users.add('menabe', 'group' => 'admin', 'full_name' => 'Meno Abels', 'public_key' => <<KEY, 'email' => 'meno.abels@construqt.net')
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDIQpC2scaVXEaNuwtq4n6Vtht2WHYxtDFKe44JNFEsZGyQjyL9c2qkmQQGCF+2g3HrIPDTCCCWQ3GUiXGAlQ0/rf6sLqcm4YMXt+hgHU5VeciUIDEySCKdCPC419wFPBw6oKdcN1pLoIdWoF4LRDcjcrKKAlkdNJ/oLnl716piLdchABO9NXGxBpkLsJGK8qw390O1ZqZMe9wEAL9l/A1/49v8LfzELp0/fhSmiXphTVI/zNVIp/QIytXzRg74xcYpBjHk1TQZHuz/HYYsWwccnu7vYaTDX0CCoAyEt599f9u+JQ4oW0qyLO0ie7YcmR6nGEW4DMsPcfdqqo2VyYy4ix3U5RI2JcObfP0snYwPtAdVeeeReXi3c/E7bGLeCcwdFeFBfHSA9PDGxWVlxh/oCJaE7kP7eBhXNjN05FodVdNczKI5T9etfQ9VHILFrvpEREg1+OTiI58RmwjxS5ThloqXvr/nZzhIwTsED0KNW8wE4pjyotDJ8jaW2d7oVIMdWqE2M9Z1sLqDDdhHdVMFxk6Hl2XfqeqO2Jnst7qzbHAN/S3hvSwysixWJEcLDVG+cg1KRwz4qafCU5oHSp8aNNOk4RZozboFjac17nOmfPfnjC/LLayjSkEBZ+eFi+njZRLDN92k3PvHYFEB3USbHYzICsuDcf+L4cslX03g7w== openpgp:0x5F1BE34D
KEY
  region.users.add('martin', 'group' => 'admin', 'full_name' => 'Martin Meier', 'public_key' => <<KEY, 'email' => 'martin@protonet.info')
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDtG5uO8WF72Wh6uLAsFOgae7lgFn4R/z7nODuw+1QvAKdTZ44YTKkSPlwa2nvzxrB8Mefv08lbDUvad2o93GvXzM7N1XHxumVshFrNsse0Qe+fPrUs/17Yeqt6oZVDvQlo6iEnph6fg3L10Qi3xmKvHNqPqMV7vKrMnYd0Q/NzqVkSdX5SOBrVKui18JRbCrxz5Ld9Jk2SsaR/kEBOdM/QlT6PHCxlVGd0JSdMb6DtvehPH+DdUHI4jdydH6Pq/gHU9SeMdy0J/ZJJuCLit392AnZm50lB366LSEcm423Kb3W5JdClyg8Q/+Kw2HXoQHwS4qX1SxW8UtOmwo2iVwA9E4a2L7ymAu7c7yHKozZg+mKnkO+XUgcLod9GKylVFtsOmu9kHBDIi3M73byMEiCs+2CXRkWUH+yrnKCAT3HzO870mVHel7JRqyxR1WfeMXq8rRXq2NcgZ7/igi9Rt/OJEcxtwIP+QE8TQSNr3mfikXaKWJMneZ4FykZsiRPHKtoGwfrhv+ooTb6pQbr4zPGTDfGxIo37NnIDiI0wShjCsXPuLd49F6xEAT9LdhNAjpYS1PWEvSfy6w7JldSJ7xxE2GSGN/VfXNh0h6Fbut0aVcpllKGJA1IB007rdEHW3hH7G3nW7HZfWCl0FNsGhqi+2P2GxxOYxSy9Zl3wFLBytQ== martin@cerberusssh
KEY

  ['dns_service.rb',
   'etcd_service.rb',
   'certor_service.rb',
   'posco_service.rb',
   'sni_proxy_service.rb',
   'tunator_service.rb'].each { |f| require_relative f }

  region.services.add(Dns::Service.new('DNS'))
  region.services.add(Etcd::Service.new('ETCD'))
  region.services.add(Certor::Service.new('CERTOR'))
  region.services.add(SniProxy::Service.new('SNIPROXY'))
  region.services.add(Posco::Service.new('POSCO'))
  region.services.add(Tunator::Service.new('TUNATOR'))

  region
end

def cluster_json
   return <<JSON
{
    "etcbinds":[
    {
    "name":"eu-0",
    "ipv4_extern":"10.24.1.200/24",
    "ipv4_addr":"10.24.1.200/24",
    "ipv4_gw":"10.24.1.1",
    "ipv6_addr":"fd00::10:24:1:200/64",
    "ipv6_gw":"fd00::10:24:1:1",
    "ipv4_intern":"169.254.200.1/24",
    "ipv6_intern":"fd00::169:254:200:1/112"
  },
  {
    "name":"eu-1",
    "ipv4_extern":"10.24.1.201/24",
    "ipv4_addr":"10.24.1.201/24",
    "ipv4_gw":"10.24.1.1",
    "ipv6_addr":"fd00::10:24:1:201/64",
    "ipv6_gw":"fd00::10:24:1:1",
    "ipv4_intern":"169.254.201.1/24",
    "ipv6_intern":"fd00::169:254:201:1/112"
  },
  {
    "name":"us-0",
    "ipv4_extern":"10.24.1.202/24",
    "ipv4_addr":"10.24.1.202/24",
    "ipv4_gw":"10.24.1.1",
    "ipv6_addr":"fd00::10:24:1:202/64",
    "ipv6_gw":"fd00::10:24:1:1",
    "ipv4_intern":"169.254.202.1/24",
    "ipv6_intern":"fd00::169:254:202:1/112"
  }],
  "vips":[
  {
    "name":"eu-0",
    "ipv4_extern":"10.24.1.210/24",
    "ipv4_addr":"10.24.1.210/24",
    "ipv4_gw":"10.24.1.1",
    "ipv6_addr":"fd00::10:24:1:210/64",
    "ipv6_gw":"fd00::10:24:1:1",
    "ipv4_intern":"169.254.210.1/24",
    "ipv6_intern":"fd00::169:254:210:1/112"
  },
  {
    "name":"eu-1",
    "ipv4_extern":"10.24.1.211/24",
    "ipv4_addr":"10.24.1.211/24",
    "ipv4_gw":"10.24.1.1",
    "ipv6_addr":"fd00::10:24:1:211/64",
    "ipv6_gw":"fd00::10:24:1:1",
    "ipv4_intern":"169.254.211.1/24",
    "ipv6_intern":"fd00::169:254:211:1/112"
  },
  {
    "name":"us-0",
    "ipv4_extern":"10.24.1.212/24",
    "ipv4_addr":"10.24.1.212/24",
    "ipv4_gw":"10.24.1.1",
    "ipv6_addr":"fd00::10:24:1:212/64",
    "ipv6_gw":"fd00::10:24:1:1",
    "ipv4_intern":"169.254.212.1/24",
    "ipv6_intern":"fd00::169:254:212:1/112"
  }],
  "certs":{
    "path":"../../certs/"
  },
  "domain":"protonet.io",
  "email":"martin@protonet.info"
}
JSON
end

def get_config
  fname = "#{ENV['USER']}.cfg.json"
  obj = JSON.parse(if File.exists?(fname)
    IO.read(fname)
  else
    cluster_json
  end)
end

network = Construqt::Networks.add('protonet')
network.set_domain(get_config['domain'])
network.set_contact(get_config['email'])
network.set_dns_resolver(network.addresses.set_name('NAMESERVER')
  .add_ip('8.8.8.8')
  .add_ip('8.8.4.4')
  .add_ip('2001:4860:4860::8888')
  .add_ip('2001:4860:4860::8844'), [network.domain])
region = setup_region('protonet', network)

firewall(region)

base = 200

def pullUp(p)
  OpenStruct.new(p.merge(
    'ipv4_addr' => IPAddress.parse(p['ipv4_addr']),
    'ipv4_gw' => IPAddress.parse(p['ipv4_gw']),
    'ipv6_addr' => IPAddress.parse(p['ipv6_addr']),
    'ipv6_gw' => IPAddress.parse(p['ipv6_gw']),
    'ipv4_intern' => IPAddress.parse(p['ipv4_intern']),
    'ipv6_intern' => IPAddress.parse(p['ipv6_intern'])
  ))
end

def get_config_and_pullUp(key)
  get_config[key].map{|x| pullUp(x) }
end

def load_certs(network)
  Dir.glob(File.join(get_config["certs"]["path"]||'/etc/letsencrypt/live',"*")).each do|dname|
    next unless File.directory?(dname)
      Construqt.logger.info "Reading Certs for #{File.basename(dname)}"
            network.cert_store.create_package(File.basename(dname),
              network.cert_store.add_private(File.basename(dname),IO.read(File.join(dname,'privkey.pem'))),
              network.cert_store.add_cert(File.basename(dname),IO.read(File.join(dname,'cert.pem'))),
              [network.cert_store.add_cacert(File.basename(dname),IO.read(File.join(dname,'chain.pem')))]
             )
  end
end

load_certs(network)

etcbinds = get_config_and_pullUp("etcbinds").map do |j|
  mother_firewall(j.name)
  ship = make_ship(region, 'name' => "etcbind-#{j.name}",
                   'firewalls' => ["#{j.name}-ipv4-map-dns", "#{j.name}-ipv4-map-certor","#{j.name}-ipv6-etcd"],
                   'ifname'    => 'enp0s8',
                   'proxy_neigh_host' => "##{j.name}_GW_S##{j.name}_DNS_S##{j.name}_ETCD_S##{j.name}_CERTOR_S",
                   'ipv4_addr' => "#{j.ipv4_addr.to_string}##{j.name}_DNS_S##{j.name}_CERTOR_S",
                   'ipv4_gw'   => j.ipv4_gw.to_s,
                   'ipv6_addr' => j.ipv6_addr.to_string,
                   'ipv6_gw'   => j.ipv6_gw.to_s,
                   'ipv4_intern' => j.ipv4_intern.to_string,
                   'ipv6_intern' => "#{j.ipv6_intern.to_string}##{j.name}_GW_S#GW_S")
  ipv4 = j.ipv4_intern.inc
  ipv6 = j.ipv6_intern.inc
  make_service(region, 'service' => 'DNS',
               'mother'    => ship,
               'mother_if' => 'br169',
               'name'      => "dns-#{j.name}",
               'firewalls' => ['dns-srv'],
               'ifname'    => 'eth0',
               'rndc_key'  => 'total geheim',
               'domains'   => [{ 'name' => 'construqt.net', 'basefile' => 'costruqt.net.zone' }],
               'ipv4_addr' => "#{ipv4.to_string.to_s}##{j.name}-DNS_MAPPED",
               'ipv4_gw'   => j.ipv4_intern.to_s,
               'ipv6_addr' => "#{ipv6.to_string}##{j.name}-DNS_MAPPED##{j.name}_DNS_S#DNS_S",
               'ipv6_gw'   => j.ipv6_intern.to_s)
  ipv4 = ipv4.inc
  ipv6 = ipv6.inc
  make_service(region, 'service' => 'ETCD',
               'mother'    => ship,
               'mother_if' => 'br169',
               'name'      => "etcd-#{j.name}",
               'firewalls' => ['etcd-srv'],
               'ifname'    => 'eth0',
               'rndc_key'  => 'total geheim',
               'domains'   => [{ 'name' => 'construqt.n:et', 'basefile' => 'costruqt.net.zone' }],
               'ipv6_addr' => "#{ipv6.to_string}##{j.name}-ETCD_MAPPED##{j.name}_ETCD_S#ETCD_S",
               'ipv6_gw'   => j.ipv6_intern.to_s)
  ipv4 = ipv4.inc
  ipv6 = ipv6.inc
  make_service(region, 'service' => 'CERTOR',
               'mother'    => ship,
               'mother_if' => 'br169',
               'name'      => "certor-#{j.name}",
               'firewalls' => ["#{j.name}-map-https-8443"],
               'ifname'    => 'eth0',
               'rndc_key'  => 'total geheim',
               'domains'   => [{ 'name' => 'construqt.net', 'basefile' => 'costruqt.net.zone' }],
               'ipv4_addr' => "#{ipv4.to_string.to_s}##{j.name}-CERTOR_MAPPED#CERTOR_S",
               'ipv4_gw'   => "169.254.#{base}.1",
               'ipv6_addr' => "#{ipv6.to_string}##{j.name}-CERTOR_MAPPED##{j.name}_CERTOR_S#CERTOR_S",
               'ipv6_gw'   => j.ipv6_intern.to_s)
  base += 1
  ship
end

vips = get_config_and_pullUp("vips").map do |j|
  ship = make_ship(region, 'name' => "vips-#{j.name}",
                   'ifname'    => j.iface||'enp0s8',
                   'dialect'   => j.dialect,
                   'firewalls' => ["#{j.name}-ipv4-map-sni", "#{j.name}-posco"],
                   'proxy_neigh_host' => "##{j.name}_SNI_S##{j.name}_POSCO_S##{j.name}_TUNATOR_S",
                   'proxy_neigh_net' => "##{j.name}_TUNATOR_S_NET",
                   'ipv4_addr' => "#{j.ipv4_addr.to_string}#DNS_S#CERTOR_S",
                   'ipv4_gw'   => j.ipv4_gw.to_s,
                   'ipv6_addr' => j.ipv6_addr.to_string,
                   'ipv6_gw'   => j.ipv6_gw.to_s,
                   'ipv4_intern' => j.ipv4_intern.to_string,
                   'ipv6_intern' => j.ipv6_intern.to_string)
  ipv4 = j.ipv4_intern.inc
  ipv6 = j.ipv6_intern.inc
  make_service(region, 'service' => 'SNIPROXY',
               'mother'    => ship,
               'mother_if' => 'br169',
               'name'      => "sniproxy-#{j.name}",
               'firewalls' => ['https-srv'],
               'ifname'    => 'eth0',
               'rndc_key'  => 'total geheim',
               'domains'   => [{ 'name' => 'construqt.net', 'basefile' => 'costruqt.net.zone' }],
               'ipv6_addr' => "#{ipv6.to_string}#SNIPROXY_S##{j.name}-SNI_MAPPED##{j.name}_SNI_S",
               'ipv6_gw'   => j.ipv6_intern.to_string)
  ipv4 = ipv4.inc
  ipv6 = ipv6.inc
  make_service(region, 'service' => 'POSCO',
               'mother'    => ship,
               'mother_if' => 'br169',
               'name'      => "poscos-#{j.name}",
               'firewalls' => ['https-srv'],
               'ifname'    => 'eth0',
               'rndc_key'  => 'total geheim',
               'domains'   => [{ 'name' => 'construqt.net', 'basefile' => 'costruqt.net.zone' }],
               'ipv6_addr' => "#{ipv6.to_string}#POSCO_S##{j.name}-posco##{j.name}-POSCO_MAPPED##{j.name}_POSCO_S",
               'ipv6_gw'   => j.ipv6_intern.to_string)
  ipv4 = ipv4.inc
  ipv6 = ipv6.inc
  tunator_firewall(j.name)
  tunator_block_ofs = j.ipv6_intern.size().shr(1)
  tunator_block = j.ipv6_intern.network.add_num(tunator_block_ofs).change_prefix(119)
  region.network.addresses.add_ip("#{tunator_block.to_string}##{j.name}_TUNATOR_S_NET")
  make_service(region, 'service' => 'TUNATOR',
               'mother'    => ship,
               'mother_if' => 'br169',
               'name'      => "tunators-#{j.name}",
               'firewalls' => ["#{j.name}-tunator"],
               'ifname'    => 'eth0',
               'rndc_key'  => 'total geheim',
               'domains'   => [{ 'name' => 'construqt.net', 'basefile' => 'costruqt.net.zone' }],
               'ipv6_proxy_neigh' => "##{j.name}_TUNATOR_S_NET",
               'ipv4_addr' => "#{ipv4.to_string}",
               'ipv4_gw'   => j.ipv4_intern.to_string,
               'ipv6_addr' => "#{ipv6.to_string}#TUNATOR_S##{j.name}-tunator##{j.name}_TUNATOR_S",
               'ipv6_gw'   => j.ipv6_intern.to_string)
end

region.hosts.add('cerberus', "flavour" => "nixian", "dialect" => "ubuntu") do |host|
      region.interfaces.add_device(host, "lo", "mtu" => "9000",
                                   :description=>"#{host.name} lo",
                                   "address" => region.network.addresses.add_ip(Construqt::Addresses::LOOOPBACK))
      host.configip = host.id ||= Construqt::HostId.create do |my|

        my.interfaces << iface = region.interfaces.add_device(host, "eth0", "mtu" => 1500,
            "address" => region.network.addresses.add_ip(Construqt::Addresses::DHCPV4),"firewalls" => ["border-masq"])
      end
      region.interfaces.add_bridge(host, 'bridge0',"mtu" => 1500,
                                                   "interfaces" => [],
                                                   "address" => region.network.addresses.add_ip("10.24.1.1/24",
                                                   "dhcp" => Construqt::Dhcp.new.start("10.24.1.100").end("10.24.1.110").domain("cerberus"))
                                                     .add_ip("fd00::10:24:1:1/64"))
    end

Construqt.produce(region)
