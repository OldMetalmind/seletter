import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:seletter/helpers/animations_bounds_helper.dart';
import 'package:seletter/models/models.dart';

// A 3x3 puzzle board visualization:
//
//   ┌─────1───────2───────3────► x
//   │  ┌─────┐ ┌─────┐ ┌─────┐
//   1  │  1  │ │  2  │ │  3  │
//   │  └─────┘ └─────┘ └─────┘
//   │  ┌─────┐ ┌─────┐ ┌─────┐
//   2  │  4  │ │  5  │ │  6  │
//   │  └─────┘ └─────┘ └─────┘
//   │  ┌─────┐ ┌─────┐
//   3  │  7  │ │  8  │
//   │  └─────┘ └─────┘
//   ▼
//   y
//
// This puzzle is in its completed state (i.e. the tiles are arranged in
// ascending order by value from top to bottom, left to right).
//
// Each tile has a value (1-8 on example above), and a correct and current
// position.
//
// The correct position is where the tile should be in the completed
// puzzle. As seen from example above, tile 2's correct position is (2, 1).
// The current position is where the tile is currently located on the board.

/// {@template puzzle}
/// Model for a puzzle.
/// {@endtemplate}
class Puzzle extends Equatable {
  /// {@macro puzzle}
  const Puzzle({
    required this.tiles,
  });

  /// List of [Tile]s representing the puzzle's current arrangement.
  final List<Tile> tiles;

  /// Get the dimension of a puzzle given its tile arrangement.
  ///
  /// Ex: A 4x4 puzzle has a dimension of 4.
  int getDimension() {
    return sqrt(tiles.length).toInt();
  }

  /// Gets the single whitespace tile object in the puzzle.
  Tile getWhitespaceTile() {
    return tiles.singleWhere((tile) => tile.isWhitespace);
  }

  /// Gets the tile relative to the whitespace tile in the puzzle
  /// defined by [relativeOffset].
  Tile? getTileRelativeToWhitespaceTile(Offset relativeOffset) {
    final whitespaceTile = getWhitespaceTile();
    return tiles.singleWhereOrNull(
      (tile) =>
          tile.currentPosition.x ==
              whitespaceTile.currentPosition.x + relativeOffset.dx &&
          tile.currentPosition.y ==
              whitespaceTile.currentPosition.y + relativeOffset.dy,
    );
  }

  /// Determines if the puzzle is completed. By determining if the words is
  /// correctly positioned
  List<Position> isComplete(Map<int, String> stageWords) {
    final size = getDimension();
    final word = stageWords[size];

    final horizontal = StringBuffer();
    final vertical = StringBuffer();

    final correctPosition = <Position>[];

    // Horizontal
    for (var y = 1; y <= size; y++) {
      for (var x = 1; x <= size; x++) {
        horizontal.write(getLetterByPosition(x, y));
        correctPosition.add(Position(x: x, y: y));

        if (horizontal.toString() == word) {
          return correctPosition;
        }
      }
      correctPosition.clear();
      horizontal.clear();
    }

    // Vertical
    for (var x = 1; x <= size; x++) {
      for (var y = 1; y <= size; y++) {
        vertical.write(getLetterByPosition(x, y));
        correctPosition.add(Position(x: x, y: y));

        if (vertical.toString() == word) {
          return correctPosition;
        }
      }
      correctPosition.clear();
      vertical.clear();
    }

    return <Position>[];
  }

  /// Given certain position coordinates, return the letter in that position
  String getLetterByPosition(int x, int y) {
    return tiles
        .firstWhere((t) => t.currentPosition.x == x && t.currentPosition.y == y)
        .letter;
  }

  /// Determines if the tapped tile can move in the direction of the whitespace
  /// tile.
  bool isTileMovable(Tile tile) {
    final whitespaceTile = getWhitespaceTile();
    if (tile == whitespaceTile) {
      return false;
    }

    // A tile must be next to a whitespace to move.
    //
    //  V - Can move to the whitespace
    //  X - Can't move to the white space
    //
    //   ┌─────1───────2───────3────► x
    //   │  ┌─────┐ ┌─────┐ ┌─────┐
    //   1  │  X  │ │  V  │ │  X  │
    //   │  └─────┘ └─────┘ └─────┘
    //   │  ┌─────┐         ┌─────┐
    //   2  │  V  │         │  V  │
    //   │  └─────┘         └─────┘
    //   │  ┌─────┐ ┌─────┐ ┌─────┐
    //   3  │  X  │ │  V  │ │  X  │
    //   │  └─────┘ └─────┘ └─────┘
    //   ▼
    //   y
    //
    final whitePosition = whitespaceTile.currentPosition;
    final tilePosition = tile.currentPosition;
    if ((whitePosition.x + 1 == tilePosition.x &&
            whitePosition.y == tilePosition.y) ||
        (whitePosition.x - 1 == tilePosition.x &&
            whitePosition.y == tilePosition.y) ||
        (whitePosition.y + 1 == tilePosition.y &&
            whitePosition.x == tilePosition.x) ||
        (whitePosition.y - 1 == tilePosition.y &&
            whitePosition.x == tilePosition.x)) {
      return true;
    }
    return false;
  }

