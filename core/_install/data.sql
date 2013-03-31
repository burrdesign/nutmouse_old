-- phpMyAdmin SQL Dump
-- version 3.5.3
-- http://www.phpmyadmin.net
--
-- Host: dd15512
-- Erstellungszeit: 31. Mrz 2013 um 18:30
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
-- Daten für Tabelle `bd_sys_admin_user`
--

INSERT INTO `bd_sys_admin_user` (`adminKey`, `adminLogin`, `adminPassword`, `adminName`, `adminLastName`, `adminGender`, `adminGroupKey`, `adminNote`, `adminLastLogin`) VALUES
(1, 'admin', '21232f297a57a5a743894a0e4a801fc3', 'Max', 'Mustermann', 'm', 1, NULL, NULL);

--
-- Daten für Tabelle `bd_sys_config`
--

INSERT INTO `bd_sys_config` (`configKey`, `configLabel`, `configValue`, `configType`, `configNote`) VALUES
(1, 'maintitle', 'NutMouse v0.2 - Demo', 'string', NULL),
(2, 'theme', NULL, NULL, NULL),
(3, 'enable_cache', '0', 'int', NULL);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
