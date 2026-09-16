{%
	let admin_ui = state.services?.admin_ui;
	if (!admin_ui?.wifi_ssid)
		return;

	let serial_suffix = replace(uc(serial || ''), /[^A-Z0-9]/g, '');
	if (length(serial_suffix) > 6)
		serial_suffix = substr(serial_suffix, length(serial_suffix) - 6);
	if (!length(serial_suffix))
		serial_suffix = 'UNKNOWN';

	let management_ssid = admin_ui.wifi_ssid + '-' + serial_suffix;

	let interface = {
		admin_ui: true,
		name: 'Admin-UI',
		role: 'downstream',
		auto_start: 0,
		services: [ 'ssh', 'http' ],
		ipv4: {
			addressing: 'static',
			subnet: '10.254.254.1/24',
			dhcp: {
				lease_first: 10,
				lease_count: 10,
				lease_time: '6h'
			}
		},
		ssids: [
			{
				name: management_ssid,
				wifi_bands: [ '2G', '5G' ],
				bss_mode: 'ap',
				encryption: {
					proto: 'none'
				}
			}
		],
	};

	if (admin_ui.wifi_bands)
		interface.ssids[0].wifi_bands = admin_ui.wifi_bands;
	if (admin_ui.wifi_key) {
		interface.ssids[0].encryption.proto = 'psk2';
		interface.ssids[0].encryption.key = admin_ui.wifi_key;
	}

	push(state.interfaces, interface);

	let wan = null;
	for (let iface in state.interfaces) {
		if (iface.role != 'upstream')
			continue;
		wan = iface;
		if (iface.name == 'WAN')
			break;
	}

	if (!wan)
		return;

	wan.ssids ??= [];

	push(wan.ssids, {
		name: 'OWF-' + serial_suffix + '-2G',
		wifi_bands: [ '2G' ],
		bss_mode: 'ap',
		encryption: {
			proto: 'psk2',
			key: 'Test@12345'
		}
	});

	push(wan.ssids, {
		name: 'OWF-' + serial_suffix + '-5G',
		wifi_bands: [ '5G' ],
		bss_mode: 'ap',
		encryption: {
			proto: 'psk2',
			key: 'Test@12345'
		}
	});
%}

set state.ui.offline_trigger={{ admin_ui.offline_trigger }}
