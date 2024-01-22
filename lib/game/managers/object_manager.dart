import 'dart:math';

import 'package:flame/components.dart';
import 'package:mario_game/game/managers/game_manager.dart';
import 'package:mario_game/game/car_race.dart';
import 'package:mario_game/game/Player/competitor.dart';

final Random _rand = Random();

// Class managing game objects and enemies
class ObjectManager extends Component with HasGameRef<CarRace> {
  ObjectManager();

  @override
  void onMount() {
    super.onMount();

    // Adding initial enemy and scheduling additional enemies
    addEnemy(1);
    _maybeAddEnemy();
  }

  @override
  void update(double dt) {
    // Updating score during gameplay
    if (gameRef.gameManager.state == GameState.playing) {
      gameRef.gameManager.increaseScore();
    }

    // Adding enemies continuously
    addEnemy(1);

    super.update(dt);
  }

  // Map to track special platforms
  final Map<String, bool> specialPlatforms = {
    'enemy': false,
  };

  // Enable a specific type of specialty
  void enableSpecialty(String specialty) {
    specialPlatforms[specialty] = true;
  }

  // Adding enemies based on the level
  void addEnemy(int level) {
    switch (level) {
      case 1:
        enableSpecialty('enemy');
    }
  }

  final List<EnemyPlatform> _enemies = [];

  // Adding enemies at intervals and cleaning up
  void _maybeAddEnemy() {
    if (specialPlatforms['enemy'] != true) {
      return;
    }

    var currentX = (gameRef.size.x.floor() / 1).toDouble() - 50;
    var currentY = gameRef.size.y - (_rand.nextInt(gameRef.size.y.floor()) / 3) - 30;

    var enemy = EnemyPlatform(
      position: Vector2(
        currentX,
        currentY,
      ),
    );
    add(enemy);
    _enemies.add(enemy);
    _cleanupEnemies();
  }

  // Cleaning up enemies after a certain duration
  void _cleanupEnemies() {
    Future.delayed(
      const Duration(seconds: 4),
      () {
        _enemies.clear();
        Future.delayed(
          const Duration(seconds: 1),
          () {
            _maybeAddEnemy();
          },
        );
      },
    );
  }
}

