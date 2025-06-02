# 📂 FileMerge+ — FolderTreeView & File Merge for Flutter

**FileMerge+** is a Flutter-based widget and service for visually navigating folders, selecting files/folders recursively, and merging selected text files into a combined output.

---

## ✨ Features

- 🔽 **Recursive Folder Tree View** with expandable/collapsible UI
- 🗂️ **Sorted Display**: folders appear before files at every level
- ✅ **Checkbox Selection** for folders and files (folder selection selects all children)
- 📄 **Text File Merge** with file headers for clarity
- ⚠️ **Graceful Error Handling** during file read operations
- 🖥️📱 **Responsive Design** for desktop and mobile

---

## 🚀 Getting Started

### ✅ Prerequisites

- **Flutter SDK**: version 3.0 or later
- **Dart**: version 3.0 or later
- Works on **desktop and mobile** platforms (where file system access is supported)

### 📦 Installation

Add the widget and service files from this repo to your Flutter project manually.

---

## 🧩 Usage

### 1. `FolderTreeView` Widget

```dart
FolderTreeView(
  folderPath: '/path/to/root/folder',
  onMergePressed: (mergedContent) {
    // Handle the merged content (e.g., save, display, share)
    print(mergedContent);
  },
);
```

### 2. `FolderService` Class

This service handles folder traversal and file merging:

```dart
final folderService = FolderService();

// List all entities under the root directory
final entities = await folderService.listAllEntitiesRecursively('/path/to/root');

// Merge selected files
final mergedText = await folderService.mergeSelectedFiles(selectedFiles, '/path/to/root');
```

---

## 🛠️ How It Works

- `FolderService` traverses the directory recursively, sorting folders before files.
- `FolderTreeView` displays a checkbox-enabled UI with expandable nodes.
- Selecting a folder auto-selects all its children recursively.
- Pressing the **Merge** button combines all selected text files into a single string with headers like:

```
=== filename.txt ===
(file contents here)
```

---

## 📂 Folder Sorting Logic

At each level in the tree:

1. Subfolders are shown **first**, alphabetically
2. Files are listed **after**, also alphabetically

This enhances clarity and mimics traditional file explorers.

---

## 📸 Screenshots

_To be added:_

- Folder tree UI preview
- Merged text output preview

---

## 🤝 Contributing

Contributions are welcome! Open issues or submit pull requests for:

- Bugs and crashes
- New features
- UX/UI improvements
- Platform-specific support

---

## 📄 License

MIT License © [Your Name / Organization]

---
