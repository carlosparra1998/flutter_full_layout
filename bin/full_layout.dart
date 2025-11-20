import 'dart:io';
import 'dart:isolate';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  print('🚀 Flutter Template CLI');

  if (args.isEmpty || args.length < 2) {
    print('Uso: my_cli create <project_name> --package com.example.app --name "My App"');
    exit(1);
  }

  final command = args[0];
  if (command != 'create') {
    print('❌ Comando desconocido: $command');
    exit(1);
  }

  final projectName = args[1];

  // Parámetros opcionales
  String packageName = "com.example.$projectName";
  String appName = projectName;

  for (int i = 2; i < args.length; i++) {
    if (args[i] == '--package' && i + 1 < args.length) packageName = args[i + 1];
    if (args[i] == '--name' && i + 1 < args.length) appName = args[i + 1];
  }

  print('\n📁 Generando proyecto...');
  print('   ➤ Nombre carpeta: $projectName');
  print('   ➤ packageId:      $packageName');
  print('   ➤ App name:       $appName\n');

  final targetDir = Directory(projectName);
  if (targetDir.existsSync()) {
    print('❌ La carpeta "$projectName" ya existe.');
    exit(1);
  }

  // ---------- Resolver template dentro de lib/template ----------
  final templateDirPath = await resolveTemplatePath();
  final templateDir = Directory('$templateDirPath/template');
  print(templateDir);

  if (!templateDir.existsSync()) {
    print('❌ No se encontró la carpeta template en template/');
    exit(1);
  }

  // ---------- Copiar template ----------
  print('📦 Copiando template...');
  await copyDirectory(templateDir, targetDir);

  // ---------- Reemplazar tokens ----------
  print('🔧 Reemplazando tokens...');
  await replaceTokensInDirectory(targetDir, {
    '{{PROJECT_NAME}}': projectName,
    '{{PACKAGE_NAME}}': packageName,
    '{{APP_NAME}}': appName,
  });

  // ---------- Ejecutar flutter pub get ----------
  print('\n⚙️ Ejecutando flutter pub get...\n');
  final result = await Process.run(
    'flutter',
    ['pub', 'get'],
    workingDirectory: targetDir.path,
    runInShell: true,
  );

  if (result.exitCode != 0) {
    print('❌ Error ejecutando flutter pub get:');
    print(result.stderr);
    exit(1);
  }

  print('🎉 Proyecto generado con éxito!');
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
Future<void> replaceTokensInDirectory(Directory dir, Map<String, String> tokens) async {
  final allowedExtensions = ['.dart','.yaml','.gradle','.xml','.json','.md','.txt','.plist', '.kts', '.pbxproj', '.kt', '.rc', '.xcconfig'];

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
    throw Exception('No se pudo resolver el template desde package:full_layout/template');
  }
  return p.dirname(resolved.toFilePath());
}
