// # Full Layout - Flutter Project Generator
//
// CLI to generate a complete Flutter project with CLEAN ARCHITECTURE.
//
// ## Description
// It will allow the developer to create a base project with CLEAN ARCHITECTURE. In this architecture, we use services (Cubits) for each use case. These services will communicate with repositories (for each use case), and these repositories will communicate with the DIO client (HTTP).
//
// * In this layout, BLoC and Cubit are used for state management.
// * DIO is used for communication with the REST API.
// * l10n is used for translations.
// * Real use case in full operation (Auth - login)
// * Basic responsive design management
// * Route management with GET
// * Defined styles (text styles and colours)
// * Complete initialiser in Splash Screen
// * Predefined tests (unit, integration and widgets) [92% coverage].
// * A homemade HTTP client (using DIO) that provides directly constructed objects/lists, without the need for processing (just indicate the fromJson of a specific class to target in the client).
//
// ## Author
// Developed by Carlos Francisco Parra García.
//
// ## License
// MIT License - See the LICENSE file for more details.
//
// © 2025 Carlos Francisco Parra García. All rights reserved.
//
// GitHub: https://github.com/carlosparra1998?tab=repositories
//
// LinkedIn: https://www.linkedin.com/in/carlos-francisco-parra-garcía-9b16941b5/

import 'dart:io';
import 'dart:isolate';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  print('🚀 Flutter FULL LAYOUT Template CLI (--help) 🚀\n');

  if (args.isEmpty) {
    print(
      'Example: flutter_full_layout create <my_app> --package <com.mycompany.my_app> --name <"My App">',
    );
    exit(1);
  }

  final command = args[0];

  if (command == 'help' || args.contains('--help') || args.contains('-h')) {
    print('''

        Usage:
          flutter_full_layout create <project_name> [options]

        Commands:
          create          Generate a new Flutter project using the template

        Options:
          --package       Set the application package ID (default: com.example.<project_name>)
          --name          Set the application display name (default: <project_name>)
          -h, --help      Show this help message

        Example:
          flutter_full_layout create my_app --package com.mycompany.my_app --name "My App"
    ''');
    exit(0);
  }

  if (command != 'create') {
    print('❌ Unknown command: $command');
    exit(1);
  }

  if (args.length < 2) {
    print(
      'Example: flutter_full_layout create <my_app> --package <com.mycompany.my_app> --name <"My App">',
    );
    exit(1);
  }

  final projectName = args[1].trim().replaceAll(' ', '_').toLowerCase();

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

  final templateDirPath = await resolveTemplatePath();
  String parentPath = p.normalize(p.join(templateDirPath, '..', 'template'));
  final templateDir = Directory(parentPath);

  if (!templateDir.existsSync()) {
    print('❌ The template folder was not found.');
    exit(1);
  }

  print('📦 Copying template...');
  await copyDirectory(templateDir, targetDir);

  print('🔧 Replacing tokens...');
  await replaceTokensInDirectory(targetDir, {
    '{{PROJECT_NAME}}': projectName,
    '{{PACKAGE_NAME}}': packageName,
    '{{APP_NAME}}': appName,
  });

  print('🔧 Copied project');
  print('🔧 Generating .env and .gitignore files');
  final templates = await loadRootTemplates();
  await generateHiddenFiles(
    targetDir,
    templates['env']!,
    templates['gitignore']!,
  );
  print('🔧 Running flutter pub get...\n');
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

Future<void> copyDirectory(Directory source, Directory destination) async {
  if (!destination.existsSync()) destination.createSync(recursive: true);

  await for (final entity
      in source.list(recursive: false, followLinks: false)) {
    final newPath = p.join(destination.path, p.basename(entity.path));

    if (entity is Directory) {
      await copyDirectory(entity, Directory(newPath));
    } else if (entity is File) {
      File(newPath).createSync(recursive: true);
      await entity.copy(newPath);
    }
  }
}

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

Future<String> resolveTemplatePath() async {
  final templateUri = Uri.parse('package:flutter_full_layout/template/');
  final resolved = await Isolate.resolvePackageUri(templateUri);
  if (resolved == null) {
    throw Exception(
      '❌ The template could not be resolved from the package:flutter_full_layout/template',
    );
  }
  return p.dirname(resolved.toFilePath());
}

Future<Map<String, String>> loadRootTemplates() async {
  final pkgUri = await Isolate.resolvePackageUri(
      Uri.parse('package:flutter_full_layout/'));
  if (pkgUri == null) {
    throw Exception('❌ Error in loading .gitignore and .env files');
  }

  final packageRoot = Directory(pkgUri.toFilePath());

  final envFile = File(p.join(packageRoot.path, 'env.template'));
  final gitignoreFile = File(p.join(packageRoot.path, 'gitignore.template'));

  final envContent = await envFile.readAsString();
  final gitignoreContent = await gitignoreFile.readAsString();

  return {
    'env': envContent,
    'gitignore': gitignoreContent,
  };
}

Future<void> generateHiddenFiles(
  Directory projectDir,
  String envContent,
  String gitignoreContent,
) async {
  final envFile = File(p.join(projectDir.path, '.env'));
  await envFile.writeAsString(envContent);
  final gitignore = File(p.join(projectDir.path, '.gitignore'));
  await gitignore.writeAsString(gitignoreContent);
}
