import 'dart:io';
import 'package:filemerge_plus/services/file_merge_service.dart';
import 'package:filemerge_plus/services/folder_service.dart';
import 'package:flutter/material.dart';

class FolderTreeView extends StatefulWidget {
  final String? folderPath;
  final void Function(String mergedContent) onMergePressed;

  const FolderTreeView({
    super.key,
    required this.onMergePressed,
    this.folderPath,
  });

  @override
  State<FolderTreeView> createState() => _FolderTreeViewState();
}

class _FolderTreeViewState extends State<FolderTreeView> {
  late final FileMergeService _fileMergeService;
  late final FolderService _folderService;

  List<FileSystemEntity> allEntries = [];
  final Map<String, bool> checked = {};
  final Map<String, bool> expanded = {};

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fileMergeService = FileMergeService();
    _folderService = FolderService();
    if (widget.folderPath != null) {
      _loadFolderTree(widget.folderPath!);
    }
  }

  @override
  void didUpdateWidget(covariant FolderTreeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.folderPath != oldWidget.folderPath &&
        widget.folderPath != null) {
      _loadFolderTree(widget.folderPath!);
    }
  }

  Future<void> _loadFolderTree(String rootPath) async {
    setState(() {
      isLoading = true;
      checked.clear();
      expanded.clear();
    });
    final allEntities = await _folderService.listAllEntitiesRecursively(
      rootPath,
    );

    setState(() {
      allEntries = allEntities;
      for (final e in allEntities) {
        checked[e.path] = true;
        if (e is Directory) expanded[e.path] = false;
      }
      isLoading = false;
    });
  }

  Future<void> _mergeFiles() async {
    final includedFiles = checked.entries
        .where((e) => e.value && FileSystemEntity.isFileSync(e.key))
        .map((e) => File(e.key))
        .toList();

    final mergedContent = await _fileMergeService.mergeFiles(
      includedFiles,
      widget.folderPath ?? '',
    );
    widget.onMergePressed(mergedContent);
  }

  int _getIndentLevel(FileSystemEntity entity) {
    if (widget.folderPath == null) return 0;
    final relativePath = entity.path.replaceFirst(widget.folderPath!, '');
    return relativePath
        .split(Platform.pathSeparator)
        .where((e) => e.isNotEmpty)
        .length;
  }

  bool _isVisible(FileSystemEntity entity) {
    final path = entity.path;
    if (widget.folderPath == null) return true;

    String current = widget.folderPath!;
    final segments = path
        .replaceFirst(current, '')
        .split(Platform.pathSeparator)
        .where((s) => s.isNotEmpty)
        .toList();

    for (int i = 0; i < segments.length - 1; i++) {
      current += Platform.pathSeparator + segments[i];
      if (expanded[current] == false) return false;
    }
    return true;
  }

  void _toggleFolderChildren(String folderPath, bool isChecked) {
    for (final entity in allEntries) {
      if (entity.path.startsWith('$folderPath${Platform.pathSeparator}')) {
        checked[entity.path] = isChecked;
      }
    }
  }

  void _toggleExpansion(String folderPath) {
    setState(() {
      expanded[folderPath] = !(expanded[folderPath] ?? true);
    });
  }

  Widget _buildEntry(FileSystemEntity entity) {
    if (!_isVisible(entity)) return const SizedBox.shrink();

    final isFile = entity is File;
    final name = entity.path.split(Platform.pathSeparator).last;
    final isChecked = checked[entity.path] ?? false;
    final indent = _getIndentLevel(entity);
    final isExpanded = expanded[entity.path] ?? true;

    return InkWell(
      onTap: () {
        setState(() {
          final newValue = !isChecked;
          checked[entity.path] = newValue;
          if (!isFile) _toggleFolderChildren(entity.path, newValue);
        });
      },
      child: Padding(
        padding: EdgeInsets.only(left: indent * 16.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
          ),
          child: Row(
            children: [
              if (!isFile)
                GestureDetector(
                  onTap: () => _toggleExpansion(entity.path),
                  child: Icon(
                    isExpanded ? Icons.expand_more : Icons.chevron_right,
                    size: 18,
                    color: Colors.grey[700],
                  ),
                )
              else
                const SizedBox(width: 18),
              const SizedBox(width: 8),
              Icon(
                isFile
                    ? Icons.insert_drive_file_outlined
                    : Icons.folder_outlined,
                size: 20,
                color: Colors.grey[700],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              Checkbox(
                value: isChecked,
                onChanged: (val) {
                  setState(() {
                    checked[entity.path] = val ?? false;
                    if (!isFile)
                      _toggleFolderChildren(entity.path, val ?? false);
                  });
                },
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleEntries = allEntries.where(_isVisible).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Folder Contents',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
        const Divider(height: 1, thickness: 0.5),
        isLoading
            ? const Expanded(child: Center(child: CircularProgressIndicator()))
            : Expanded(
                child: ListView.builder(
                  itemCount: visibleEntries.length,
                  itemBuilder: (context, index) =>
                      _buildEntry(visibleEntries[index]),
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: _mergeFiles,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text('Merge Selected Files'),
            ),
          ),
        ),
      ],
    );
  }
}
