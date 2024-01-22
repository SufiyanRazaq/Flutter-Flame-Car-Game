// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:mario_game/game/background.dart';
import 'package:mario_game/game/managers/game_manager.dart';
import 'package:mario_game/game/managers/object_manager.dart';
import 'package:mario_game/game/Player/competitor.dart';
import 'package:mario_game/game/Player/player.dart';

enum Character {
  model1,
  model2,
  model3,
  view1,
  view2,
  view3,
}
// Class representing the main game
class CarRace extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  CarRace({
    super.children,
  });

  // Game components
  final BackGround _backGround = BackGround();
  final GameManager gameManager = GameManager();
  ObjectManager objectManager = ObjectManager();
  int screenBufferSpace = 300;

  // Platform and player objects
  EnemyPlatform platFrom = EnemyPlatform();
  late Player player;

  // Audio pool for sound effects
  late AudioPool pool;

  @override
  FutureOr<void> onLoad() async {
    // Loading background and initializing game components
    await add(_backGround);
    await add(gameManager);
    overlays.add('gameOverlay');
    pool = await FlameAudio.createPool(
      'audi_sound.mp3',
      minPlayers: 3,
      maxPlayers: 4,
    );
  }

  // Starting background music
  void startBgmMusic() {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('audi_sound.mp3', volume: 1);
  }

  // Updating game state and camera position
  @override
  void update(double dt) {
    super.update(dt);
    if (gameManager.isGameOver) {
      return;
    }
    if (gameManager.isIntro) {
      overlays.add('mainMenuOverlay');
      return;
    }
    if (gameManager.isPlaying) {
      final Rect worldBounds = Rect.fromLTRB(
        0,
        camera.position.y - screenBufferSpace,
        camera.gameSize.x,
        camera.position.y + _backGround.size.y,
      );
      camera.worldBounds = worldBounds;
    }
  }

  // Setting up background color
  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 241, 247, 249);
  }

  // Setting the player's character and initializing the game
  void setCharacter() {
    player = Player(
      character: gameManager.character1,
      moveLeftRightSpeed: 600,
    );
    add(player);
  }

  // Initializing the game at the start
  void initializeGameStart() {
    setCharacter();

    gameManager.reset();

    if (children.contains(objectManager)) objectManager.removeFromParent();

    player.reset();
    camera.worldBounds = Rect.fromLTRB(
      0,
      -_backGround.size.y,
      camera.gameSize.x,
      _backGround.size.y + screenBufferSpace,
    );
    camera.followComponent(player);

    player.resetPosition();

    objectManager = ObjectManager();

    add(objectManager);
    startBgmMusic();
  }

  // Actions to be taken on losing the game
  void onLose() {
    gameManager.state = GameState.gameOver;
    player.removeFromParent();
    FlameAudio.bgm.stop();
    overlays.add('gameOverOverlay');
  }

  // Toggling the pause state of the game
  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }

  // Resetting the game state
  void resetGame() {
    startGame();
    overlays.remove('gameOverOverlay');
  }

  // Starting the game and initializing game state
  void startGame() {
    initializeGameStart();
    gameManager.state = GameState.playing;
    overlays.remove('mainMenuOverlay');
  }
}

