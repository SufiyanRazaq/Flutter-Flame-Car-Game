import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:mario_game/game/car_race.dart';
// Enum representing different states of the player
enum PlayerState {
  left,
  right,
  center,
}

// Class representing the player in the game
class Player extends SpriteGroupComponent<PlayerState>
    with HasGameRef<CarRace>, KeyboardHandler, CollisionCallbacks {
  // Properties for character, movement speed, input, and velocity
  Player({
    required this.character,
    this.moveLeftRightSpeed = 700,
  }) : super(
          size: Vector2(50, 80),
          anchor: Anchor.center,
          priority: 1,
        );

  // Movement speed for left and right
  double moveLeftRightSpeed;
  Character character;

  // Input and velocity properties
  int _hAxisInput = 0;
  final int movingLeftInput = -1;
  final int movingRightInput = 1;
  Vector2 _velocity = Vector2.zero();

  // onLoad function to set up player hitbox and load character sprites
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    await add(CircleHitbox());
    await _loadCharacterSprites();
    current = PlayerState.center;
  }

  // Update function to handle player movement and collisions
  @override
  void update(double dt) {
    if (gameRef.gameManager.isIntro || gameRef.gameManager.isGameOver) return;

    _velocity.x = _hAxisInput * moveLeftRightSpeed;

    // Keep player within screen bounds
    final double marioHorizontalCenter = size.x / 2;
    if (position.x < marioHorizontalCenter) {
      position.x = gameRef.size.x - (marioHorizontalCenter);
    }
    if (position.x > gameRef.size.x - (marioHorizontalCenter)) {
      position.x = marioHorizontalCenter;
    }

    position += _velocity * dt;

    super.update(dt);
  }

  // onCollision function to handle player collision with other components
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Handle game loss on collision
    gameRef.onLose();
    return;
  }

  // onKeyEvent function to handle keyboard input for player movement
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      moveLeft();
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      moveRight();
    }

    return true;
  }

  // Function to set player movement to the left
  void moveLeft() {
    _hAxisInput = 0;
    current = PlayerState.left;
    _hAxisInput += movingLeftInput;
  }

  // Function to set player movement to the right
  void moveRight() {
    _hAxisInput = 0;
    current = PlayerState.right;
    _hAxisInput += movingRightInput;
  }

  // Function to reset player movement direction
  void resetDirection() {
    _hAxisInput = 0;
  }

  // Function to reset player properties
  void reset() {
    _velocity = Vector2.zero();
    current = PlayerState.center;
  }

  // Function to reset player position
  void resetPosition() {
    position = Vector2(
      (gameRef.size.x - size.x) / 2,
      (gameRef.size.y - size.y) / 2,
    );
  }

  // Function to load character sprites
  Future<void> _loadCharacterSprites() async {
    final left = await gameRef.loadSprite('game/${character.name}.png');
    final right = await gameRef.loadSprite('game/${character.name}.png');
    final center = await gameRef.loadSprite('game/${character.name}.png');

    sprites = <PlayerState, Sprite>{
      PlayerState.left: left,
      PlayerState.right: right,
      PlayerState.center: center,
    };
  }
}