  /// Determines if the puzzle is solvable.
  bool isSolvable() {
    return true;
    final size = getDimension();
    final height = tiles.length ~/ size;
    assert(
      size * height == tiles.length,
      'tiles must be equal to size * height',
    );
    final inversions = countInversions();

    if (size.isOdd) {
      return inversions.isEven;
    }

    final whitespace = tiles.singleWhere((tile) => tile.isWhitespace);
    final whitespaceRow = whitespace.currentPosition.y;

    if (((height - whitespaceRow) + 1).isOdd) {
      return inversions.isEven;
    } else {
      return inversions.isOdd;
    }
  }

  /// Gives the number of inversions in a puzzle given its tile arrangement.
  ///
  /// An inversion is when a tile of a lower value is in a greater position than
  /// a tile of a higher value.
  int countInversions() {
    var count = 0;
    for (var a = 0; a < tiles.length; a++) {
      final tileA = tiles[a];
      if (tileA.isWhitespace) {
        continue;
      }

      for (var b = a + 1; b < tiles.length; b++) {
        final tileB = tiles[b];
        if (_isInversion(tileA, tileB)) {
          count++;
        }
      }
    }
    return count;
  }

  /// Determines if the two tiles are inverted.
  bool _isInversion(Tile a, Tile b) {
    if (!b.isWhitespace && a.value != b.value) {
      if (b.value < a.value) {
        return b.currentPosition.compareTo(a.currentPosition) > 0;
      } else {
        return a.currentPosition.compareTo(b.currentPosition) > 0;
      }
    }
    return false;
  }

  /// Shifts one or many tiles in a row/column with the whitespace and returns
  /// the modified puzzle.
  ///
  // Recursively stores a list of all tiles that need to be moved and passes the
  // list to _swapTiles to individually swap them.
  Puzzle moveTiles(Tile tile, List<Tile> tilesToSwap) {
    final whitespaceTile = getWhitespaceTile();
    final deltaX = whitespaceTile.currentPosition.x - tile.currentPosition.x;
    final deltaY = whitespaceTile.currentPosition.y - tile.currentPosition.y;

    if ((deltaX.abs() + deltaY.abs()) > 1) {
      final shiftPointX = tile.currentPosition.x + deltaX.sign;
      final shiftPointY = tile.currentPosition.y + deltaY.sign;
      final tileToSwapWith = tiles.singleWhere(
        (tile) =>
            tile.currentPosition.x == shiftPointX &&
            tile.currentPosition.y == shiftPointY,
      );
      tilesToSwap.add(tile);
      return moveTiles(tileToSwapWith, tilesToSwap);
    } else {
      tilesToSwap.add(tile);
      return _swapTiles(tilesToSwap);
    }
  }

  /// Returns puzzle with new tile arrangement after individually swapping each
  /// tile in tilesToSwap with the whitespace.
  Puzzle _swapTiles(List<Tile> tilesToSwap) {
    for (final tileToSwap in tilesToSwap.reversed) {
      final tileIndex = tiles.indexOf(tileToSwap);
      final tile = tiles[tileIndex];
      final whitespaceTile = getWhitespaceTile();
      final whitespaceTileIndex = tiles.indexOf(whitespaceTile);

      // Swap current board positions of the moving tile and the whitespace.
      tiles[tileIndex] = tile.copyWith(
        currentPosition: whitespaceTile.currentPosition,
      );
      tiles[whitespaceTileIndex] = whitespaceTile.copyWith(
        currentPosition: tile.currentPosition,
      );
    }

    return Puzzle(tiles: tiles);
  }

  /// Sorts puzzle tiles so they are in order of their current position.
  Puzzle sort() {
    final sortedTiles = tiles.toList()
      ..sort((tileA, tileB) {
        return tileA.currentPosition.compareTo(tileB.currentPosition);
      });
    return Puzzle(tiles: sortedTiles);
  }

  /// Returns the animation that the tapped tile should run.
  LottieAnimationType? getAnimationToRunOnTile(Tile? tappedTile) {
    final whiteSpace = getWhitespaceTile();
    if (tappedTile == null) {
      return null;
    } else if (tappedTile.currentPosition.x == whiteSpace.currentPosition.x) {
      return LottieAnimationType.slideHorizontal;
    } else if (tappedTile.currentPosition.y == whiteSpace.currentPosition.y) {
      return LottieAnimationType.slideVertical;
    }

    return null;
  }

  @override
  List<Object> get props => [tiles];
}
