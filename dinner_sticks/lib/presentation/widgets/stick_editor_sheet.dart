import 'package:dinner_sticks/domain/failures.dart';
import 'package:dinner_sticks/domain/usecases/stick/add_stick.dart';
import 'package:dinner_sticks/domain/usecases/stick/edit_stick.dart';
import 'package:dinner_sticks/presentation/providers/pool_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom-sheet form for adding or editing a meal idea (stick).
///
/// When [stickId] is `null`, the sheet adds a new stick to [poolId].
/// When [stickId] is provided, the sheet renames that stick.
class StickEditorSheet extends ConsumerStatefulWidget {
  /// Creates a [StickEditorSheet].
  ///
  /// Pass [stickId] and [initialName] to edit an existing stick; omit both to
  /// add a new one.
  const StickEditorSheet({
    required this.poolId,
    this.stickId,
    this.initialName,
    super.key,
  });

  /// The pool to add a new stick to (ignored when editing).
  final String poolId;

  /// The externalId of the stick to edit, or `null` to add a new one.
  final String? stickId;

  /// The current name of the stick when editing.
  final String? initialName;

  @override
  ConsumerState<StickEditorSheet> createState() => _StickEditorSheetState();
}

class _StickEditorSheetState extends ConsumerState<StickEditorSheet> {
  late final TextEditingController _controller;
  String? _errorText;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.stickId != null;

  Future<void> _save() async {
    final name = _controller.text;
    if (name.trim().isEmpty) {
      setState(() => _errorText = 'Name cannot be empty');
      return;
    }

    setState(() {
      _errorText = null;
      _saving = true;
    });

    try {
      final repo = await ref.read(poolRepositoryProvider.future);
      if (_isEditing) {
        await EditStick(repository: repo)
            .call(stickId: widget.stickId!, newName: name);
      } else {
        await AddStick(repository: repo)
            .call(poolId: widget.poolId, name: name);
      }
      if (mounted) Navigator.of(context).pop();
    } on DuplicateNameFailure catch (e) {
      setState(() {
        _errorText = '"${e.name}" already exists in this pool';
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _isEditing ? 'Edit meal idea' : 'Add meal idea',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Semantics(
            label: 'Meal idea name',
            child: TextField(
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'e.g. Pasta',
                errorText: _errorText,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _saving ? null : _save(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
