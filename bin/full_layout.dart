import 'dart:io';
import 'dart:isolate';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  print('🚀 Flutter FULL LAYOUT Template CLI (--help)🚀\n');

  if (args.isEmpty || args.length < 2) {
    print(
      'Example: full_layout create <my_app> --package <com.mycompany.my_app> --name <"My App">',
    );
    exit(1);
  }

  final command = args[0];
  if (command != 'create') {
    print('❌ Unknown command: $command');
    exit(1);
  }

  if (command == 'help' || args.contains('--help') || args.contains('-h')) {
    print('''

        Usage:
          full_layout create <project_name> [options]

        Commands:
          create          Generate a new Flutter project using the template

        Options:
          --package       Set the application package ID (default: com.example.<project_name>)
          --name          Set the application display name (default: <project_name>)
          -h, --help      Show this help message

        Example:
          full_layout create my_app --package com.mycompany.my_app --name "My App"
    ''');
    exit(0);
  }

  final projectName = args[1].trim().replaceAll(' ', '_').toLowerCase();

  // Parámetros opcionales
  String packageName = "com.example.$projectName";
  String appName = projectName;

  for (int i = 2; i < args.length; i++) {
    if (args[i] == '--package' && i + 1 < args.length) {
      packageName = args[i + 1];
    }
    if (args[i] == '--name' && i + 1 < args.length) appName = args[i + 1];
  }

  print('\n📁 Generating project...');
  print('   ➤ Folder name: $projectName');
  print('   ➤ packageId:      $packageName');
  print('   ➤ App name:       $appName\n');

  final targetDir = Directory(projectName);
  if (targetDir.existsSync()) {
    print('❌ The folder "$projectName" already exists');
    exit(1);
  }

  // ---------- Resolver template dentro de lib/template ----------
  final templateDirPath = await resolveTemplatePath();
  final templateDir = Directory('$templateDirPath/template');

  if (!templateDir.existsSync()) {
    print('❌ The template folder was not found.');
    exit(1);
  }

  // ---------- Copiar template ----------
  print('📦 Copying template...');
  await copyDirectory(templateDir, targetDir);

  // ---------- Reemplazar tokens ----------
  print('🔧 Replacing tokens...');
  await replaceTokensInDirectory(targetDir, {
    '{{PROJECT_NAME}}': projectName,
    '{{PACKAGE_NAME}}': packageName,
    '{{APP_NAME}}': appName,
  });

  print('🔧 Copied project');

  // ---------- Ejecutar flutter pub get ----------
  print('⚙️ Running flutter pub get...\n');
  final result = await Process.run(
    'flutter',
    ['pub', 'get'],
    workingDirectory: targetDir.path,
    runInShell: true,
  );

  if (result.exitCode != 0) {
    print('❌ Error executing flutter pub get:');
    print(result.stderr);
    exit(1);
  }

  print('🎉 Project successfully generated!\n');
  print('👉 cd $projectName');
  print('👉 flutter run\n');
}

// -----------------------------------------------------------
// Copiar directorios recursivamente
// -----------------------------------------------------------
Future<void> copyDirectory(Directory source, Directory destination) async {
  if (!destination.existsSync()) destination.createSync(recursive: true);

  await for (final entity in source.list(recursive: false)) {
    final newPath = p.join(destination.path, p.basename(entity.path));
    if (entity is Directory) {
      await copyDirectory(entity, Directory(newPath));
    } else if (entity is File) {
      await entity.copy(newPath);
    }
  }
}

// -----------------------------------------------------------
// Reemplazar tokens en archivos de texto
// -----------------------------------------------------------
Future<void> replaceTokensInDirectory(
  Directory dir,
  Map<String, String> tokens,
) async {
  final allowedExtensions = [
    '.dart',
    '.yaml',
    '.gradle',
    '.xml',
    '.json',
    '.md',
    '.txt',
    '.plist',
    '.kts',
    '.pbxproj',
    '.kt',
    '.rc',
    '.xcconfig',
  ];

  await for (final entity in dir.list(recursive: true)) {
    if (entity is! File) continue;

    final ext = p.extension(entity.path);
    if (!allowedExtensions.contains(ext)) continue;

    String content = await entity.readAsString();
    tokens.forEach((key, value) {
      content = content.replaceAll(key, value);
    });
    await entity.writeAsString(content);
  }
}

// -----------------------------------------------------------
// Resolver package: URI a path físico
// -----------------------------------------------------------
Future<String> resolveTemplatePath() async {
  // Cambia 'full_layout' por el nombre de tu paquete en pubspec.yaml
  final templateUri = Uri.parse('package:full_layout/template/');
  final resolved = await Isolate.resolvePackageUri(templateUri);
  if (resolved == null) {
    throw Exception(
      'The template could not be resolved from the package:full_layout/template',
    );
  }
  return p.dirname(resolved.toFilePath());
}
