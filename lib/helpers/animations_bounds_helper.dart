import 'package:seletter/assets/constants.dart';
import 'package:seletter/models/models.dart';

/// Types of bounds that the animation has
enum LottieBoundType {
  /// Lower bounds of the animation
  lower,

  /// Upper bounds of the animation
  upper,
}

/// Types of animation that exist
enum LottieAnimationType {
  /// enter in scene
  iin,

  /// exit scene
  out,

  /// pressed with mouse or finger
  pressed,

  /// hovered by mouse
  hoverIn,

  /// When hovered out by mouse
  hoverOut,

  /// The correct indication animation
  correct,

  /// Existing correct animation
  correctOut,

  /// Entering correct animation
  correctIn,

  /// Sliding horizontal animation, only used in puzzle tile
  slideHorizontal,

  /// Sliding horizontal, only used in puzzle tile
  slideVertical,
}

/// Base class for the definition of all animations
abstract class LottieAnimation {
  /// Main constructor
  const LottieAnimation({
    required this.iin,
    required this.out,
    required this.lottieFile,
    required this.maxUpperBound,
  });

  /// File that has the animation
  final String lottieFile;

  /// The 'In' animation bounds in milliseconds
  /// 'in' is a reserved word 😔
  final Bounds iin;

  /// The 'Out' animation bounds in milliseconds
  final Bounds out;

  /// What is the maximum upper bound for this animation
  ///
  /// Used to calculate the bound animation to the value between 0 and 1.
  final double maxUpperBound;

  /// Returns the Bound for the animation
  double boundsByType(
    LottieAnimationType? type,
    LottieBoundType boundType,
  );

  /// Returns the lower bound
  double lowerBoundByType(LottieAnimationType? type) => boundsByType(
        type,
        LottieBoundType.lower,
      );

  /// Returns the lower bound
  double upperBoundByType(LottieAnimationType? type) => boundsByType(
        type,
        LottieBoundType.upper,
      );
}

/// Simple animation running in loop
///
class LottieSimpleAnimation extends LottieAnimation {
  /// Main Constructor
  const LottieSimpleAnimation({
    required Bounds iin,
    required Bounds out,
    required double max,
    required String file,
  }) : super(
          out: out,
          iin: iin,
          lottieFile: file,
          maxUpperBound: max,
        );

  @override
  double boundsByType(LottieAnimationType? type, LottieBoundType boundType) {
    switch (type) {
      case null:
      case LottieAnimationType.iin:
      case LottieAnimationType.out:
      case LottieAnimationType.pressed:
      case LottieAnimationType.hoverIn:
      case LottieAnimationType.hoverOut:
      case LottieAnimationType.correct:
      case LottieAnimationType.correctOut:
      case LottieAnimationType.correctIn:
      case LottieAnimationType.slideHorizontal:
      case LottieAnimationType.slideVertical:
        throw Exception('Animation has no animation for this type');
    }
  }
}

/// Animation of Buttons
///
/// Buttons there are only 2 : Primary and Secondary
///
/// argument 'isPrimary' will define what kind of animation to show
class LottieButtonAnimation extends LottieAnimation {
  /// Main constructor
  const LottieButtonAnimation({
    required Bounds iin,
    required Bounds out,
    required this.hoverIn,
    required this.pressed,
    required this.hoverOut,
    required bool isPrimary,
    required double max,
  }) : super(
          iin: iin,
          out: out,
          maxUpperBound: max,
          lottieFile: isPrimary
              ? lottieButtonPrimaryAnimationFile
              : lottieButtonSecondaryAnimationFile,
        );

  /// Bounds for animation of mouse hover in in milliseconds
  final Bounds hoverIn;

  /// Bounds for animation of pressed in milliseconds
  final Bounds pressed;

  /// Bounds for animation of mouse hover out in milliseconds
  final Bounds hoverOut;

  @override
  double boundsByType(LottieAnimationType? type, LottieBoundType boundType) {
    Bounds bounds;

    switch (type) {
      case LottieAnimationType.iin:
        bounds = iin;
        break;
      case LottieAnimationType.out:
        bounds = out;
        break;
      case LottieAnimationType.pressed:
        bounds = pressed;
        break;
      case LottieAnimationType.hoverIn:
        bounds = hoverIn;
        break;
      case LottieAnimationType.hoverOut:
        bounds = hoverOut;
        break;
      case null:
      case LottieAnimationType.correct:
      case LottieAnimationType.correctOut:
      case LottieAnimationType.correctIn:
      case LottieAnimationType.slideHorizontal:
      case LottieAnimationType.slideVertical:
        throw Exception('Animation has no animation for this type');
    }

    switch (boundType) {
      case LottieBoundType.lower:
        return bounds.lower / maxUpperBound;
      case LottieBoundType.upper:
        return bounds.upper / maxUpperBound;
    }
  }
}

