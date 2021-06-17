// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  static m0(updateInfoLatest) => "Eine neue Version von Sidekick ist verfügbar (${updateInfoLatest}).";

  static m1(itemVersionName) => "Channel ${itemVersionName} wurde aktualisiert.";

  static m2(url) => "Konnte ${url} nicht öffnen";

  static m3(count) => "${count} gefunden";

  static m4(cachedVersions) => "${cachedVersions} Versionen";

  static m5(packageProjectsCount) => "${packageProjectsCount} Projekte";

  static m6(projects) => "${projects} Projekte";

  static m7(releases) => "${releases} Versionen";

  static m8(updateInfoLatest) => "Sidekick version ${updateInfoLatest} ist nun Verfügbar.";

  static m9(itemname) => "Dadurch wird ${itemname} aus dem Cache von Ihrem System entfernt.";

  static m10(itemVersionName) => "Die Version ${itemVersionName} wurde installiert.";

  static m11(itemVersionName) => "Die Version ${itemVersionName} wurde entfernt.";

  static m12(itemVersionName) => "Version ${itemVersionName} wurde als global festgelegt.";

  static m13(itemVersionName) => "Version ${itemVersionName} hat das Setup beendet.";

  static m14(version, projectName) => "Version ${version} angeheftet an ${projectName}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "aFlutterSdkVersionNeeedsToBeSetAsGlobal" : MessageLookupByLibrary.simpleMessage("Eine Flutter-Sdk-Version muss als global eingestellt werden "),
    "aNewVersionOfSidekickIsAvailableUpdateinfolatest" : m0,
    "addProject" : MessageLookupByLibrary.simpleMessage("Projekt hinzufügen"),
    "addYourFlutterProject" : MessageLookupByLibrary.simpleMessage("Ihr Flutter-Projekt hinzufügen "),
    "advanced" : MessageLookupByLibrary.simpleMessage("Erweitert"),
    "analyticsCrashReporting" : MessageLookupByLibrary.simpleMessage("Analytik & Crash-Berichterstattung"),
    "appSettingsHaveBeenReset" : MessageLookupByLibrary.simpleMessage("Die App-Einstellungen wurden zurückgesetzt"),
    "areYouSureYouWantToRemove" : MessageLookupByLibrary.simpleMessage("Sind Sie sicher, dass Sie entfernen möchten?"),
    "areYouSureYouWantToResetSettings" : MessageLookupByLibrary.simpleMessage("Sind Sie sicher, dass Sie die Einstellungen zurücksetzen wollen?"),
    "betaReleases" : MessageLookupByLibrary.simpleMessage("Beta Releases"),
    "branchCreatedFromMasterForANewBetaReleaseAt" : MessageLookupByLibrary.simpleMessage("Zweig, der für eine neue Betaversion am Monatsanfang, in der Regel am ersten Montag, von master erstellt wird. Dieser wird einen Zweig für Dart, die Engine und das Framework enthalten."),
    "cacheLocation" : MessageLookupByLibrary.simpleMessage("Cache-Speicherort"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Abbrechen"),
    "changeThePathTo" : MessageLookupByLibrary.simpleMessage("Ändere den Path zu\n"),
    "changelog" : MessageLookupByLibrary.simpleMessage("Änderungsprotokoll"),
    "channel" : MessageLookupByLibrary.simpleMessage("Channel"),
    "channelItemversionnameHasBeenUpgraded" : m1,
    "channels" : MessageLookupByLibrary.simpleMessage("Channels"),
    "choose" : MessageLookupByLibrary.simpleMessage("Wählen Sie"),
    "cleanUp" : MessageLookupByLibrary.simpleMessage("Säubern"),
    "cleanUpTooltip" : MessageLookupByLibrary.simpleMessage("Nicht verwendete Versionen bereinigen."),
    "cleanUpUnusedVersions" : MessageLookupByLibrary.simpleMessage("Nicht verwendete Versionen bereinigen"),
    "clickHereToDownload" : MessageLookupByLibrary.simpleMessage("Klicken Sie hier zum Download."),
    "close" : MessageLookupByLibrary.simpleMessage("Schließen"),
    "confirm" : MessageLookupByLibrary.simpleMessage("Bestätigen"),
    "copiedToClipboard" : MessageLookupByLibrary.simpleMessage("In die Zwischenablage kopiert"),
    "couldNotLaunchUrl" : m2,
    "couldNotSaveSettings" : MessageLookupByLibrary.simpleMessage("Einstellungen konnten nicht gespeichert werden"),
    "countFound" : m3,
    "createdDate" : MessageLookupByLibrary.simpleMessage("Erstelldatum"),
    "dark" : MessageLookupByLibrary.simpleMessage("Dunkel"),
    "dependenciesAfterANewVersionIsInstalled" : MessageLookupByLibrary.simpleMessage("Abhängigkeiten, nachdem eine neue Version installiert wurde."),
    "details" : MessageLookupByLibrary.simpleMessage("Details"),
    "devReleases" : MessageLookupByLibrary.simpleMessage("Dev Releases"),
    "doYouWantToRemoveThemToFreeUpSpace" : MessageLookupByLibrary.simpleMessage("Möchten Sie es entfernen, um Speicherplatz freizugeben?"),
    "downloadZip" : MessageLookupByLibrary.simpleMessage("Zip herunterladen"),
    "exploreFlutterReleases" : MessageLookupByLibrary.simpleMessage("Erkunde Flutter Releases"),
    "flutterPathIsPointingTon" : MessageLookupByLibrary.simpleMessage("Flutter PATH verweist auf\n "),
    "flutterSdkNotInstalled" : MessageLookupByLibrary.simpleMessage("Flutter SDK nicht installiert."),
    "forFasterAndSmallerInstalls" : MessageLookupByLibrary.simpleMessage(" für schnellere und kleinere Installationen"),
    "fvmOnly" : MessageLookupByLibrary.simpleMessage("Nur FVM"),
    "general" : MessageLookupByLibrary.simpleMessage("Allgemein"),
    "global" : MessageLookupByLibrary.simpleMessage("Global"),
    "globalConfiguration" : MessageLookupByLibrary.simpleMessage("Globale Konfiguration"),
    "googleContributeImprovementsToFlutterOverTime" : MessageLookupByLibrary.simpleMessage(" Google steuert im Laufe der Zeit Verbesserungen zu Flutter bei"),
    "hash" : MessageLookupByLibrary.simpleMessage("Hash"),
    "howToUpdateYourPath" : MessageLookupByLibrary.simpleMessage("Wie soll man den Pfad aktualisieren?"),
    "ifYouWantToFlutterSdkThroughFvm" : MessageLookupByLibrary.simpleMessage("wenn Sie Flutter SDK durch FVM"),
    "inOrderToAccessFlutterSettings" : MessageLookupByLibrary.simpleMessage("um auf die Flutter-Einstellungen zuzugreifen"),
    "inUse" : MessageLookupByLibrary.simpleMessage("Verwendet"),
    "installedVersions" : MessageLookupByLibrary.simpleMessage("Installierte Versionen"),
    "invalidChanel" : MessageLookupByLibrary.simpleMessage("Invalid chanel"),
    "language" : MessageLookupByLibrary.simpleMessage("Sprache"),
    "later" : MessageLookupByLibrary.simpleMessage("Später"),
    "light" : MessageLookupByLibrary.simpleMessage("Hell"),
    "likes" : MessageLookupByLibrary.simpleMessage("Likes"),
    "localCacheInformation" : MessageLookupByLibrary.simpleMessage("Lokale Cache-Informationen"),
    "master" : MessageLookupByLibrary.simpleMessage("Master"),
    "mostUsedPackages" : MessageLookupByLibrary.simpleMessage("Meistgenutzte Pakete"),
    "navButtonDashboard" : MessageLookupByLibrary.simpleMessage("Dashboard"),
    "navButtonExplore" : MessageLookupByLibrary.simpleMessage("Erkunden"),
    "navButtonPackages" : MessageLookupByLibrary.simpleMessage("Pakete"),
    "navButtonProjects" : MessageLookupByLibrary.simpleMessage("Projekte"),
    "noFlutterProjectsHaveBeenAddedYet" : MessageLookupByLibrary.simpleMessage("Es wurden noch keine Flutter-Projekte hinzugefügt."),
    "noFlutterVersionInstalledMessage" : MessageLookupByLibrary.simpleMessage("Sie haben derzeit keine Flutter SDK Versionen installiert. Versionen oder Kanäle, die installiert wurden, werden hier angezeigt."),
    "noPackagesFound" : MessageLookupByLibrary.simpleMessage("Keine Pakete gefunden"),
    "noResults" : MessageLookupByLibrary.simpleMessage("No Results"),
    "noUnusedFlutterSdkVersionsInstalled" : MessageLookupByLibrary.simpleMessage("Keine unbenutzten Flutter SDK Versionen installiert"),
    "notAFlutterProject" : MessageLookupByLibrary.simpleMessage("Kein Flutter-Projekt"),
    "notRunning" : MessageLookupByLibrary.simpleMessage("Läuft nicht"),
    "nothingSelected" : MessageLookupByLibrary.simpleMessage("Nichts ausgewähl"),
    "numberOfCachedVersions" : m4,
    "ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "onlyDisplayProjectsThatHaveVersionsPinned" : MessageLookupByLibrary.simpleMessage("Nur Projekte anzeigen, die Versionen angeheftet haben"),
    "open" : MessageLookupByLibrary.simpleMessage("öffnen"),
    "openTerminalPlayground" : MessageLookupByLibrary.simpleMessage("Terminal Playground öffnen"),
    "packageInformationWillBeDisplayedHere" : MessageLookupByLibrary.simpleMessage("Hier werden die Paketinformationen angezeigt."),
    "packageprojectscountProjects" : m5,
    "platforms" : MessageLookupByLibrary.simpleMessage("Platformen"),
    "playground" : MessageLookupByLibrary.simpleMessage("Playground"),
    "popularity" : MessageLookupByLibrary.simpleMessage("Popularität"),
    "projects" : MessageLookupByLibrary.simpleMessage("Projekte"),
    "projectsInformationWillBeDisplayedHere" : MessageLookupByLibrary.simpleMessage("Hier werden die Projektinformationen angezeigt."),
    "projectsProjects" : m6,
    "projectsRefreshed" : MessageLookupByLibrary.simpleMessage("Projekte aktualisiert"),
    "pubPoints" : MessageLookupByLibrary.simpleMessage("Pub Punkte"),
    "refresh" : MessageLookupByLibrary.simpleMessage("Aktualisieren"),
    "releaseDate" : MessageLookupByLibrary.simpleMessage("Freigabedatum"),
    "releaseNotes" : MessageLookupByLibrary.simpleMessage("Freigabemitteilungen"),
    "releases" : MessageLookupByLibrary.simpleMessage("Releases"),
    "releasesVersions" : m7,
    "remove" : MessageLookupByLibrary.simpleMessage("Löschen"),
    "reset" : MessageLookupByLibrary.simpleMessage("Zurücksetzen"),
    "resetToDefaultSettings" : MessageLookupByLibrary.simpleMessage("Zurücksetzen auf Standardeinstellungen"),
    "sdkHasNotFinishedSetup" : MessageLookupByLibrary.simpleMessage("SDK hat das Setup nicht abgeschlossen"),
    "search" : MessageLookupByLibrary.simpleMessage("Suche... "),
    "selectAFlutterSdkVersion" : MessageLookupByLibrary.simpleMessage("Wählen Sie eine Flutter SDK Version"),
    "selectAThemeOrSwitchAccordingToSystemSettings" : MessageLookupByLibrary.simpleMessage("Wählen Sie ein Thema oder schalten Sie entsprechend den Systemeinstellungen um."),
    "setAsGlobal" : MessageLookupByLibrary.simpleMessage("Als global festlegen"),
    "settingsHaveBeenSaved" : MessageLookupByLibrary.simpleMessage("Die Einstellungen wurden gespeichert"),
    "sha256" : MessageLookupByLibrary.simpleMessage("Sha256"),
    "sidekickVersionUpdateinfolatestIsNowAvailable" : m8,
    "skipSetupFlutterOnInstall" : MessageLookupByLibrary.simpleMessage("Einrichtung von Flutter bei der Installation überspringen"),
    "stableReleases" : MessageLookupByLibrary.simpleMessage("Stable Releases"),
    "start" : MessageLookupByLibrary.simpleMessage("start"),
    "system" : MessageLookupByLibrary.simpleMessage("System"),
    "theCurrentTipoftreeAbsoluteLatestCuttingEdgeBuild" : MessageLookupByLibrary.simpleMessage("Die aktuelle Spitze des Baumes, der absolut letzte Stand der Technik. "),
    "theCurrentTipoftreeAbsoluteLatestCuttingEdgeBuildUsuallyFunctional" : MessageLookupByLibrary.simpleMessage("Der aktuelle Tip-of-Tree, der absolut neueste Cutting Edge Build. Normalerweise funktional, obwohl wir manchmal versehentlich Dinge kaputt machen."),
    "theLatestFullytestedBuildUsuallyFunctionalButSeeBadBuilds" : MessageLookupByLibrary.simpleMessage("Der letzte vollständig getestete Build. Normalerweise funktionstüchtig, aber unter \"Schlechte Builds\" finden Sie eine Liste bekannter \"schlechter\" Dev-Builds."),
    "theme" : MessageLookupByLibrary.simpleMessage("Theme"),
    "thereWasAnIsssueOpeningSidekick" : MessageLookupByLibrary.simpleMessage("Es gab ein Problem beim Öffnen von Sidekick"),
    "thereWasAnIssueLoadingYourPackages" : MessageLookupByLibrary.simpleMessage("Es gab ein Problem beim Laden Ihrer Pakete."),
    "theseVersionAreNotPinnedToAProject" : MessageLookupByLibrary.simpleMessage("Diese Versionen sind nicht an ein Projekt angeheftet "),
    "thisWillCacheTheMainFlutterRepository" : MessageLookupByLibrary.simpleMessage("Dadurch wird das Haupt-Repository von Flutter zwischengespeichert"),
    "thisWillOnlyCloneFlutterAndNotInstall" : MessageLookupByLibrary.simpleMessage("Dadurch wird Flutter nur geklont und nicht installiert "),
    "thisWillOnlyResetSidekickSpecificPreferences" : MessageLookupByLibrary.simpleMessage("Dadurch werden nur Sidekick-spezifische Einstellungen zurückgesetzt"),
    "thisWillRemoveItemnameCacheFromYourSystem" : m9,
    "toSendACrashReportToGoogleInOrderTo" : MessageLookupByLibrary.simpleMessage("einen Absturzbericht an Google zu senden, um zu helfen,"),
    "unused" : MessageLookupByLibrary.simpleMessage("Nicht verwendet"),
    "updateAvailable" : MessageLookupByLibrary.simpleMessage("Update verfügbar."),
    "updateNow" : MessageLookupByLibrary.simpleMessage("Jetzt aktualisieren"),
    "upgrade" : MessageLookupByLibrary.simpleMessage("Upgrade"),
    "usuallyFunctionalThoughSometimesWeAccidentallyBreakThings" : MessageLookupByLibrary.simpleMessage("Normalerweise funktional, obwohl wir manchmal versehentlich Dinge kaputt machen."),
    "version" : MessageLookupByLibrary.simpleMessage("Version"),
    "versionIsInstalled" : MessageLookupByLibrary.simpleMessage("Version ist installiert"),
    "versionItemversionnameHasBeenInstalled" : m10,
    "versionItemversionnameHasBeenRemoved" : m11,
    "versionItemversionnameHasBeenSetAsGlobal" : m12,
    "versionItemversionnameHasFinishedSetup" : m13,
    "versionNotInstalledClickToInstall" : MessageLookupByLibrary.simpleMessage("Version nicht installiert. Klicken Sie zum Installieren."),
    "versionVersionPinnedToProjectname" : m14,
    "versions" : MessageLookupByLibrary.simpleMessage("Versionen"),
    "weRecommendThatYouUseThisChannelForAllProduction" : MessageLookupByLibrary.simpleMessage("Wir empfehlen, dass Sie diesen Kanal für alle Produktions-App-Veröffentlichungen verwenden. Ungefähr einmal im Quartal wird ein Zweig, der auf Beta stabilisiert wurde, unser nächster stabiler Zweig und wir erstellen eine stabile Version von diesem Zweig."),
    "web" : MessageLookupByLibrary.simpleMessage("Web"),
    "website" : MessageLookupByLibrary.simpleMessage("Website"),
    "whenAFlutterCommandCrashesItAttempts" : MessageLookupByLibrary.simpleMessage("Wenn ein Flutter-Befehl abstürzt, wird versucht "),
    "youNeedToAddAFlutterProjectFirst" : MessageLookupByLibrary.simpleMessage("Sie müssen zuerst ein Flutter-Projekt hinzufügen. "),
    "zipFileWithAllReleaseDependencies" : MessageLookupByLibrary.simpleMessage("Zip-Datei mit allen Release-Abhängigkeiten.")
  };
}
