import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileMergeService {
  /// Merges the contents of the given list of files.
  /// Returns a merged string with headers for each file path.
  Future<String> mergeFiles(List<File> files, String rootPath) async {
    String mergedContent = '';

    for (var file in files) {
      try {
        final relativePath = file.path.replaceFirst(
          '$rootPath${Platform.pathSeparator}',
          '',
        );
        final content = await file.readAsString();
        mergedContent += '--- $relativePath ---\n$content\n\n';
      } catch (e) {
        mergedContent += '--- ${file.path} ---\n[Error reading file: $e]\n\n';
      }
    }

    return mergedContent;
  }

  /// Exports the merged text to a file named 'merged.txt' inside
  /// the app's documents directory and returns the saved file path.
  Future<String> exportMergedText(String mergedText) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/merged.txt';
    final file = File(filePath);
    await file.writeAsString(mergedText);
    return filePath;
  }
}
