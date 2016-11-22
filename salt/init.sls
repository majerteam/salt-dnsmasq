#!pyobjects


def _gen_hosts(tld):
    yield ' {}'.format(pillar('do_not_edit_sharp'))
    for hostname, hostdata in pillar('lan_hosts').iteritems():
        hostnames = (hostname, ) + tuple(
            alias 
            for alias 
            in hostdata.get('aliases', ())
        )
        
        fqdns = (
            '{}.{}'.format(hostpart, tld)
            for hostpart in hostnames
        )
        yield '{} {}'.format(hostdata['ip'], ' '.join(fqdns))

def _hosts_content(tld):
    return '\n'.join(sorted(_gen_hosts(tld)))


with Pkg.installed("dnsmasq"):
    Service.running("dnsmasq")

    with Service("dnsmasq", "watch_in"):
        # reload dnsmasq if hosts file modified
        for tld in ('tld1', 'tld2'):
            File.managed(
                'dnsmasq_hosts_list_{}'.format(tld),
                name='/etc/hosts.{}'.format(tld),                                                                                                                                                                                            
                contents=_hosts_content(tld),                                                                                                                                                                                                
                mode='0444',                                                                                                                                                                                                                 
            )                                                                                                                                                                                                                                
                                                                                                                                                                                                                                             
        # legacy                                                                                                                                                                                                                             
        File.managed(                                                                                                                                                                                                                        
            'dnsmasq_dhcp_vlan20',                                                                                                                                                                                                           
            name='/etc/dnsmasq.d/vlan20',                                                                                                                                                                                                    
            source='salt://dnsmasq/files/vlan20'                                                                                                                                                                                             
        )                                                                                                                                                                                                                                    
        # production                                                                                                                                                                                                                         
        File.managed(                                                                                                                                                                                                                        
            'dnsmasq_dhcp_vlan10',
            name='/etc/dnsmasq.d/vlan10',
            source='salt://dnsmasq/files/vlan10',
            template='jinja',
        )
File.managed(
    'dnsmasq_main_conf',
    name='/etc/dnsmasq.conf',
    source='salt://dnsmasq/files/dnsmasq.conf',
    template='jinja',
)
