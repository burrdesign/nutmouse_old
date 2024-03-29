/* Use this script if you need to support IE 7 and IE 6. */

window.onload = function() {
	function addIcon(el, entity) {
		var html = el.innerHTML;
		el.innerHTML = '<span style="font-family: \'icomoon\'">' + entity + '</span>' + html;
	}
	var icons = {
			'icon-home' : '&#xe000;',
			'icon-home-2' : '&#xe001;',
			'icon-home-3' : '&#xe002;',
			'icon-office' : '&#xe003;',
			'icon-newspaper' : '&#xe004;',
			'icon-pencil' : '&#xe005;',
			'icon-pencil-2' : '&#xe006;',
			'icon-quill' : '&#xe007;',
			'icon-pen' : '&#xe008;',
			'icon-blog' : '&#xe009;',
			'icon-droplet' : '&#xe00a;',
			'icon-paint-format' : '&#xe00b;',
			'icon-image' : '&#xe00c;',
			'icon-image-2' : '&#xe00d;',
			'icon-images' : '&#xe00e;',
			'icon-camera' : '&#xe00f;',
			'icon-music' : '&#xe010;',
			'icon-headphones' : '&#xe011;',
			'icon-play' : '&#xe012;',
			'icon-film' : '&#xe013;',
			'icon-camera-2' : '&#xe014;',
			'icon-dice' : '&#xe015;',
			'icon-pacman' : '&#xe016;',
			'icon-spades' : '&#xe017;',
			'icon-clubs' : '&#xe018;',
			'icon-diamonds' : '&#xe019;',
			'icon-pawn' : '&#xe01a;',
			'icon-bullhorn' : '&#xe01b;',
			'icon-connection' : '&#xe01c;',
			'icon-podcast' : '&#xe01d;',
			'icon-feed' : '&#xe01e;',
			'icon-book' : '&#xe01f;',
			'icon-books' : '&#xe020;',
			'icon-library' : '&#xe021;',
			'icon-file' : '&#xe022;',
			'icon-profile' : '&#xe023;',
			'icon-file-2' : '&#xe024;',
			'icon-file-3' : '&#xe025;',
			'icon-file-4' : '&#xe026;',
			'icon-copy' : '&#xe027;',
			'icon-copy-2' : '&#xe028;',
			'icon-copy-3' : '&#xe029;',
			'icon-paste' : '&#xe02a;',
			'icon-paste-2' : '&#xe02b;',
			'icon-paste-3' : '&#xe02c;',
			'icon-stack' : '&#xe02d;',
			'icon-folder' : '&#xe02e;',
			'icon-folder-open' : '&#xe02f;',
			'icon-tag' : '&#xe030;',
			'icon-tags' : '&#xe031;',
			'icon-barcode' : '&#xe032;',
			'icon-qrcode' : '&#xe033;',
			'icon-ticket' : '&#xe034;',
			'icon-cart' : '&#xe035;',
			'icon-cart-2' : '&#xe036;',
			'icon-cart-3' : '&#xe037;',
			'icon-coin' : '&#xe038;',
			'icon-credit' : '&#xe039;',
			'icon-calculate' : '&#xe03a;',
			'icon-support' : '&#xe03b;',
			'icon-phone' : '&#xe03c;',
			'icon-phone-hang-up' : '&#xe03d;',
			'icon-address-book' : '&#xe03e;',
			'icon-notebook' : '&#xe03f;',
			'icon-envelop' : '&#xe040;',
			'icon-pushpin' : '&#xe041;',
			'icon-location' : '&#xe042;',
			'icon-location-2' : '&#xe043;',
			'icon-compass' : '&#xe044;',
			'icon-map' : '&#xe045;',
			'icon-map-2' : '&#xe046;',
			'icon-history' : '&#xe047;',
			'icon-clock' : '&#xe048;',
			'icon-clock-2' : '&#xe049;',
			'icon-alarm' : '&#xe04a;',
			'icon-alarm-2' : '&#xe04b;',
			'icon-bell' : '&#xe04c;',
			'icon-stopwatch' : '&#xe04d;',
			'icon-calendar' : '&#xe04e;',
			'icon-calendar-2' : '&#xe04f;',
			'icon-print' : '&#xe050;',
			'icon-keyboard' : '&#xe051;',
			'icon-screen' : '&#xe052;',
			'icon-laptop' : '&#xe053;',
			'icon-mobile' : '&#xe054;',
			'icon-mobile-2' : '&#xe055;',
			'icon-tablet' : '&#xe056;',
			'icon-tv' : '&#xe057;',
			'icon-cabinet' : '&#xe058;',
			'icon-drawer' : '&#xe059;',
			'icon-drawer-2' : '&#xe05a;',
			'icon-drawer-3' : '&#xe05b;',
			'icon-box-add' : '&#xe05c;',
			'icon-box-remove' : '&#xe05d;',
			'icon-download' : '&#xe05e;',
			'icon-upload' : '&#xe05f;',
			'icon-disk' : '&#xe060;',
			'icon-storage' : '&#xe061;',
			'icon-undo' : '&#xe062;',
			'icon-redo' : '&#xe063;',
			'icon-flip' : '&#xe064;',
			'icon-flip-2' : '&#xe065;',
			'icon-undo-2' : '&#xe066;',
			'icon-redo-2' : '&#xe067;',
			'icon-forward' : '&#xe068;',
			'icon-reply' : '&#xe069;',
			'icon-bubble' : '&#xe06a;',
			'icon-bubbles' : '&#xe06b;',
			'icon-bubbles-2' : '&#xe06c;',
			'icon-bubble-2' : '&#xe06d;',
			'icon-bubbles-3' : '&#xe06e;',
			'icon-bubbles-4' : '&#xe06f;',
			'icon-user' : '&#xe070;',
			'icon-users' : '&#xe071;',
			'icon-user-2' : '&#xe072;',
			'icon-users-2' : '&#xe073;',
			'icon-user-3' : '&#xe074;',
			'icon-user-4' : '&#xe075;',
			'icon-quotes-left' : '&#xe076;',
			'icon-busy' : '&#xe077;',
			'icon-spinner' : '&#xe078;',
			'icon-spinner-2' : '&#xe079;',
			'icon-spinner-3' : '&#xe07a;',
			'icon-spinner-4' : '&#xe07b;',
			'icon-spinner-5' : '&#xe07c;',
			'icon-spinner-6' : '&#xe07d;',
			'icon-binoculars' : '&#xe07e;',
			'icon-search' : '&#xe07f;',
			'icon-zoom-in' : '&#xe080;',
			'icon-zoom-out' : '&#xe081;',
			'icon-expand' : '&#xe082;',
			'icon-contract' : '&#xe083;',
			'icon-expand-2' : '&#xe084;',
			'icon-contract-2' : '&#xe085;',
			'icon-key' : '&#xe086;',
			'icon-key-2' : '&#xe087;',
			'icon-lock' : '&#xe088;',
			'icon-lock-2' : '&#xe089;',
			'icon-unlocked' : '&#xe08a;',
			'icon-wrench' : '&#xe08b;',
			'icon-settings' : '&#xe08c;',
			'icon-equalizer' : '&#xe08d;',
			'icon-cog' : '&#xe08e;',
			'icon-cogs' : '&#xe08f;',
			'icon-cog-2' : '&#xe090;',
			'icon-hammer' : '&#xe091;',
			'icon-wand' : '&#xe092;',
			'icon-aid' : '&#xe093;',
			'icon-bug' : '&#xe094;',
			'icon-pie' : '&#xe095;',
			'icon-stats' : '&#xe096;',
			'icon-bars' : '&#xe097;',
			'icon-bars-2' : '&#xe098;',
			'icon-gift' : '&#xe099;',
			'icon-trophy' : '&#xe09a;',
			'icon-glass' : '&#xe09b;',
			'icon-mug' : '&#xe09c;',
			'icon-food' : '&#xe09d;',
			'icon-leaf' : '&#xe09e;',
			'icon-rocket' : '&#xe09f;',
			'icon-meter' : '&#xe0a0;',
			'icon-meter2' : '&#xe0a1;',
			'icon-dashboard' : '&#xe0a2;',
			'icon-hammer-2' : '&#xe0a3;',
			'icon-fire' : '&#xe0a4;',
			'icon-lab' : '&#xe0a5;',
			'icon-magnet' : '&#xe0a6;',
			'icon-remove' : '&#xe0a7;',
			'icon-remove-2' : '&#xe0a8;',
			'icon-briefcase' : '&#xe0a9;',
			'icon-airplane' : '&#xe0aa;',
			'icon-truck' : '&#xe0ab;',
			'icon-road' : '&#xe0ac;',
			'icon-accessibility' : '&#xe0ad;',
			'icon-target' : '&#xe0ae;',
			'icon-shield' : '&#xe0af;',
			'icon-lightning' : '&#xe0b0;',
			'icon-switch' : '&#xe0b1;',
			'icon-power-cord' : '&#xe0b2;',
			'icon-signup' : '&#xe0b3;',
			'icon-list' : '&#xe0b4;',
			'icon-list-2' : '&#xe0b5;',
			'icon-numbered-list' : '&#xe0b6;',
			'icon-menu' : '&#xe0b7;',
			'icon-menu-2' : '&#xe0b8;',
			'icon-tree' : '&#xe0b9;',
			'icon-cloud' : '&#xe0ba;',
			'icon-cloud-download' : '&#xe0bb;',
			'icon-cloud-upload' : '&#xe0bc;',
			'icon-download-2' : '&#xe0bd;',
			'icon-upload-2' : '&#xe0be;',
			'icon-download-3' : '&#xe0bf;',
			'icon-upload-3' : '&#xe0c0;',
			'icon-globe' : '&#xe0c1;',
			'icon-earth' : '&#xe0c2;',
			'icon-link' : '&#xe0c3;',
			'icon-flag' : '&#xe0c4;',
			'icon-attachment' : '&#xe0c5;',
			'icon-eye' : '&#xe0c6;',
			'icon-eye-blocked' : '&#xe0c7;',
			'icon-eye-2' : '&#xe0c8;',
			'icon-bookmark' : '&#xe0c9;',
			'icon-bookmarks' : '&#xe0ca;',
			'icon-brightness-medium' : '&#xe0cb;',
			'icon-brightness-contrast' : '&#xe0cc;',
			'icon-contrast' : '&#xe0cd;',
			'icon-star' : '&#xe0ce;',
			'icon-star-2' : '&#xe0cf;',
			'icon-star-3' : '&#xe0d0;',
			'icon-heart' : '&#xe0d1;',
			'icon-heart-2' : '&#xe0d2;',
			'icon-heart-broken' : '&#xe0d3;',
			'icon-thumbs-up' : '&#xe0d4;',
			'icon-thumbs-up-2' : '&#xe0d5;',
			'icon-happy' : '&#xe0d6;',
			'icon-happy-2' : '&#xe0d7;',
			'icon-smiley' : '&#xe0d8;',
			'icon-smiley-2' : '&#xe0d9;',
			'icon-tongue' : '&#xe0da;',
			'icon-tongue-2' : '&#xe0db;',
			'icon-sad' : '&#xe0dc;',
			'icon-sad-2' : '&#xe0dd;',
			'icon-wink' : '&#xe0de;',
			'icon-wink-2' : '&#xe0df;',
			'icon-grin' : '&#xe0e0;',
			'icon-grin-2' : '&#xe0e1;',
			'icon-cool' : '&#xe0e2;',
			'icon-cool-2' : '&#xe0e3;',
			'icon-angry' : '&#xe0e4;',
			'icon-angry-2' : '&#xe0e5;',
			'icon-evil' : '&#xe0e6;',
			'icon-evil-2' : '&#xe0e7;',
			'icon-shocked' : '&#xe0e8;',
			'icon-shocked-2' : '&#xe0e9;',
			'icon-confused' : '&#xe0ea;',
			'icon-confused-2' : '&#xe0eb;',
			'icon-neutral' : '&#xe0ec;',
			'icon-neutral-2' : '&#xe0ed;',
			'icon-wondering' : '&#xe0ee;',
			'icon-wondering-2' : '&#xe0ef;',
			'icon-point-up' : '&#xe0f0;',
			'icon-point-right' : '&#xe0f1;',
			'icon-point-down' : '&#xe0f2;',
			'icon-point-left' : '&#xe0f3;',
			'icon-warning' : '&#xe0f4;',
			'icon-notification' : '&#xe0f5;',
			'icon-question' : '&#xe0f6;',
			'icon-info' : '&#xe0f7;',
			'icon-info-2' : '&#xe0f8;',
			'icon-blocked' : '&#xe0f9;',
			'icon-cancel-circle' : '&#xe0fa;',
			'icon-checkmark-circle' : '&#xe0fb;',
			'icon-spam' : '&#xe0fc;',
			'icon-close' : '&#xe0fd;',
			'icon-checkmark' : '&#xe0fe;',
			'icon-checkmark-2' : '&#xe0ff;',
			'icon-spell-check' : '&#xe100;',
			'icon-minus' : '&#xe101;',
			'icon-plus' : '&#xe102;',
			'icon-enter' : '&#xe103;',
			'icon-exit' : '&#xe104;',
			'icon-play-2' : '&#xe105;',
			'icon-pause' : '&#xe106;',
			'icon-stop' : '&#xe107;',
			'icon-backward' : '&#xe108;',
			'icon-forward-2' : '&#xe109;',
			'icon-play-3' : '&#xe10a;',
			'icon-pause-2' : '&#xe10b;',
			'icon-stop-2' : '&#xe10c;',
			'icon-backward-2' : '&#xe10d;',
			'icon-forward-3' : '&#xe10e;',
			'icon-first' : '&#xe10f;',
			'icon-last' : '&#xe110;',
			'icon-previous' : '&#xe111;',
			'icon-next' : '&#xe112;',
			'icon-eject' : '&#xe113;',
			'icon-volume-high' : '&#xe114;',
			'icon-volume-medium' : '&#xe115;',
			'icon-volume-low' : '&#xe116;',
			'icon-volume-mute' : '&#xe117;',
			'icon-volume-mute-2' : '&#xe118;',
			'icon-volume-increase' : '&#xe119;',
			'icon-volume-decrease' : '&#xe11a;',
			'icon-loop' : '&#xe11b;',
			'icon-loop-2' : '&#xe11c;',
			'icon-loop-3' : '&#xe11d;',
			'icon-shuffle' : '&#xe11e;',
			'icon-arrow-up-left' : '&#xe11f;',
			'icon-arrow-up' : '&#xe120;',
			'icon-arrow-up-right' : '&#xe121;',
			'icon-arrow-right' : '&#xe122;',
			'icon-arrow-down-right' : '&#xe123;',
			'icon-arrow-down' : '&#xe124;',
			'icon-arrow-down-left' : '&#xe125;',
			'icon-arrow-left' : '&#xe126;',
			'icon-arrow-up-left-2' : '&#xe127;',
			'icon-arrow-up-2' : '&#xe128;',
			'icon-arrow-up-right-2' : '&#xe129;',
			'icon-arrow-right-2' : '&#xe12a;',
			'icon-arrow-down-right-2' : '&#xe12b;',
			'icon-arrow-down-2' : '&#xe12c;',
			'icon-arrow-down-left-2' : '&#xe12d;',
			'icon-arrow-left-2' : '&#xe12e;',
			'icon-arrow-up-left-3' : '&#xe12f;',
			'icon-arrow-up-3' : '&#xe130;',
			'icon-arrow-up-right-3' : '&#xe131;',
			'icon-arrow-right-3' : '&#xe132;',
			'icon-arrow-down-right-3' : '&#xe133;',
			'icon-arrow-down-3' : '&#xe134;',
			'icon-arrow-down-left-3' : '&#xe135;',
			'icon-arrow-left-3' : '&#xe136;',
			'icon-tab' : '&#xe137;',
			'icon-checkbox-checked' : '&#xe138;',
			'icon-checkbox-unchecked' : '&#xe139;',
			'icon-checkbox-partial' : '&#xe13a;',
			'icon-radio-checked' : '&#xe13b;',
			'icon-radio-unchecked' : '&#xe13c;',
			'icon-crop' : '&#xe13d;',
			'icon-scissors' : '&#xe13e;',
			'icon-filter' : '&#xe13f;',
			'icon-filter-2' : '&#xe140;',
			'icon-font' : '&#xe141;',
			'icon-text-height' : '&#xe142;',
			'icon-text-width' : '&#xe143;',
			'icon-bold' : '&#xe144;',
			'icon-underline' : '&#xe145;',
			'icon-italic' : '&#xe146;',
			'icon-strikethrough' : '&#xe147;',
			'icon-omega' : '&#xe148;',
			'icon-sigma' : '&#xe149;',
			'icon-table' : '&#xe14a;',
			'icon-table-2' : '&#xe14b;',
			'icon-insert-template' : '&#xe14c;',
			'icon-pilcrow' : '&#xe14d;',
			'icon-left-to-right' : '&#xe14e;',
			'icon-right-to-left' : '&#xe14f;',
			'icon-paragraph-left' : '&#xe150;',
			'icon-paragraph-center' : '&#xe151;',
			'icon-paragraph-right' : '&#xe152;',
			'icon-paragraph-justify' : '&#xe153;',
			'icon-paragraph-left-2' : '&#xe154;',
			'icon-paragraph-center-2' : '&#xe155;',
			'icon-paragraph-right-2' : '&#xe156;',
			'icon-paragraph-justify-2' : '&#xe157;',
			'icon-indent-increase' : '&#xe158;',
			'icon-indent-decrease' : '&#xe159;',
			'icon-new-tab' : '&#xe15a;',
			'icon-embed' : '&#xe15b;',
			'icon-code' : '&#xe15c;',
			'icon-console' : '&#xe15d;',
			'icon-share' : '&#xe15e;',
			'icon-mail' : '&#xe15f;',
			'icon-mail-2' : '&#xe160;',
			'icon-mail-3' : '&#xe161;',
			'icon-mail-4' : '&#xe162;',
			'icon-google' : '&#xe163;',
			'icon-google-plus' : '&#xe164;',
			'icon-google-plus-2' : '&#xe165;',
			'icon-google-plus-3' : '&#xe166;',
			'icon-google-plus-4' : '&#xe167;',
			'icon-google-drive' : '&#xe168;',
			'icon-facebook' : '&#xe169;',
			'icon-facebook-2' : '&#xe16a;',
			'icon-facebook-3' : '&#xe16b;',
			'icon-instagram' : '&#xe16c;',
			'icon-twitter' : '&#xe16d;',
			'icon-twitter-2' : '&#xe16e;',
			'icon-twitter-3' : '&#xe16f;',
			'icon-feed-2' : '&#xe170;',
			'icon-feed-3' : '&#xe171;',
			'icon-feed-4' : '&#xe172;',
			'icon-youtube' : '&#xe173;',
			'icon-youtube-2' : '&#xe174;',
			'icon-vimeo' : '&#xe175;',
			'icon-vimeo2' : '&#xe176;',
			'icon-vimeo-2' : '&#xe177;',
			'icon-lanyrd' : '&#xe178;',
			'icon-flickr' : '&#xe179;',
			'icon-flickr-2' : '&#xe17a;',
			'icon-flickr-3' : '&#xe17b;',
			'icon-flickr-4' : '&#xe17c;',
			'icon-picassa' : '&#xe17d;',
			'icon-picassa-2' : '&#xe17e;',
			'icon-dribbble' : '&#xe17f;',
			'icon-dribbble-2' : '&#xe180;',
			'icon-dribbble-3' : '&#xe181;',
			'icon-forrst' : '&#xe182;',
			'icon-forrst-2' : '&#xe183;',
			'icon-deviantart' : '&#xe184;',
			'icon-deviantart-2' : '&#xe185;',
			'icon-steam' : '&#xe186;',
			'icon-steam-2' : '&#xe187;',
			'icon-github' : '&#xe188;',
			'icon-github-2' : '&#xe189;',
			'icon-github-3' : '&#xe18a;',
			'icon-github-4' : '&#xe18b;',
			'icon-github-5' : '&#xe18c;',
			'icon-wordpress' : '&#xe18d;',
			'icon-wordpress-2' : '&#xe18e;',
			'icon-joomla' : '&#xe18f;',
			'icon-blogger' : '&#xe190;',
			'icon-blogger-2' : '&#xe191;',
			'icon-tumblr' : '&#xe192;',
			'icon-tumblr-2' : '&#xe193;',
			'icon-yahoo' : '&#xe194;',
			'icon-tux' : '&#xe195;',
			'icon-apple' : '&#xe196;',
			'icon-finder' : '&#xe197;',
			'icon-android' : '&#xe198;',
			'icon-windows' : '&#xe199;',
			'icon-windows8' : '&#xe19a;',
			'icon-soundcloud' : '&#xe19b;',
			'icon-soundcloud-2' : '&#xe19c;',
			'icon-skype' : '&#xe19d;',
			'icon-reddit' : '&#xe19e;',
			'icon-linkedin' : '&#xe19f;',
			'icon-lastfm' : '&#xe1a0;',
			'icon-lastfm-2' : '&#xe1a1;',
			'icon-delicious' : '&#xe1a2;',
			'icon-stumbleupon' : '&#xe1a3;',
			'icon-stumbleupon-2' : '&#xe1a4;',
			'icon-stackoverflow' : '&#xe1a5;',
			'icon-pinterest' : '&#xe1a6;',
			'icon-pinterest-2' : '&#xe1a7;',
			'icon-xing' : '&#xe1a8;',
			'icon-xing-2' : '&#xe1a9;',
			'icon-flattr' : '&#xe1aa;',
			'icon-foursquare' : '&#xe1ab;',
			'icon-foursquare-2' : '&#xe1ac;',
			'icon-paypal' : '&#xe1ad;',
			'icon-paypal-2' : '&#xe1ae;',
			'icon-paypal-3' : '&#xe1af;',
			'icon-yelp' : '&#xe1b0;',
			'icon-libreoffice' : '&#xe1b1;',
			'icon-file-pdf' : '&#xe1b2;',
			'icon-file-openoffice' : '&#xe1b3;',
			'icon-file-word' : '&#xe1b4;',
			'icon-file-excel' : '&#xe1b5;',
			'icon-file-zip' : '&#xe1b6;',
			'icon-file-powerpoint' : '&#xe1b7;',
			'icon-file-xml' : '&#xe1b8;',
			'icon-file-css' : '&#xe1b9;',
			'icon-html5' : '&#xe1ba;',
			'icon-html5-2' : '&#xe1bb;',
			'icon-css3' : '&#xe1bc;',
			'icon-chrome' : '&#xe1bd;',
			'icon-firefox' : '&#xe1be;',
			'icon-IE' : '&#xe1bf;',
			'icon-opera' : '&#xe1c0;',
			'icon-safari' : '&#xe1c1;',
			'icon-IcoMoon' : '&#xe1c2;'
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