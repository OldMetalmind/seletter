import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:selector/assets/constants.dart';
import 'package:selector/colors/colors.dart';
import 'package:selector/l10n/l10n.dart';
import 'package:selector/layout/layout.dart';
import 'package:selector/models/models.dart';
import 'package:selector/models/tile_animation.dart';
import 'package:selector/puzzle/puzzle.dart';
import 'package:selector/simple/simple.dart';
import 'package:selector/simple/widgets/animation_positioned_tile.dart';
import 'package:selector/theme/theme.dart';
import 'package:selector/typography/typography.dart';

import 'widgets/animation_positioned_tile.dart';

/// {@template simple_puzzle_layout_delegate}
/// A delegate for computing the layout of the puzzle UI
/// that uses a [SimpleTheme].
/// {@endtemplate}
class SimplePuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  /// {@macro simple_puzzle_layout_delegate}
  const SimplePuzzleLayoutDelegate();

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => Padding(
        padding: const EdgeInsets.only(left: 50, right: 32),
        child: child,
      ),
      child: (_) => SimpleStartSection(state: state),
    );
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return Column(
      children: const [
        ResponsiveGap(
          small: 32,
          medium: 48,
        ),
        // ResponsiveLayoutBuilder(
        //   small: (_, child) => const SimplePuzzleShuffleButton(),
        //   medium: (_, child) => const SimplePuzzleShuffleButton(),
        //   large: (_, __) => const SizedBox(),
        // ),
        ResponsiveGap(
          small: 32,
          medium: 48,
        ),
      ],
    );
  }

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return const SizedBox();
    return Positioned(
      right: 0,
      bottom: 0,
      child: ResponsiveLayoutBuilder(
        small: (_, __) => SizedBox(
          width: 184,
          height: 118,
          child: Image.asset(
            'assets/images/simple_dash_small.png',
            key: const Key('simple_puzzle_dash_small'),
          ),
        ),
        medium: (_, __) => SizedBox(
          width: 380.44,
          height: 214,
          child: Image.asset(
            'assets/images/simple_dash_medium.png',
            key: const Key('simple_puzzle_dash_medium'),
          ),
        ),
        large: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 53),
          child: SizedBox(
            width: 568.99,
            height: 320,
            child: Image.asset(
              'assets/images/simple_dash_large.png',
              key: const Key('simple_puzzle_dash_large'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget boardBuilder(int size, List<Widget> tiles) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
          large: 96,
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => SizedBox.square(
            dimension: _BoardSize.small,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_small'),
              size: size,
              tiles: tiles,
              spacing: 5,
            ),
          ),
          medium: (_, __) => SizedBox.square(
            dimension: _BoardSize.medium,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_medium'),
              size: size,
              tiles: tiles,
            ),
          ),
          large: (_, __) => SizedBox.square(
            dimension: _BoardSize.large,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_large'),
              size: size,
              tiles: tiles,
            ),
          ),
        ),
        const ResponsiveGap(
          large: 96,
        ),
      ],
    );
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_small'),
        tile: tile,
        tileFontSize: _TileFontSize.small,
        state: state,
      ),
      medium: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_medium'),
        tile: tile,
        tileFontSize: _TileFontSize.medium,
        state: state,
      ),
      large: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_large'),
        tile: tile,
        tileFontSize: _TileFontSize.large,
        state: state,
      ),
    );
  }

  @override
  Widget whitespaceTileBuilder() {
    return const SizedBox();
  }

  @override
  List<Object?> get props => [];
}

/// {@template simple_start_section}
/// Displays the start section of the puzzle based on [state].
/// {@endtemplate}
@visibleForTesting
class SimpleStartSection extends StatelessWidget {
  /// {@macro simple_start_section}
  const SimpleStartSection({
    Key? key,
    required this.state,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        ResponsiveGap(
          small: 20,
          medium: 83,
          large: 151,
        ),
        // PuzzleName(
        //   key: puzzleNameKey,
        // ),
        ResponsiveGap(large: 16),
        // SimplePuzzleTitle(
        //   status: state.puzzleStatus,
        // ),
        ResponsiveGap(
          small: 12,
          medium: 16,
          large: 32,
        ),
        // NumberOfMovesAndTilesLeft(
        //   key: numberOfMovesAndTilesLeftKey,
        //   numberOfMoves: state.numberOfMoves,
        //   numberOfTilesLeft: state.numberOfTilesLeft,
        // ),
        ResponsiveGap(
          large: 32,
          small: 16,
        ),
        // ResponsiveLayoutBuilder(
        //   small: (_, __) => const SizedBox(),
        //   medium: (_, __) => const SizedBox(),
        //   large: (_, __) => const SimplePuzzleShuffleButton(),
        // ),
      ],
    );
  }
}

/// {@template simple_puzzle_title}
/// Displays the title of the puzzle based on [status].
///
/// Shows the success state when the puzzle is completed,
/// otherwise defaults to the Puzzle Challenge title.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTitle extends StatelessWidget {
  /// {@macro simple_puzzle_title}
  const SimplePuzzleTitle({
    Key? key,
    required this.status,
  }) : super(key: key);

  /// The status of the puzzle.
  final PuzzleStatus status;

  @override
  Widget build(BuildContext context) {
    return PuzzleTitle(
      key: puzzleTitleKey,
      title: status == PuzzleStatus.complete
          ? context.l10n.puzzleCompleted
          : context.l10n.puzzleChallengeTitle,
    );
  }
}

