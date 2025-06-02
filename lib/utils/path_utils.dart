import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String?> getSaveFilePath(String suggestedFileName) async {
  Directory? downloadsDir = await getDownloadsDirectory();

  downloadsDir ??= await getApplicationDocumentsDirectory();

  final path =
      '${downloadsDir.path}${Platform.pathSeparator}$suggestedFileName';
  return path;
}
