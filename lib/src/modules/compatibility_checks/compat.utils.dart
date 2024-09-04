import 'dart:io';

import 'package:sidekick/src/modules/common/utils/open_link.dart';
import 'package:sidekick/src/modules/common/utils/which.dart';

Future<bool> isChocoInstalled() async {
  final chocoRes = await which('choco');
  if (chocoRes != null) {
    return true;
  }
  return false;
}

Future<bool> isBrewInstalled() async {
  if (Platform.isWindows) return false;
  final brewRes = await which("brew");
  if (brewRes != null) {
    return true;
  }
  return false;
}


Future<bool> isGitInstalled() async {
  final gitRes = await which("git");
  if (gitRes != null) {
    return true;
  }
  return false;
}

void launchTerminal() {
  if (Platform.isMacOS) {
    openCustom('Terminal');
  } else if (Platform.isWindows) {
    openCustom('cmd');
  }
}

const brewInstallCmd =
    '/bin/bash -c "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"\n';

const chocoInstallCmd =
    'Set-ExecutionPolicy AllSigned\nSet-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString(\'https://community.chocolatey.org/install.ps1\'))\n';

final gitInstallCmd =
    Platform.isWindows ? "choco install git -yf\n" : "brew install git\n";