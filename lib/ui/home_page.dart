import 'package:filemerge_plus/models/folder_model.dart';
import 'package:filemerge_plus/services/file_merge_service.dart';
import 'package:filemerge_plus/ui/folder_tree_view.dart';
import 'package:filemerge_plus/ui/merged_text_view.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FileMergeService _fileMergeService = FileMergeService();

  FolderModel? selectedFolder;
  String mergedText = '';
  bool showExcludedInTree = false;

  Future<void> onFolderSelected() async {
    final selectedDirectory = await getDirectoryPath();
    if (selectedDirectory == null) return;

    setState(
      () => selectedFolder = FolderModel(path: selectedDirectory, name: ''),
    );
  }

  void onMergeDone(String content) {
    if (content == mergedText) return;
    setState(() => mergedText = content);
  }

  Future<void> onExport() async {
    try {
      final filePath = await _fileMergeService.exportMergedText(mergedText);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('File saved at $filePath')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save file: $e')));
    }
  }

  void onShowExcludedChanged(bool value) {
    if (value == showExcludedInTree) return;
    setState(() => showExcludedInTree = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onFolderSelected,
                  child: const Text('Select Folder'),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: FolderTreeView(
                    folderPath: selectedFolder?.path,
                    onMergePressed: onMergeDone,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: MergedTextView(
              text: mergedText,
              showExcluded: showExcludedInTree,
              onExport: onExport,
              onShowExcludedChanged: onShowExcludedChanged,
            ),
          ),
        ],
      ),
    );
  }
}