abstract class _BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 472;
}

/// {@template simple_puzzle_board}
/// Display the board of the puzzle in a [size]x[size] layout
/// filled with [tiles]. Each tile is spaced with [spacing].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleBoard extends StatefulWidget {
  /// {@macro simple_puzzle_board}
  const SimplePuzzleBoard({
    Key? key,
    required this.size,
    required this.tiles,
    this.spacing = 8,
  }) : super(key: key);

  /// The size of the board.
  final int size;

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;

  /// The spacing between each tile from [tiles].
  final double spacing;

  @override
  State<SimplePuzzleBoard> createState() => _SimplePuzzleBoardState();
}

class _SimplePuzzleBoardState extends State<SimplePuzzleBoard> {
  @override
  Widget build(BuildContext context) {
    final lastTappedTile = context.read<PuzzleBloc>().state.lastTappedTile;
    final spaceTile = context.read<PuzzleBloc>().state.previousSpace;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final parentWidth = constraints.maxWidth;

        final squares = <Widget>[];

        var count = 0;
        final ite = widget.tiles.iterator;
        final next = ite.moveNext(); // If I remove this will cause NPE

        final whiteSpacePosition =
            spaceTile?.currentPosition ?? const Position(x: -2, y: -2);
        for (var x = 0; x < widget.size; x++) {
          for (var y = 0; y < widget.size; y++) {
            if (x == whiteSpacePosition.y - 1 &&
                y == whiteSpacePosition.x - 1) {
            } else {
              squares.add(
                tileSquare(count, x, y, ite.current, parentWidth / widget.size),
              );
            }

            if (next) {
              ite.moveNext();
              count++;
            } else {
              break;
            }
          }
        }

        return Stack(
          children: [
            ...squares,
            if (lastTappedTile != null)
              AnimateTappedTile(
                tile: lastTappedTile,
                position: lastTappedTile.currentPosition,
                squareSize: constraints.biggest.width / widget.size,
                spaceTile: spaceTile,
                tileAnimation: TileAnimation.fromTiles(
                  lastTappedTile,
                  spaceTile,
                ),
                animationListener: () {},
              ),
          ],
        );
      },
    );
  }

  /// Shows the tile drawn on the screen
  Widget tileSquare(int index, int y, int x, Widget tile, double width) {
    return Positioned(
      top: y * width,
      left: x * width,
      height: width,
      width: width,
      child: tile,
    );
  }
}

abstract class _TileFontSize {
  static double small = 36;
  static double medium = 50;
  static double large = 54;
}

/// {@template simple_puzzle_tile}
/// Displays the puzzle tile associated with [tile] and
/// the font size of [tileFontSize] based on the puzzle [state].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTile extends StatefulWidget {
  /// {@macro simple_puzzle_tile}
  const SimplePuzzleTile({
    Key? key,
    required this.tile,
    required this.tileFontSize,
    required this.state,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The font size of the tile to be displayed.
  final double tileFontSize;

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  State<SimplePuzzleTile> createState() => _SimplePuzzleTileState();
}

class _SimplePuzzleTileState extends State<SimplePuzzleTile>
    with TickerProviderStateMixin {
  late final AnimationController _controllerLottie;

  @override
  void initState() {
    super.initState();
    _controllerLottie = AnimationController(
      vsync: this,
      duration: globalAnimationDuration,
      lowerBound: TileAnimationEnum.inAnimation.bounds().first,
      upperBound: TileAnimationEnum.inAnimation.bounds().last,
    );
    _controllerLottie.forward();
  }

  @override
  void dispose() {
    _controllerLottie.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return TextButton(
      style: TextButton.styleFrom(
        primary: PuzzleColors.white,
        textStyle: PuzzleTextStyle.headline2.copyWith(
          fontSize: widget.tileFontSize,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ).copyWith(
        foregroundColor: MaterialStateProperty.all(PuzzleColors.white),
        // backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        //   (states) {
        //     if (widget.tile.value == widget.state.lastTappedTile?.value) {
        //       return theme.pressedColor;
        //     } else if (states.contains(MaterialState.hovered)) {
        //       return theme.hoverColor;
        //     } else {
        //       return theme.defaultColor;
        //     }
        //   },
        // ),
      ),
      onPressed: widget.state.puzzleStatus == PuzzleStatus.incomplete
          ? () => context.read<PuzzleBloc>().add(
                TileTapped(widget.tile),
              )
          : null,
      child: Transform.scale(
        scale: 2.5,
        child: Lottie.asset(
          lottieTileAnimationFile,
          animate: false,
          controller: _controllerLottie,
          delegates: LottieDelegates(
            text: (initialText) => widget.tile.letter,
            textStyle: (lottie) {
              return const TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'Rubik',
                color: Color(0xff6B6B6B),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// {@template puzzle_shuffle_button}
/// Displays the button to shuffle the puzzle.
/// {@endtemplate}
// @visibleForTesting
// class SimplePuzzleShuffleButton extends StatelessWidget {
//   /// {@macro puzzle_shuffle_button}
//   const SimplePuzzleShuffleButton({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return PuzzleButton(
//       textColor: PuzzleColors.primary0,
//       onPressed: () => context.read<PuzzleBloc>().add(const PuzzleReset()),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(
//             'assets/images/shuffle_icon.png',
//             width: 17,
//             height: 17,
//           ),
//           const Gap(10),
//           Text(context.l10n.puzzleShuffle),
//         ],
//       ),
//     );
//   }
// }
