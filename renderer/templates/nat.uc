{%
if (nat.snat) {
    let snat = nat.snat;

    for (let i, rule in snat.rules)
        include('nat/snat.uc', {
            location: location + '/snat/rules/' + i,
            rule
        });
}
if (nat.dnat) {
    let dnat = nat.dnat;

    for (let i, rule in dnat.rules)
        include('nat/dnat.uc', {
            location: location + '/dnat/rules/' + i,
            rule
        });
}
%}

