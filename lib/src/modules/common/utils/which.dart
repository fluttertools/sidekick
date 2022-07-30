import 'dart:io';

// Function that uses which AND where to detect the path of the executable. Yay copilot!
Future<String?> which(String executable) async {
  if (Platform.isLinux || Platform.isMacOS) {
    final result = await Process.run('which', [executable], runInShell: true);
    if (result.exitCode != 0) {
      return null;
    }
    return result.stdout.toString().trim();
  } else {
    final result2 =
        await Process.run('where.exe', [executable], runInShell: true);
    if (result2.exitCode != 0) {
      return null;
    }
    return result2.stdout.toString().trim();
  }
}
