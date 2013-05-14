-- phpMyAdmin SQL Dump
-- version 3.5.3
-- http://www.phpmyadmin.net
--
-- Host: dd15512
-- Erstellungszeit: 31. Mrz 2013 um 18:27
-- Server Version: 5.1.66-nmm3-log
-- PHP-Version: 5.3.18-nmm1

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Datenbank: `d016c1d5`
--

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

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
