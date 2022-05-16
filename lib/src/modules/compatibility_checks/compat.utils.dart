import 'dart:io';

Future<bool> isChocoInstalled() async {
  final chocoRes = await Process.run("choco", [], runInShell: true);
  if (chocoRes.stdout.toString().contains("Chocolatey v")) {
    return true;
  }
  return false;
}

Future<bool> isBrewInstalled() async {
  if (Platform.isWindows) return false;
  final brewRes = await Process.run("command", ["-v brew"], runInShell: true);
  if (brewRes.stdout.toString().trim() == "") {
    return false;
  }
  return true;
}

Future<bool> isFvmInstalled() async {
  final fvmRes = await Process.run("fvm", [], runInShell: true);
  if (fvmRes.stdout.toString().contains(
      "Flutter Version Management: A cli to manage Flutter SDK versions.")) {
    return true;
  }
  return false;
}

Future<bool> isGitInstalled() async {
  final fvmRes = await Process.run("git", [], runInShell: true);
  if (fvmRes.stdout
      .toString()
      .contains("See 'git help git' for an overview of the system")) {
    return true;
  }
  return false;
}

void launchTerminal() {
  if (Platform.isMacOS) {
    Process.runSync("open", ["-a Terminal"]);
  } else if (Platform.isWindows) {
    Process.runSync("cmd", [], runInShell: true);
  }
}

const brewInstallCmd =
    '/bin/bash -c "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"\n';

const chocoInstallCmd =
    'Set-ExecutionPolicy AllSigned\nSet-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString(\'https://community.chocolatey.org/install.ps1\'))\n';

final gitInstallCmd =
    Platform.isWindows ? "choco install git -yf\n" : "brew install git\n";

final fvmInstallCmd = Platform.isWindows
    ? "choco install fvm -y\n"
    : "brew tap leoafarias/fvm\nbrew install fvm\n";
