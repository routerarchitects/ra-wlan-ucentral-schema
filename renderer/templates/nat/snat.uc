{%
let src = null;

if (rule.out_interface?.name)
    src = ethernet.find_zone(rule.out_interface.name);

let name = "SNAT-" + rule.rule_id;

let target = "SNAT";

if (rule.translation?.address == "masquerade" ||
    rule.translation?.address == null)
    target = "MASQUERADE";

let enabled = rule.disable ? "0" : "1";
%}

add firewall nat
set firewall.@nat[-1].name='{{ name }}'
set firewall.@nat[-1].enabled='{{ enabled }}'
set firewall.@nat[-1].target='{{ target }}'

{% if (rule.protocol): %}
set firewall.@nat[-1].proto='{{ rule.protocol }}'
{% endif %}

{% if (src): %}
set firewall.@nat[-1].src='{{ src }}'
{% endif %}

{% if (rule.source?.address): %}
set firewall.@nat[-1].src_ip='{{ rule.source.address }}'
{% endif %}

{% if (rule.source?.port): %}
set firewall.@nat[-1].src_port='{{ rule.source.port }}'
{% endif %}

{% if (rule.destination?.address): %}
set firewall.@nat[-1].dest_ip='{{ rule.destination.address }}'
{% endif %}

{% if (rule.destination?.port): %}
set firewall.@nat[-1].dest_port='{{ rule.destination.port }}'
{% endif %}

{% if (target == "SNAT" && rule.translation?.address && rule.translation.address != "masquerade"): %}
set firewall.@nat[-1].snat_ip='{{ rule.translation.address }}'
{% endif %}

{% if (target == "SNAT" && rule.translation?.port): %}
set firewall.@nat[-1].snat_port='{{ rule.translation.port }}'
{% endif %}

