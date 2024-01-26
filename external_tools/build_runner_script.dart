import 'dart:io';

// execute build runner with current opened file in Android Studio
// dart run build_runner build --build-filter=foo.*.dart
void main(List<String> args) async {
  final currentFilePath = args[0];
  final currentFileGeneratedPattern =
      currentFilePath.replaceAll('.dart', '.*.dart');
  stdout.writeln(
      'dart run build_runner build --build-filter=$currentFileGeneratedPattern');

  final process = await Process.start(
      'dart',
      [
        'run',
        'build_runner',
        'build',
        '--build-filter=$currentFileGeneratedPattern'
      ],
      runInShell: true);
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);
  stdout.writeln('script executed !!!');
}
