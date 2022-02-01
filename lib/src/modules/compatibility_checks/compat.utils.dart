import 'dart:io';

Future<bool> isChocoInstalled() async {
  final chocoRes = await Process.run("choco", [], runInShell: true);
  if (chocoRes.stdout.toString().contains("Chocolatey v")) {
    return true;
  }
  return false;
}

Future<bool> isBrewInstalled() async {
  final brewRes = await Process.run("command", ["-v brew"], runInShell: true);
  if (brewRes.stdout.toString().trim() == "") {
    return true;
  }
  return false;
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
