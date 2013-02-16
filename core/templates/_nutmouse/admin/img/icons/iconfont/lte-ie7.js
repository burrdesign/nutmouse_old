/* Use this script if you need to support IE 7 and IE 6. */

window.onload = function() {
	function addIcon(el, entity) {
		var html = el.innerHTML;
		el.innerHTML = '<span style="font-family: \'icomoon\'">' + entity + '</span>' + html;
	}
	var icons = {
			'icon-home' : '&#xe001;',
			'icon-home-2' : '&#xe002;',
			'icon-home-3' : '&#xe003;',
			'icon-newspaper' : '&#xe004;',
			'icon-pencil' : '&#xe005;',
			'icon-paint-format' : '&#xe006;',
			'icon-image' : '&#xe007;',
			'icon-image-2' : '&#xe008;',
			'icon-images' : '&#xe009;',
			'icon-camera' : '&#xe00a;',
			'icon-music' : '&#xe00b;',
			'icon-play' : '&#xe00c;',
			'icon-camera-2' : '&#xe00d;',
			'icon-pawn' : '&#xe00e;',
			'icon-bullhorn' : '&#xe00f;',
			'icon-file' : '&#xe010;',
			'icon-folder' : '&#xe011;',
			'icon-folder-open' : '&#xe012;',
			'icon-file-2' : '&#xe013;',
			'icon-tag' : '&#xe014;',
			'icon-tags' : '&#xe015;',
			'icon-qrcode' : '&#xe016;',
			'icon-barcode' : '&#xe017;',
			'icon-cart' : '&#xe018;',
			'icon-cart-2' : '&#xe019;',
			'icon-coin' : '&#xe01a;',
			'icon-support' : '&#xe01b;',
			'icon-phone' : '&#xe01c;',
			'icon-phone-hang-up' : '&#xe01d;',
			'icon-address-book' : '&#xe01e;',
			'icon-notebook' : '&#xe01f;',
			'icon-envelop' : '&#xe020;',
			'icon-location' : '&#xe021;',
			'icon-location-2' : '&#xe022;',
			'icon-map' : '&#xe023;',
			'icon-clock' : '&#xe024;',
			'icon-clock-2' : '&#xe025;',
			'icon-alarm' : '&#xe026;',
			'icon-print' : '&#xe027;',
			'icon-calendar' : '&#xe028;',
			'icon-calendar-2' : '&#xe029;',
			'icon-tv' : '&#xe02a;',
			'icon-mobile' : '&#xe02b;',
			'icon-tablet' : '&#xe02c;',
			'icon-bars' : '&#xe02d;',
			'icon-pie' : '&#xe02e;',
			'icon-remove' : '&#xe02f;',
			'icon-remove-2' : '&#xe030;',
			'icon-lab' : '&#xe031;',
			'icon-switch' : '&#xe032;',
			'icon-power-cord' : '&#xe000;',
			'icon-lightning' : '&#xe033;',
			'icon-rocket' : '&#xe034;',
			'icon-leaf' : '&#xe035;',
			'icon-close' : '&#xe036;',
			'icon-checkmark' : '&#xe037;',
			'icon-notification' : '&#xe038;',
			'icon-warning' : '&#xe039;'
		},
		els = document.getElementsByTagName('*'),
		i, attr, html, c, el;
	for (i = 0; i < els.length; i += 1) {
		el = els[i];
		attr = el.getAttribute('data-icon');
		if (attr) {
			addIcon(el, attr);
		}
		c = el.className;
		c = c.match(/icon-[^\s'"]+/);
		if (c && icons[c[0]]) {
			addIcon(el, icons[c[0]]);
		}
	}
};