-- --------------------------------------------------------
-- SQL-Dump NutMouse CMS System v0.2 (ohne Demodaten)
-- --------------------------------------------------------


--
-- Tabellenstruktur für Tabelle `bd_main_address`
--

DROP TABLE IF EXISTS `bd_main_address`;
CREATE TABLE IF NOT EXISTS `bd_main_address` (
  `addressKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `addressGender` enum('m','f') COLLATE latin1_german2_ci DEFAULT NULL,
  `addressName` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `addressLastName` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `addressCountry` bigint(20) unsigned DEFAULT NULL,
  `addressCity` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `addressZIP` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `addressStreet` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `addressStreetNumber` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `addressTel` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `addressMobile` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `addressNote` text COLLATE latin1_german2_ci,
  `addressEmail` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `addressWebsite` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  PRIMARY KEY (`addressKey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_banner`
--

DROP TABLE IF EXISTS `bd_main_banner`;
CREATE TABLE IF NOT EXISTS `bd_main_banner` (
  `bannerKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bannerName` varchar(45) COLLATE latin1_german2_ci NOT NULL,
  `bannerNote` text COLLATE latin1_german2_ci,
  PRIMARY KEY (`bannerKey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_banner_element`
--

DROP TABLE IF EXISTS `bd_main_banner_element`;
CREATE TABLE IF NOT EXISTS `bd_main_banner_element` (
  `elementKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `elementBannerKey` bigint(20) unsigned NOT NULL,
  `elementNote` text COLLATE latin1_german2_ci,
  `elementName` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `elementText` text COLLATE latin1_german2_ci,
  `elementLink` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `elementLinkTarget` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `elementLinkTitle` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `elementCreated` datetime NOT NULL,
  `elementLastChanged` datetime NOT NULL,
  `elementLastChangedBy` bigint(20) unsigned NOT NULL,
  `elementActive` tinyint(1) unsigned NOT NULL,
  `elementPos` int(10) unsigned NOT NULL,
  PRIMARY KEY (`elementKey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_contact`
--

DROP TABLE IF EXISTS `bd_main_contact`;
CREATE TABLE IF NOT EXISTS `bd_main_contact` (
  `contactKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `contactName` varchar(255) NOT NULL,
  `contactLastName` varchar(255) NOT NULL,
  `contactGroupKey` bigint(20) unsigned DEFAULT NULL,
  `contactLogin` varchar(255) NOT NULL,
  `contactPassword` varchar(255) NOT NULL,
  `contactEmail` varchar(255) DEFAULT NULL,
  `contactWebsite` varchar(255) DEFAULT NULL,
  `contactCreated` datetime DEFAULT NULL,
  `contactLastChanged` datetime DEFAULT NULL,
  `contactConfirmKey` varchar(255) DEFAULT NULL,
  `contactActive` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`contactKey`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_contact_address`
--

DROP TABLE IF EXISTS `bd_main_contact_address`;
CREATE TABLE IF NOT EXISTS `bd_main_contact_address` (
  `addressKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `addressContactKey` bigint(20) unsigned NOT NULL,
  `addressGender` enum('m','f') COLLATE latin1_german2_ci DEFAULT NULL,
  `addressName` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `addressLastName` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `addressCountry` bigint(20) unsigned DEFAULT NULL,
  `addressCity` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `addressZIP` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `addressStreet` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `addressStreetNumber` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `addressTel` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `addressMobile` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `addressNote` text COLLATE latin1_german2_ci,
  `addressType` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `addressPos` int(10) unsigned NOT NULL,
  PRIMARY KEY (`addressKey`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_contact_group`
--

DROP TABLE IF EXISTS `bd_main_contact_group`;
CREATE TABLE IF NOT EXISTS `bd_main_contact_group` (
  `groupKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `groupName` varchar(255) NOT NULL,
  `groupNote` text,
  PRIMARY KEY (`groupKey`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_content`
--

DROP TABLE IF EXISTS `bd_main_content`;
CREATE TABLE IF NOT EXISTS `bd_main_content` (
  `contentKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `contentPath` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `contentTitle` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `contentMenu` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`contentKey`),
  UNIQUE KEY `contentPath` (`contentPath`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=11 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_content_version`
--

DROP TABLE IF EXISTS `bd_main_content_version`;
CREATE TABLE IF NOT EXISTS `bd_main_content_version` (
  `versionKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `versionActive` tinyint(1) unsigned NOT NULL,
  `versionContentKey` bigint(20) NOT NULL,
  `versionNumber` int(10) unsigned NOT NULL,
  `versionText` text COLLATE latin1_german2_ci NOT NULL,
  `versionAuthor` bigint(20) unsigned NOT NULL,
  `versionCreated` datetime NOT NULL,
  `versionLastChanged` datetime NOT NULL,
  `versionNote` text COLLATE latin1_german2_ci NOT NULL,
  `versionTemplate` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `versionKeywords` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  PRIMARY KEY (`versionKey`),
  KEY `versionActive` (`versionActive`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=13 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_country`
--

DROP TABLE IF EXISTS `bd_main_country`;
CREATE TABLE IF NOT EXISTS `bd_main_country` (
  `countryKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `countryName` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `countryISO` char(3) COLLATE latin1_german2_ci DEFAULT NULL,
  `countryNote` text COLLATE latin1_german2_ci,
  `countryActive` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`countryKey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_event`
--

DROP TABLE IF EXISTS `bd_main_event`;
CREATE TABLE IF NOT EXISTS `bd_main_event` (
  `eventKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `eventDate` datetime NOT NULL,
  `eventName` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `eventNote` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `eventCreated` datetime NOT NULL,
  `eventLastChanged` datetime NOT NULL,
  `eventLastChangedBy` bigint(20) unsigned NOT NULL,
  `eventPublic` tinyint(1) DEFAULT NULL,
  `eventType` bigint(20) unsigned NOT NULL,
  `eventRepeat` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `eventReminder` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `eventReminderEmail` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  PRIMARY KEY (`eventKey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_form`
--

DROP TABLE IF EXISTS `bd_main_form`;
CREATE TABLE IF NOT EXISTS `bd_main_form` (
  `formKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `formName` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `formNote` text COLLATE latin1_german2_ci,
  `formSendTo` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `formSendCC` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `formSendSubject` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `formSendText` text COLLATE latin1_german2_ci,
  `formCaptcha` tinyint(1) unsigned NOT NULL,
  `formAction` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `formMethod` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `formSendFrom` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `formSendBCC` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  PRIMARY KEY (`formKey`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_form_element`
--

DROP TABLE IF EXISTS `bd_main_form_element`;
CREATE TABLE IF NOT EXISTS `bd_main_form_element` (
  `elementKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `elementLabel` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `elementType` bigint(20) unsigned NOT NULL,
  `elementOptions` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `elementHelp` text COLLATE latin1_german2_ci,
  `elementNote` text COLLATE latin1_german2_ci,
  `elementRequired` tinyint(1) DEFAULT NULL,
  `elementDefaultValue` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `elementPos` int(10) DEFAULT NULL,
  `elementFormKey` bigint(20) DEFAULT NULL,
  `elementName` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `elementActive` tinyint(1) NOT NULL,
  PRIMARY KEY (`elementKey`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=10 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_form_element_type`
--

DROP TABLE IF EXISTS `bd_main_form_element_type`;
CREATE TABLE IF NOT EXISTS `bd_main_form_element_type` (
  `typeKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `typeTag` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `typeAllowOptions` tinyint(1) unsigned NOT NULL,
  `typeLabel` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  PRIMARY KEY (`typeKey`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=10 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_galery`
--

DROP TABLE IF EXISTS `bd_main_galery`;
CREATE TABLE IF NOT EXISTS `bd_main_galery` (
  `galeryKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `galeryPos` int(10) unsigned DEFAULT NULL,
  `galeryDate` datetime DEFAULT NULL,
  `galeryTitle` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `galeryDesc` text COLLATE latin1_german2_ci,
  `galeryActive` tinyint(1) unsigned NOT NULL,
  `galeryCreated` datetime NOT NULL,
  PRIMARY KEY (`galeryKey`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=7 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_galery_image`
--

DROP TABLE IF EXISTS `bd_main_galery_image`;
CREATE TABLE IF NOT EXISTS `bd_main_galery_image` (
  `imageKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `imageGaleryKey` bigint(20) unsigned NOT NULL,
  `imageFilename` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `imageCreated` datetime NOT NULL,
  `imageTitle` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `imageDesc` text COLLATE latin1_german2_ci,
  `imagePos` int(10) unsigned NOT NULL,
  PRIMARY KEY (`imageKey`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=41 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_menu`
--

DROP TABLE IF EXISTS `bd_main_menu`;
CREATE TABLE IF NOT EXISTS `bd_main_menu` (
  `menuKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `menuName` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `menuNote` text COLLATE latin1_german2_ci,
  `menuActive` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`menuKey`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=6 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_menu_element`
--

DROP TABLE IF EXISTS `bd_main_menu_element`;
CREATE TABLE IF NOT EXISTS `bd_main_menu_element` (
  `elementKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `elementLabel` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `elementParent` bigint(20) unsigned DEFAULT NULL,
  `elementMenuKey` bigint(20) unsigned NOT NULL,
  `elementLink` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `elementLinkTarget` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `elementPos` int(10) unsigned NOT NULL,
  `elementActive` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`elementKey`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=7 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_newsletter`
--

DROP TABLE IF EXISTS `bd_main_newsletter`;
CREATE TABLE IF NOT EXISTS `bd_main_newsletter` (
  `newsletterKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `newsletterThemeKey` bigint(20) unsigned DEFAULT NULL,
  `newsletterSender` varchar(255) NOT NULL,
  `newsletterSubject` varchar(255) NOT NULL,
  `newsletterCc` varchar(255) DEFAULT NULL,
  `newsletterBcc` varchar(255) DEFAULT NULL,
  `newsletterText` text NOT NULL,
  `newsletterDate` datetime NOT NULL,
  `newsletterSend` tinyint(1) NOT NULL,
  `newsletterSendDate` datetime NOT NULL,
  `newsletterReferer` varchar(255) DEFAULT NULL,
  `newsletterNote` text,
  PRIMARY KEY (`newsletterKey`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_newsletter_theme`
--

DROP TABLE IF EXISTS `bd_main_newsletter_theme`;
CREATE TABLE IF NOT EXISTS `bd_main_newsletter_theme` (
  `themeKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `themeName` varchar(255) NOT NULL,
  `themeDesc` text,
  `themeNote` text,
  PRIMARY KEY (`themeKey`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_newsletter_to_contact`
--

DROP TABLE IF EXISTS `bd_main_newsletter_to_contact`;
CREATE TABLE IF NOT EXISTS `bd_main_newsletter_to_contact` (
  `toNewsletterThemeKey` bigint(20) unsigned NOT NULL,
  `toContactKey` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`toNewsletterThemeKey`,`toContactKey`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_news`
--

DROP TABLE IF EXISTS `bd_main_news`;
CREATE TABLE IF NOT EXISTS `bd_main_news` (
  `newsKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `newsPath` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `newsCreated` datetime NOT NULL,
  `newsLastChanged` datetime NOT NULL,
  `newsAuthor` bigint(20) NOT NULL,
  `newsReleaseDate` datetime NOT NULL,
  `newsTitle` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `newsIntro` text COLLATE latin1_german2_ci,
  `newsText` text COLLATE latin1_german2_ci,
  `newsNote` text COLLATE latin1_german2_ci,
  `newsKategory` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `newsKeywords` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  PRIMARY KEY (`newsKey`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=17 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_news_comment`
--

DROP TABLE IF EXISTS `bd_main_news_comment`;
CREATE TABLE IF NOT EXISTS `bd_main_news_comment` (
  `commentKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `commentParent` bigint(20) unsigned DEFAULT NULL,
  `commentDate` datetime NOT NULL,
  `commentNewsKey` bigint(20) unsigned NOT NULL,
  `commentName` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `commentSubject` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `commentEmail` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `commentHomepage` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `commentUserKey` bigint(20) unsigned DEFAULT NULL,
  `commentSession` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `commentIP` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `commentActive` tinyint(1) unsigned NOT NULL,
  `commentText` text COLLATE latin1_german2_ci,
  PRIMARY KEY (`commentKey`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=7 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_main_user`
--

DROP TABLE IF EXISTS `bd_main_user`;
CREATE TABLE IF NOT EXISTS `bd_main_user` (
  `userKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `userAddress` bigint(20) DEFAULT NULL,
  `userLogin` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `userPassword` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `userLastLogin` datetime DEFAULT NULL,
  `userLastSession` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `userLastIP` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `userCreated` datetime NOT NULL,
  `userLastChanged` datetime DEFAULT NULL,
  `userLastChangedBy` bigint(20) unsigned DEFAULT NULL,
  `userNote` text COLLATE latin1_german2_ci,
  PRIMARY KEY (`userKey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_stats_session`
--

CREATE TABLE IF NOT EXISTS `bd_stats_session` (
  `statsSessionKey` bigint(20) NOT NULL AUTO_INCREMENT,
  `statsSessionId` varchar(255) CHARACTER SET latin1 NOT NULL,
  `statsSessionEnterDate` datetime NOT NULL,
  `statsSessionReferer` varchar(255) CHARACTER SET latin1 NOT NULL,
  `statsSessionUserAgent` varchar(255) CHARACTER SET latin1 NOT NULL,
  `statsSessionRemoteAddress` varchar(255) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`statsSessionKey`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_stats_site`
--

CREATE TABLE IF NOT EXISTS `bd_stats_site` (
  `statsSiteKey` bigint(20) NOT NULL AUTO_INCREMENT,
  `statsSiteURL` varchar(255) CHARACTER SET latin1 NOT NULL,
  `statsSiteDate` datetime NOT NULL,
  `statsSiteSessionId` varchar(255) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`statsSiteKey`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_sys_admin_group`
--

DROP TABLE IF EXISTS `bd_sys_admin_group`;
CREATE TABLE IF NOT EXISTS `bd_sys_admin_group` (
  `groupKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `groupName` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `groupNote` text COLLATE latin1_german2_ci,
  PRIMARY KEY (`groupKey`),
  UNIQUE KEY `groupName_UNIQUE` (`groupName`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_sys_admin_menu`
--

DROP TABLE IF EXISTS `bd_sys_admin_menu`;
CREATE TABLE IF NOT EXISTS `bd_sys_admin_menu` (
  `menuKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `menuParent` bigint(20) unsigned DEFAULT NULL,
  `menuLabel` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `menuNote` text COLLATE latin1_german2_ci,
  `menuType` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `menuPos` int(10) unsigned NOT NULL,
  `menuLink` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `menuActive` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`menuKey`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=18 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_sys_admin_module`
--

DROP TABLE IF EXISTS `bd_sys_admin_module`;
CREATE TABLE IF NOT EXISTS `bd_sys_admin_module` (
  `moduleKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `modulePath` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `moduleMenu` bigint(20) unsigned NOT NULL,
  `moduleName` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `moduleNote` text COLLATE latin1_german2_ci,
  `moduleTemplate` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `moduleCoreFile` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `moduleActive` tinyint(1) unsigned NOT NULL,
  `moduleVersion` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `moduleAuthor` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `moduleReleaseDate` datetime DEFAULT NULL,
  `modulePlugin` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`moduleKey`),
  UNIQUE KEY `modulePath_UNIQUE` (`modulePath`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=12 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_sys_admin_quicklist`
--

DROP TABLE IF EXISTS `bd_sys_admin_quicklist`;
CREATE TABLE IF NOT EXISTS `bd_sys_admin_quicklist` (
  `quicklistMenu` bigint(20) unsigned NOT NULL,
  `quicklistAdminUser` bigint(20) unsigned NOT NULL,
  `quicklistNote` text COLLATE latin1_german2_ci,
  PRIMARY KEY (`quicklistMenu`,`quicklistAdminUser`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_sys_admin_right`
--

DROP TABLE IF EXISTS `bd_sys_admin_right`;
CREATE TABLE IF NOT EXISTS `bd_sys_admin_right` (
  `rightModuleKey` bigint(20) unsigned NOT NULL,
  `rightGroupKey` bigint(20) unsigned NOT NULL,
  `rightAccess` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`rightModuleKey`,`rightGroupKey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_sys_admin_user`
--

DROP TABLE IF EXISTS `bd_sys_admin_user`;
CREATE TABLE IF NOT EXISTS `bd_sys_admin_user` (
  `adminKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `adminLogin` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `adminPassword` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `adminName` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `adminLastName` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `adminGender` enum('m','f') COLLATE latin1_german2_ci DEFAULT NULL,
  `adminGroupKey` bigint(20) unsigned NOT NULL,
  `adminNote` text COLLATE latin1_german2_ci,
  `adminLastLogin` datetime DEFAULT NULL,
  PRIMARY KEY (`adminKey`),
  UNIQUE KEY `adminLogin_UNIQUE` (`adminLogin`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=6 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_sys_config`
--

DROP TABLE IF EXISTS `bd_sys_config`;
CREATE TABLE IF NOT EXISTS `bd_sys_config` (
  `configKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `configLabel` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `configValue` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `configType` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `configNote` text COLLATE latin1_german2_ci,
  PRIMARY KEY (`configKey`),
  UNIQUE KEY `configLabel_UNIQUE` (`configLabel`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_sys_log`
--

DROP TABLE IF EXISTS `bd_sys_log`;
CREATE TABLE IF NOT EXISTS `bd_sys_log` (
  `logKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `logType` char(3) COLLATE latin1_german2_ci NOT NULL,
  `logText` text COLLATE latin1_german2_ci NOT NULL,
  `logDate` datetime NOT NULL,
  `logSession` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `logIP` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `logSource` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  PRIMARY KEY (`logKey`),
  KEY `INDEX` (`logType`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_sys_message`
--

DROP TABLE IF EXISTS `bd_sys_message`;
CREATE TABLE IF NOT EXISTS `bd_sys_message` (
  `messageKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `messageDate` datetime NOT NULL,
  `messageFrom` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `messageTo` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `messageSubject` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `messageText` text COLLATE latin1_german2_ci,
  `messageCC` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `messageType` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `messageNote` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  PRIMARY KEY (`messageKey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_sys_message_read`
--

DROP TABLE IF EXISTS `bd_sys_message_read`;
CREATE TABLE IF NOT EXISTS `bd_sys_message_read` (
  `readMessage` bigint(20) unsigned NOT NULL,
  `readAdminUser` bigint(20) unsigned NOT NULL,
  `readStatus` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`readMessage`,`readAdminUser`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bd_sys_plugin`
--

DROP TABLE IF EXISTS `bd_sys_plugin`;
CREATE TABLE IF NOT EXISTS `bd_sys_plugin` (
  `pluginKey` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pluginName` varchar(255) COLLATE latin1_german2_ci NOT NULL,
  `pluginLabel` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `pluginDesc` text COLLATE latin1_german2_ci,
  `pluginAuthor` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `pluginVersion` varchar(255) COLLATE latin1_german2_ci DEFAULT NULL,
  `pluginInstalled` datetime NOT NULL,
  `pluginActive` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`pluginKey`),
  UNIQUE KEY `pluginName` (`pluginName`),
  KEY `pluginActive` (`pluginActive`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=26 ;


-- --------------------------------------------------------

--
-- Daten für Tabelle `bd_sys_config`
--

INSERT INTO `bd_sys_config` (`configKey`, `configLabel`, `configValue`, `configType`, `configNote`) VALUES
(1, 'maintitle', 'Testseite', 'string', NULL),
(2, 'theme', '', 'string', NULL),
(3, 'enable_cache', '0', 'int', NULL);

--
-- Daten für Tabelle `bd_sys_admin_group`
--

INSERT INTO `bd_sys_admin_group` (`groupKey`, `groupName`, `groupNote`) VALUES
(1, 'root', NULL);

--
-- Daten für Tabelle `bd_sys_admin_menu`
--

INSERT INTO `bd_sys_admin_menu` (`menuKey`, `menuParent`, `menuLabel`, `menuNote`, `menuType`, `menuPos`, `menuLink`, `menuActive`) VALUES
(1, NULL, 'Home', NULL, NULL, 100, '/', 1),
(2, NULL, 'Konfiguration', NULL, NULL, 200, '/konfiguration/grundeinstellungen', 1),
(3, NULL, 'Inhalte', NULL, NULL, 300, '/inhalte/seiteninhalte', 1),
(4, NULL, 'Kalender', NULL, 'icon', 100, '/kalender', 0),
(5, NULL, 'Nachrichten', NULL, 'icon', 200, '/nachrichten', 0),
(6, NULL, 'Statistiken', NULL, 'icon', 300, '/statistiken', 0),
(7, 2, 'Grundeinstellungen', NULL, NULL, 100, '/konfiguration/grundeinstellungen', 1),
(8, 3, 'Seiteninhalte verwalten', NULL, NULL, 100, '/inhalte/seiteninhalte', 1),
(9, 3, 'Dateiverwaltung', NULL, NULL, 200, '/inhalte/dateiverwaltung', 1),
(10, 3, 'News', NULL, NULL, 300, '/inhalte/news', 1),
(11, 2, 'Plugins', NULL, NULL, 200, '/konfiguration/plugins', 1),
(12, 2, 'Cache', NULL, NULL, 300, '/konfiguration/cache', 1),
(13, 3, 'Men&uuml;s', NULL, NULL, 400, '/inhalte/menus', 1),
(14, 3, 'Bildergalerien', NULL, NULL, 500, '/inhalte/bildergalerien', 1),
(15, 2, 'Benutzerverwaltung', NULL, NULL, 400, '/konfiguration/benutzerverwaltung', 1),
(17, 3, 'Formulare', NULL, NULL, 600, '/inhalte/formulare', 1);

--
-- Daten für Tabelle `bd_sys_admin_module`
--

INSERT INTO `bd_sys_admin_module` (`moduleKey`, `modulePath`, `moduleMenu`, `moduleName`, `moduleNote`, `moduleTemplate`, `moduleCoreFile`, `moduleActive`, `moduleVersion`, `moduleAuthor`, `moduleReleaseDate`, `modulePlugin`) VALUES
(1, 'konfiguration/grundeinstellungen', 7, 'Konfiguration > Grundeinstellungen', NULL, NULL, 'config/basic', 1, '0.1', 'BurrDesign', NULL, 0),
(2, '', 1, 'Dashboard', NULL, 'home', 'dashboard', 1, '0.1', 'BurrDesign', NULL, 0),
(3, 'inhalte/dateiverwaltung', 9, 'Inhalte > Dateiverwaltung', NULL, NULL, 'content/files', 1, '0.1', 'BurrDesign', NULL, 0),
(4, 'inhalte/seiteninhalte', 8, 'Inhalte > Seiteninhalte', NULL, NULL, 'content/sites', 1, '0.1', 'BurrDesign', NULL, 0),
(5, 'inhalte/news', 10, 'Inhalte > News', NULL, NULL, 'content/news', 1, '0.1', 'BurrDesign', NULL, 0),
(6, 'konfiguration/plugins', 11, 'Konfiguration > Plugins', NULL, NULL, 'config/plugins', 1, '0.1', 'BurrDesign', NULL, 0),
(7, 'konfiguration/cache', 12, 'Konfiguration > Cache', NULL, NULL, 'config/cache', 1, '0.1', 'BurrDesign', NULL, 0),
(8, 'inhalte/menus', 13, 'Inhalte > Men&uuml;s', NULL, NULL, 'content/menus', 1, '0.1', 'BurrDesign', NULL, 0),
(9, 'inhalte/bildergalerien', 14, 'Inhalte > Bildergalerien', NULL, NULL, 'content/galeries', 1, '0.1', 'BurrDesign', NULL, 0),
(10, 'konfiguration/benutzerverwaltung', 15, 'Konfiguration > Benutzerverwaltung', NULL, NULL, 'config/users', 1, '0.1', 'BurrDesign', NULL, 0),
(11, 'inhalte/formulare', 17, 'Inhalte > Formulare', NULL, NULL, 'content/forms', 1, '0.1', 'BurrDesign', NULL, 0);

--
-- Daten für Tabelle `bd_sys_admin_right`
--

INSERT INTO `bd_sys_admin_right` (`rightModuleKey`, `rightGroupKey`, `rightAccess`) VALUES
(1, 1, 1),
(2, 1, 1),
(3, 1, 1),
(4, 1, 1),
(5, 1, 1),
(6, 1, 1),
(7, 1, 1),
(8, 1, 1),
(9, 1, 1),
(10, 1, 1),
(11, 1, 1);

--
-- Daten für Tabelle `bd_main_country`
--

INSERT INTO `bd_main_country` (`countryKey`, `countryName`, `countryISO`, `countryNote`, `countryActive`) VALUES
(1, 'Afghanistan', 'AF', NULL, 1),
(2, 'Ägypten', 'EG', NULL, 1),
(3, 'Albanien', 'AL', NULL, 1),
(4, 'Algerien', 'DZ', NULL, 1),
(5, 'Andorra', 'AD', NULL, 1),
(6, 'Angola', 'AO', NULL, 1),
(7, 'Anguilla', 'AI', NULL, 1),
(8, 'Antarktis', 'AQ', NULL, 1),
(9, 'Antigua und Barbuda', 'AG', NULL, 1),
(10, 'Äquatorial Guinea', 'GQ', NULL, 1),
(11, 'Argentinien', 'AR', NULL, 1),
(12, 'Armenien', 'AM', NULL, 1),
(13, 'Aruba', 'AW', NULL, 1),
(14, 'Aserbaidschan', 'AZ', NULL, 1),
(15, 'Äthiopien', 'ET', NULL, 1),
(16, 'Australien', 'AU', NULL, 1),
(17, 'Bahamas', 'BS', NULL, 1),
(18, 'Bahrain', 'BH', NULL, 1),
(19, 'Bangladesh', 'BD', NULL, 1),
(20, 'Barbados', 'BB', NULL, 1),
(21, 'Belgien', 'BE', NULL, 1),
(22, 'Belize', 'BZ', NULL, 1),
(23, 'Benin', 'BJ', NULL, 1),
(24, 'Bermudas', 'BM', NULL, 1),
(25, 'Bhutan', 'BT', NULL, 1),
(26, 'Birma', 'MM', NULL, 1),
(27, 'Bolivien', 'BO', NULL, 1),
(28, 'Bosnien-Herzegowina', 'BA', NULL, 1),
(29, 'Botswana', 'BW', NULL, 1),
(30, 'Bouvet Inseln', 'BV', NULL, 1),
(31, 'Brasilien', 'BR', NULL, 1),
(32, 'Britisch-Indischer Ozean', 'IO', NULL, 1),
(33, 'Brunei', 'BN', NULL, 1),
(34, 'Bulgarien', 'BG', NULL, 1),
(35, 'Burkina Faso', 'BF', NULL, 1),
(36, 'Burundi', 'BI', NULL, 1),
(37, 'Chile', 'CL', NULL, 1),
(38, 'China', 'CN', NULL, 1),
(39, 'Christmas Island', 'CX', NULL, 1),
(40, 'Cook Inseln', 'CK', NULL, 1),
(41, 'Costa Rica', 'CR', NULL, 1),
(42, 'Dänemark', 'DK', NULL, 1),
(43, 'Deutschland', 'DE', NULL, 1),
(44, 'Djibuti', 'DJ', NULL, 1),
(45, 'Dominika', 'DM', NULL, 1),
(46, 'Dominikanische Republik', 'DO', NULL, 1),
(47, 'Ecuador', 'EC', NULL, 1),
(48, 'El Salvador', 'SV', NULL, 1),
(49, 'Elfenbeinküste', 'CI', NULL, 1),
(50, 'Eritrea', 'ER', NULL, 1),
(51, 'Estland', 'EE', NULL, 1),
(52, 'Falkland Inseln', 'FK', NULL, 1),
(53, 'Färöer Inseln', 'FO', NULL, 1),
(54, 'Fidschi', 'FJ', NULL, 1),
(55, 'Finnland', 'FI', NULL, 1),
(56, 'Frankreich', 'FR', NULL, 1),
(57, 'Französisch Guyana', 'GF', NULL, 1),
(58, 'Französisch Polynesien', 'PF', NULL, 1),
(59, 'Französisches Süd-Territorium', 'TF', NULL, 1),
(60, 'Gabun', 'GA', NULL, 1),
(61, 'Gambia', 'GM', NULL, 1),
(62, 'Georgien', 'GE', NULL, 1),
(63, 'Ghana', 'GH', NULL, 1),
(64, 'Gibraltar', 'GI', NULL, 1),
(65, 'Grenada', 'GD', NULL, 1),
(66, 'Griechenland', 'GR', NULL, 1),
(67, 'Grönland', 'GL', NULL, 1),
(68, 'Großbritannien', 'UK', NULL, 1),
(69, 'Guadeloupe', 'GP', NULL, 1),
(70, 'Guam', 'GU', NULL, 1),
(71, 'Guatemala', 'GT', NULL, 1),
(72, 'Guinea', 'GN', NULL, 1),
(73, 'Guinea Bissau', 'GW', NULL, 1),
(74, 'Guyana', 'GY', NULL, 1),
(75, 'Haiti', 'HT', NULL, 1),
(76, 'Heard und McDonald Islands', 'HM', NULL, 1),
(77, 'Honduras', 'HN', NULL, 1),
(78, 'Hong Kong', 'HK', NULL, 1),
(79, 'Indien', 'IN', NULL, 1),
(80, 'Indonesien', 'ID', NULL, 1),
(81, 'Irak', 'IQ', NULL, 1),
(82, 'Iran', 'IR', NULL, 1),
(83, 'Irland', 'IE', NULL, 1),
(84, 'Island', 'IS', NULL, 1),
(85, 'Israel', 'IL', NULL, 1),
(86, 'Italien', 'IT', NULL, 1),
(87, 'Jamaika', 'JM', NULL, 1),
(88, 'Japan', 'JP', NULL, 1),
(89, 'Jemen', 'YE', NULL, 1),
(90, 'Jordanien', 'JO', NULL, 1),
(91, 'Jugoslawien', 'YU', NULL, 1),
(92, 'Kaiman Inseln', 'KY', NULL, 1),
(93, 'Kambodscha', 'KH', NULL, 1),
(94, 'Kamerun', 'CM', NULL, 1),
(95, 'Kanada', 'CA', NULL, 1),
(96, 'Kap Verde', 'CV', NULL, 1),
(97, 'Kasachstan', 'KZ', NULL, 1),
(98, 'Kenia', 'KE', NULL, 1),
(99, 'Kirgisistan', 'KG', NULL, 1),
(100, 'Kiribati', 'KI', NULL, 1),
(101, 'Kokosinseln', 'CC', NULL, 1),
(102, 'Kolumbien', 'CO', NULL, 1),
(103, 'Komoren', 'KM', NULL, 1),
(104, 'Kongo', 'CG', NULL, 1),
(105, 'Kongo, Demokratische Republik', 'CD', NULL, 1),
(106, 'Kroatien', 'HR', NULL, 1),
(107, 'Kuba', 'CU', NULL, 1),
(108, 'Kuwait', 'KW', NULL, 1),
(109, 'Laos', 'LA', NULL, 1),
(110, 'Lesotho', 'LS', NULL, 1),
(111, 'Lettland', 'LV', NULL, 1),
(112, 'Libanon', 'LB', NULL, 1),
(113, 'Liberia', 'LR', NULL, 1),
(114, 'Libyen', 'LY', NULL, 1),
(115, 'Liechtenstein', 'LI', NULL, 1),
(116, 'Litauen', 'LT', NULL, 1),
(117, 'Luxemburg', 'LU', NULL, 1),
(118, 'Macao', 'MO', NULL, 1),
(119, 'Madagaskar', 'MG', NULL, 1),
(120, 'Malawi', 'MW', NULL, 1),
(121, 'Malaysia', 'MY', NULL, 1),
(122, 'Malediven', 'MV', NULL, 1),
(123, 'Mali', 'ML', NULL, 1),
(124, 'Malta', 'MT', NULL, 1),
(125, 'Marianen', 'MP', NULL, 1),
(126, 'Marokko', 'MA', NULL, 1),
(127, 'Marshall Inseln', 'MH', NULL, 1),
(128, 'Martinique', 'MQ', NULL, 1),
(129, 'Mauretanien', 'MR', NULL, 1),
(130, 'Mauritius', 'MU', NULL, 1),
(131, 'Mayotte', 'YT', NULL, 1),
(132, 'Mazedonien', 'MK', NULL, 1),
(133, 'Mexiko', 'MX', NULL, 1),
(134, 'Mikronesien', 'FM', NULL, 1),
(135, 'Mocambique', 'MZ', NULL, 1),
(136, 'Moldavien', 'MD', NULL, 1),
(137, 'Monaco', 'MC', NULL, 1),
(138, 'Mongolei', 'MN', NULL, 1),
(139, 'Montserrat', 'MS', NULL, 1),
(140, 'Namibia', 'NA', NULL, 1),
(141, 'Nauru', 'NR', NULL, 1),
(142, 'Nepal', 'NP', NULL, 1),
(143, 'Neukaledonien', 'NC', NULL, 1),
(144, 'Neuseeland', 'NZ', NULL, 1),
(145, 'Nicaragua', 'NI', NULL, 1),
(146, 'Niederlande', 'NL', NULL, 1),
(147, 'Niederländische Antillen', 'AN', NULL, 1),
(148, 'Niger', 'NE', NULL, 1),
(149, 'Nigeria', 'NG', NULL, 1),
(150, 'Niue', 'NU', NULL, 1),
(151, 'Nord Korea', 'KP', NULL, 1),
(152, 'Norfolk Inseln', 'NF', NULL, 1),
(153, 'Norwegen', 'NO', NULL, 1),
(154, 'Oman', 'OM', NULL, 1),
(155, 'Österreich', 'AT', NULL, 1),
(156, 'Pakistan', 'PK', NULL, 1),
(157, 'Palästina', 'PS', NULL, 1),
(158, 'Palau', 'PW', NULL, 1),
(159, 'Panama', 'PA', NULL, 1),
(160, 'Papua Neuguinea', 'PG', NULL, 1),
(161, 'Paraguay', 'PY', NULL, 1),
(162, 'Peru', 'PE', NULL, 1),
(163, 'Philippinen', 'PH', NULL, 1),
(164, 'Pitcairn', 'PN', NULL, 1),
(165, 'Polen', 'PL', NULL, 1),
(166, 'Portugal', 'PT', NULL, 1),
(167, 'Puerto Rico', 'PR', NULL, 1),
(168, 'Qatar', 'QA', NULL, 1),
(169, 'Reunion', 'RE', NULL, 1),
(170, 'Ruanda', 'RW', NULL, 1),
(171, 'Rumänien', 'RO', NULL, 1),
(172, 'Rußland', 'RU', NULL, 1),
(173, 'Saint Lucia', 'LC', NULL, 1),
(174, 'Sambia', 'ZM', NULL, 1),
(175, 'Samoa', 'AS', NULL, 1),
(176, 'Samoa', 'WS', NULL, 1),
(177, 'San Marino', 'SM', NULL, 1),
(178, 'Sao Tome', 'ST', NULL, 1),
(179, 'Saudi Arabien', 'SA', NULL, 1),
(180, 'Schweden', 'SE', NULL, 1),
(181, 'Schweiz', 'CH', NULL, 1),
(182, 'Senegal', 'SN', NULL, 1),
(183, 'Seychellen', 'SC', NULL, 1),
(184, 'Sierra Leone', 'SL', NULL, 1),
(185, 'Singapur', 'SG', NULL, 1),
(186, 'Slowakei', 'SK', NULL, 1),
(187, 'Slowenien', 'SI', NULL, 1),
(188, 'Solomon Inseln', 'SB', NULL, 1),
(189, 'Somalia', 'SO', NULL, 1),
(190, 'South Georgia, South Sandwich Isl.', 'GS', NULL, 1),
(191, 'Spanien', 'ES', NULL, 1),
(192, 'Sri Lanka', 'LK', NULL, 1),
(193, 'St. Helena', 'SH', NULL, 1),
(194, 'St. Kitts Nevis Anguilla', 'KN', NULL, 1),
(195, 'St. Pierre und Miquelon', 'PM', NULL, 1),
(196, 'St. Vincent', 'VC', NULL, 1),
(197, 'Süd Korea', 'KR', NULL, 1),
(198, 'Südafrika', 'ZA', NULL, 1),
(199, 'Sudan', 'SD', NULL, 1),
(200, 'Surinam', 'SR', NULL, 1),
(201, 'Svalbard und Jan Mayen Islands', 'SJ', NULL, 1),
(202, 'Swasiland', 'SZ', NULL, 1),
(203, 'Syrien', 'SY', NULL, 1),
(204, 'Tadschikistan', 'TJ', NULL, 1),
(205, 'Taiwan', 'TW', NULL, 1),
(206, 'Tansania', 'TZ', NULL, 1),
(207, 'Thailand', 'TH', NULL, 1),
(208, 'Timor', 'TP', NULL, 1),
(209, 'Togo', 'TG', NULL, 1),
(210, 'Tokelau', 'TK', NULL, 1),
(211, 'Tonga', 'TO', NULL, 1),
(212, 'Trinidad Tobago', 'TT', NULL, 1),
(213, 'Tschad', 'TD', NULL, 1),
(214, 'Tschechische Republik', 'CZ', NULL, 1),
(215, 'Tunesien', 'TN', NULL, 1),
(216, 'Türkei', 'TR', NULL, 1),
(217, 'Turkmenistan', 'TM', NULL, 1),
(218, 'Turks und Kaikos Inseln', 'TC', NULL, 1),
(219, 'Tuvalu', 'TV', NULL, 1),
(220, 'Uganda', 'UG', NULL, 1),
(221, 'Ukraine', 'UA', NULL, 1),
(222, 'Ungarn', 'HU', NULL, 1),
(223, 'Uruguay', 'UY', NULL, 1),
(224, 'Usbekistan', 'UZ', NULL, 1),
(225, 'Vanuatu', 'VU', NULL, 1),
(226, 'Vatikan', 'VA', NULL, 1),
(227, 'Venezuela', 'VE', NULL, 1),
(228, 'Vereinigte Arabische Emirate', 'AE', NULL, 1),
(229, 'Vereinigte Staaten von Amerika', 'US', NULL, 1),
(230, 'Vietnam', 'VN', NULL, 1),
(231, 'Virgin Island (Brit.)', 'VG', NULL, 1),
(232, 'Virgin Island (USA)', 'VI', NULL, 1),
(233, 'Wallis et Futuna', 'WF', NULL, 1),
(234, 'Weissrussland', 'BY', NULL, 1),
(235, 'Westsahara', 'EH', NULL, 1),
(236, 'Zentralafrikanische Republik', 'CF', NULL, 1),
(237, 'Zimbabwe', 'ZW', NULL, 1),
(238, 'Zypern', 'CY', NULL, 1);
