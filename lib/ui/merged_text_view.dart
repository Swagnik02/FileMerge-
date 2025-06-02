import 'package:flutter/material.dart';

class MergedTextView extends StatefulWidget {
  final String text;
  final bool showExcluded;
  final VoidCallback onExport;
  final ValueChanged<bool> onShowExcludedChanged;

  const MergedTextView({
    super.key,
    required this.text,
    required this.showExcluded,
    required this.onExport,
    required this.onShowExcludedChanged,
  });

  @override
  State<MergedTextView> createState() => _MergedTextViewState();
}

class _MergedTextViewState extends State<MergedTextView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void didUpdateWidget(covariant MergedTextView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text && widget.text != _controller.text) {
      _controller.text = widget.text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Show excluded in tree'),
          Checkbox(
            value: widget.showExcluded,
            onChanged: (value) {
              if (value != null) widget.onShowExcludedChanged(value);
            },
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: widget.onExport,
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildControls(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              expands: true,
              maxLines: null,
              minLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
