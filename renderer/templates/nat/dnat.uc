{%
let in_zone = null;

if (rule["in_interface"]?.name)
    in_zone = ethernet.find_zone(rule["in_interface"].name);

let name = "DNAT-" + rule["rule_id"];
let enabled = rule.disable ? "0" : "1";

let proto = rule.protocol;

let src_ip = rule.source?.address;
let src_port = rule.source?.port;

let external_port = rule.destination?.port;

let public_ip = rule.destination?.address;

let to_ip = rule.translation?.address;

let to_port = null;
if (rule.translation?.port)
    to_port = rule.translation.port;
%}

add firewall redirect
set firewall.@redirect[-1].name='{{ name }}'
set firewall.@redirect[-1].enabled='{{ enabled }}'
set firewall.@redirect[-1].target='DNAT'

{% if (proto): %}
set firewall.@redirect[-1].proto='{{ proto }}'
{% endif %}

{% if (in_zone): %}
set firewall.@redirect[-1].src='{{ in_zone }}'
{% endif %}

{% if (src_ip): %}
set firewall.@redirect[-1].src_ip='{{ src_ip }}'
{% endif %}

{% if (src_port): %}
set firewall.@redirect[-1].src_port='{{ src_port }}'
{% endif %}

{% if (external_port): %}
set firewall.@redirect[-1].src_dport='{{ external_port }}'
{% endif %}

{% if (public_ip): %}
set firewall.@redirect[-1].src_dip='{{ public_ip }}'
{% endif %}

{% if (to_ip): %}
set firewall.@redirect[-1].dest_ip='{{ to_ip }}'
{% endif %}

{% if (to_port): %}
set firewall.@redirect[-1].dest_port='{{ to_port }}'
{% endif %}
