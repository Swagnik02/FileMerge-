import 'dart:io';

class FolderService {
  Future<List<FileSystemEntity>> listAllEntitiesRecursively(
    String rootPath,
  ) async {
    final List<FileSystemEntity> allEntities = [];

    void recurse(String path) {
      final dir = Directory(path);
      try {
        final contents = dir.listSync();

        final folders = <Directory>[];
        final files = <FileSystemEntity>[];

        for (var entity in contents) {
          if (entity is Directory) {
            folders.add(entity);
          } else {
            files.add(entity);
          }
        }

        folders.sort((a, b) => a.path.compareTo(b.path));
        files.sort((a, b) => a.path.compareTo(b.path));

        for (final folder in folders) {
          allEntities.add(folder);
          recurse(folder.path);
        }

        allEntities.addAll(files);
      } catch (_) {
        // Ignore permission or read errors
      }
    }

    recurse(rootPath);
    return allEntities;
  }

  Future<String> mergeSelectedFiles(List<File> files, String rootPath) async {
    final buffer = StringBuffer();

    for (final file in files) {
      try {
        final relativePath = file.path.replaceFirst(
          '$rootPath${Platform.pathSeparator}',
          '',
        );
        final content = await file.readAsString();
        buffer.writeln('--- $relativePath ---\n$content\n');
      } catch (e) {
        buffer.writeln('--- ${file.path} ---\n[Error reading file: $e]\n');
      }
    }

    return buffer.toString();
  }
}