/// Animation of the Puzzle Tile
class LottieTilePuzzleAnimation extends LottieAnimation {
  /// Main constructor
  const LottieTilePuzzleAnimation({
    required Bounds iin,
    required Bounds out,
    required this.correct,
    required this.correctOut,
    required this.slideHorizontal,
    required this.slideVertical,
    required double max,
  }) : super(
          iin: iin,
          out: out,
          lottieFile: lottieTileAnimationFile,
          maxUpperBound: max,
        );

  /// Bounds for animation when is correct in milliseconds
  final Bounds correct;

  /// Bounds for animation when is moving out correct in milliseconds
  final Bounds correctOut;

  /// Bounds for animation when slides horizontally in milliseconds
  final Bounds slideHorizontal;

  /// Bounds for animation when slides vertically in milliseconds
  final Bounds slideVertical;
  @override
  double boundsByType(LottieAnimationType? type, LottieBoundType boundType) {
    Bounds bounds;
    switch (type) {
      case LottieAnimationType.iin:
        bounds = iin;
        break;
      case LottieAnimationType.out:
        bounds = out;
        break;
      case LottieAnimationType.correct:
        bounds = correct;
        break;
      case LottieAnimationType.correctOut:
        bounds = correctOut;
        break;
      case LottieAnimationType.slideHorizontal:
        bounds = slideHorizontal;
        break;
      case LottieAnimationType.slideVertical:
        bounds = slideVertical;
        break;

      case null:
      case LottieAnimationType.correctIn:
      case LottieAnimationType.pressed:
      case LottieAnimationType.hoverIn:
      case LottieAnimationType.hoverOut:
        throw Exception('Animation has no animation for this type');
    }

    final value = bounds.toFractional(maxUpperBound, boundType);
    assert(
      value < 1 && value >= 0,
      'Bound has invalid fractional value, needs to be [0,1[',
    );
    return value;
  }
}

/// Animation of the Puzzle Tile Hint
class LottieTileHintAnimation extends LottieAnimation {
  /// Main constructor
  const LottieTileHintAnimation({
    required Bounds iin,
    required Bounds out,
    required this.correctOut,
    required this.correctIn,
    required this.correct,
    required double max,
  }) : super(
          iin: iin,
          out: out,
          lottieFile: lottieTileHintAnimationFile,
          maxUpperBound: max,
        );

  /// Bounds for animation hint is correct in milliseconds
  final Bounds correct;

  /// Bounds for animation hint is correct out in milliseconds
  final Bounds correctOut;

  /// Bounds for animation hint is correct In in milliseconds
  final Bounds correctIn;

  @override
  double boundsByType(LottieAnimationType? type, LottieBoundType boundType) {
    Bounds bounds;
    switch (type) {
      case LottieAnimationType.iin:
        bounds = iin;
        break;
      case LottieAnimationType.out:
        bounds = out;
        break;
      case LottieAnimationType.correct:
        bounds = correct;
        break;
      case LottieAnimationType.correctOut:
        bounds = correctOut;
        break;
      case LottieAnimationType.correctIn:
        bounds = correctIn;
        break;
      case null:
      case LottieAnimationType.pressed:
      case LottieAnimationType.hoverIn:
      case LottieAnimationType.hoverOut:
      case LottieAnimationType.slideHorizontal:
      case LottieAnimationType.slideVertical:
        throw Exception('Animation has no animation for this type');
    }
    final value = bounds.toFractional(maxUpperBound, boundType);
    assert(
      value < 1 && value >= 0,
      'Bound has invalid fractional value, needs to be [0,1[',
    );
    return value;
  }
}

/// Animation of the Star Small
class LottieStarSmallAnimation extends LottieAnimation {
  /// Main constructor
  const LottieStarSmallAnimation({
    required Bounds iin,
    required Bounds out,
    required this.correct,
    required this.correctOut,
    required double max,
  }) : super(
          iin: iin,
          out: out,
          lottieFile: lottieStarAnimationFile,
          maxUpperBound: max,
        );

  /// Bounds for animation marked level as done in milliseconds
  final Bounds correct;

  /// Bounds for animation animation !correct in milliseconds
  final Bounds correctOut;
  @override
  double boundsByType(LottieAnimationType? type, LottieBoundType boundType) {
    Bounds bounds;
    switch (type) {
      case LottieAnimationType.iin:
        bounds = iin;
        break;
      case LottieAnimationType.out:
        bounds = out;
        break;
      case LottieAnimationType.correct:
        bounds = correct;
        break;
      case LottieAnimationType.correctOut:
        bounds = correctOut;
        break;
      case null:
      case LottieAnimationType.pressed:
      case LottieAnimationType.hoverIn:
      case LottieAnimationType.hoverOut:
      case LottieAnimationType.correctIn:
      case LottieAnimationType.slideHorizontal:
      case LottieAnimationType.slideVertical:
        throw Exception('Animation has no animation for this type');
    }
    final value = bounds.toFractional(maxUpperBound, boundType);
    assert(
      value < 1 && value >= 0,
      'Bound has invalid fractional value, needs to be [0,1[',
    );
    return value;
  }
}

