import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seletter/dashatar/dashatar.dart';
import 'package:seletter/models/models.dart';
import 'package:seletter/puzzle/puzzle.dart';
import 'package:seletter/theme/theme.dart';

/// {@template puzzle_keyboard_handler}
/// A widget that listens to the keyboard events and moves puzzle tiles
/// whenever a user presses keyboard arrows (←, →, ↑, ↓).
/// {@endtemplate}
class PuzzleKeyboardHandler extends StatefulWidget {
  /// {@macro puzzle_keyboard_handler}
  const PuzzleKeyboardHandler({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  State createState() => _PuzzleKeyboardHandlerState();
}

class _PuzzleKeyboardHandlerState extends State<PuzzleKeyboardHandler> {
  // The node used to request the keyboard focus.
  final FocusNode _focusNode = FocusNode();

  void _handleKeyEvent(RawKeyEvent event) {
    final theme = context.read<ThemeBloc>().state.theme;

    // The user may move tiles only when the puzzle is started.
    // There's no need to check the Simple theme as it is started by default.
    final canMoveTiles = !(theme is DashatarTheme &&
        context.read<DashatarPuzzleBloc>().state.status !=
            DashatarPuzzleStatus.started);

    if (event is RawKeyDownEvent && canMoveTiles) {
      final puzzle = context.read<PuzzleBloc>().state.puzzle;
      final physicalKey = event.data.physicalKey;

      Tile? tile;
      if (physicalKey == PhysicalKeyboardKey.arrowDown) {
        tile = puzzle.getTileRelativeToWhitespaceTile(const Offset(0, -1));
      } else if (physicalKey == PhysicalKeyboardKey.arrowUp) {
        tile = puzzle.getTileRelativeToWhitespaceTile(const Offset(0, 1));
      } else if (physicalKey == PhysicalKeyboardKey.arrowRight) {
        tile = puzzle.getTileRelativeToWhitespaceTile(const Offset(-1, 0));
      } else if (physicalKey == PhysicalKeyboardKey.arrowLeft) {
        tile = puzzle.getTileRelativeToWhitespaceTile(const Offset(1, 0));
      }

      final state = context.read<PuzzleBloc>().state;
      final isIncomplete = state.puzzleStatus == PuzzleStatus.incomplete;

      if (tile != null && isIncomplete) {
        context.read<PuzzleBloc>().add(TileTapped(tile));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      child: Builder(
        builder: (context) {
          if (!_focusNode.hasFocus) {
            FocusScope.of(context).requestFocus(_focusNode);
          }
          return widget.child;
        },
      ),
    );
  }
}
