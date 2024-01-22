import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mario_game/game/car_race.dart';
// Abstract class representing a competitor in the game
abstract class Competitor<T> extends SpriteGroupComponent<T>
    with HasGameRef<CarRace>, CollisionCallbacks {
        // Properties for hitbox, direction, velocity, and speed
  final hitbox = RectangleHitbox();

  double direction = 1;
  final Vector2 _velocity = Vector2.zero();
  double speed = 150;
  // Constructor for Competitor class
  Competitor({
    super.position,
    Vector2? enemySize, 
  }) : super(
          size: enemySize ?? Vector2.all(60),
          priority: 1,
        );  
        // onLoad function to initialize the competitor's position and hitbox
  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    await add(hitbox);

    final points = getRandomPostionOfEnemy();

    position = Vector2(points.xPoint, points.yPoint);
  }
  // Move function to update the position based on velocity and direction

  void _move(double dt) {
    _velocity.y = direction * speed;

    position += _velocity * dt;
  }
  // Update function to handle the competitor's movement

  @override
  void update(double dt) {
    _move(dt);
    super.update(dt);
  }
  // Function to get a random position for the competitor

  ({double xPoint, double yPoint}) getRandomPostionOfEnemy() {
    final random = Random();
    final randomXPoint =
        50 + random.nextInt((gameRef.size.x.toInt() - 100) - 50);

    final randomYPoint = 50 + random.nextInt(60 - 50);

    return (
      xPoint: randomXPoint.toDouble(),
      yPoint: randomYPoint.toDouble(),
    );
  }
}
// Enum representing different states of an enemy platform

enum EnemyPlatformState { only }
// Class representing an enemy platform in the game

class EnemyPlatform extends Competitor<EnemyPlatformState> {
  EnemyPlatform({super.position});
  // List of available enemy models

  final List<String> enemy = [
    'model1',
    'model2',
    'model3',
    'model4',
    'model5'
  ];
  // onLoad function to initialize the enemy platform with a random enemy model

  @override
  Future<void>? onLoad() async {
    int enemyIndex = Random().nextInt(enemy.length);

    String enemySprite = enemy[enemyIndex];

    sprites = <EnemyPlatformState, Sprite>{
      EnemyPlatformState.only:
          await gameRef.loadSprite('game/$enemySprite.png'),
    };

    current = EnemyPlatformState.only;

    return super.onLoad();
  }
}