/// Animation of the Star Small
///
///
/// result:  Used to determine what is the result number to be presented
///
class LottieResultAnimation extends LottieAnimation {
  /// Main constructor
  const LottieResultAnimation({
    required Bounds iin,
    required Bounds out,
    required double max,
    required String file,
  }) : super(
          iin: iin,
          out: out,
          lottieFile: file,
          maxUpperBound: max,
        );

  @override
  double boundsByType(LottieAnimationType? type, LottieBoundType boundType) {
    Bounds bounds;
    switch (type) {
      case LottieAnimationType.iin:
        bounds = iin;
        break;
      case LottieAnimationType.out:
        bounds = out;
        break;
      case null:
      case LottieAnimationType.pressed:
      case LottieAnimationType.hoverIn:
      case LottieAnimationType.hoverOut:
      case LottieAnimationType.correct:
      case LottieAnimationType.correctOut:
      case LottieAnimationType.correctIn:
      case LottieAnimationType.slideHorizontal:
      case LottieAnimationType.slideVertical:
        throw Exception('Animation has no animation for this type');
    }

    final value = bounds.toFractional(maxUpperBound, boundType);
    assert(
      value < 1 && value >= 0,
      'Bound has invalid fractional value, needs to be [0,1[',
    );
    return value;
  }
}

/// All Lottie animations
class LottieAnimations {
  /// Button primary
  static const primaryButton = LottieButtonAnimation(
    iin: Bounds(0, 1000),
    hoverIn: Bounds(1000, 2000),
    pressed: Bounds(2000, 3000),
    hoverOut: Bounds(3000, 4000),
    out: Bounds(4000, 5000),
    isPrimary: true,
    max: 5000,
  );

  /// Button secondary
  static const secondaryButton = LottieButtonAnimation(
    iin: Bounds(0, 1000),
    hoverIn: Bounds(1000, 2000),
    pressed: Bounds(2000, 3000),
    hoverOut: Bounds(3000, 4000),
    out: Bounds(4000, 5000),
    isPrimary: false,
    max: 5000,
  );

  /// Tile puzzle
  static const tilePuzzle = LottieTilePuzzleAnimation(
    iin: Bounds(0, 1000),
    correct: Bounds(1000, 2000),
    correctOut: Bounds(2000, 3000),
    slideHorizontal: Bounds(4000, 5000),
    slideVertical: Bounds(5000, 6000),
    out: Bounds(6000, 7000),
    max: 7000,
  );

  /// Tile Hint
  static const tileHint = LottieTileHintAnimation(
    iin: Bounds(0, 1000),
    out: Bounds(1000, 2000),
    correct: Bounds(3000, 4000),
    correctOut: Bounds(4000, 5000),
    correctIn: Bounds(6000, 7000),
    max: 7000,
  );

  /// Start Small
  static const starSmall = LottieStarSmallAnimation(
    iin: Bounds(0, 1000),
    out: Bounds(1000, 2000),
    correct: Bounds(3000, 4000),
    correctOut: Bounds(4000, 5000),
    max: 5000,
  );

  /// Result 0 used in the final board
  static final result0 = LottieResultAnimation(
    iin: const Bounds(0, 300),
    out: const Bounds(300, 400),
    max: 400,
    file: lottieResultAnimations[0],
  );

  /// Result 0 used in the final board
  static final result1 = LottieResultAnimation(
    iin: const Bounds(0, 300),
    out: const Bounds(300, 400),
    max: 400,
    file: lottieResultAnimations[1],
  );

  /// Result 0 used in the final board
  static final result2 = LottieResultAnimation(
    iin: const Bounds(0, 300),
    out: const Bounds(300, 400),
    max: 400,
    file: lottieResultAnimations[2],
  );

  /// Result 0 used in the final board
  static final result3 = LottieResultAnimation(
    iin: const Bounds(0, 300),
    out: const Bounds(300, 400),
    max: 400,
    file: lottieResultAnimations[3],
  );

  /// Intro Logo animation
  static const introLogo = LottieSimpleAnimation(
    iin: Bounds(0, 1000),
    out: Bounds(1000, 2000),
    max: 2000,
    file: lottieMainLogoAnimationFile,
  );

  /// Tutorial animation
  static const tutorial = LottieSimpleAnimation(
    iin: Bounds(0, 1000),
    out: Bounds(1000, 2000),
    max: 2000,
    file: lottieTutorialAnimationFile,
  );
}
