import 'package:selector/assets/constants.dart';
import 'package:selector/helpers/animation_helper.dart';
import 'package:selector/models/tile.dart';

/// Animation enum supporting the times
enum TileAnimationEnum {
  /// when the tile is idle and has not action
  inAnimation,

  /// Triggered when the tile is in the correct position
  correct,

  /// Scales the animation out
  correctOut,

  /// For when sliding the piece horizontally
  slideHorizontal,

  /// For when sliding the piece vertically
  slideVertical,

  /// Scale out the piece in place
  outAnimation,
}

/// Times for lottie animation tile_puzzle.json
/// 0 — 0.34: Scale in -> Idle
/// 1.51 — 2.42: Idle -> Correct
/// 2.42 — 2.58: Correct -> Correct scale out
/// 3.46 — 3.64: Slide Horizontal
/// 3.74 — 3.92: Slide Vertical
/// 4.32 — 4.64: Normal Scale Out
extension TileAnimationEnumExtension on TileAnimationEnum {
  /// Gets the bounds animation of the animation itself
  List<double> bounds() {
    List<double> bounds;
    switch (this) {
      case TileAnimationEnum.inAnimation:
        bounds = AnimationBounds.idle;
        break;
      case TileAnimationEnum.correct:
        bounds = AnimationBounds.correct;
        break;
      case TileAnimationEnum.correctOut:
        bounds = AnimationBounds.correctScaleOut;
        break;
      case TileAnimationEnum.slideHorizontal:
        bounds = AnimationBounds.slideHorizontal;
        break;
      case TileAnimationEnum.slideVertical:
        bounds = AnimationBounds.slideVertical;
        break;
      case TileAnimationEnum.outAnimation:
        bounds = AnimationBounds.normalScaleOut;
        break;
    }

    return bounds.map((e) => e).toList();
  }
}

/// Model assistant for animation
class TileAnimation {
  /// Basic constructor
  TileAnimation(this.animation);

  /// Constructor based on the tiles passes
  TileAnimation.fromTiles(
    Tile? tapped,
    Tile? space,
  ) : this(
          _determineAnimation(tapped, space),
        );

  /// What is the state of this tile
  TileAnimationEnum animation;

  /// File used in all tile animations
  static const String file = lottieTileAnimationFile;

  /// Getter of lottie animation file
  String get animationFile => file;

  static TileAnimationEnum _determineAnimation(Tile? tapped, Tile? space) {
    assert(space?.isWhitespace ?? false, 'Space should be the whitespace Tile');

    if (tapped != null && space != null) {
      if (tapped.currentPosition.x < space.currentPosition.x) {
        return TileAnimationEnum.slideHorizontal;
      }

      if (tapped.currentPosition.y < space.currentPosition.y) {
        return TileAnimationEnum.slideVertical;
      }
    }

    return TileAnimationEnum.inAnimation;
  }
}
