import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:mario_game/game/car_race.dart';

// Class responsible for managing the game state
class GameManager extends Component with HasGameRef<CarRace> {
  GameManager();

  // Creating characters and initializing game state
  Character character1 = Character.model1;
  Character character2 = Character.model1;
  Character character3 = Character.model1;
  ValueNotifier<int> score = ValueNotifier(0);
  GameState state = GameState.intro;
  Character selectedCharacter1 = Character.model1;
  Character selectedCharacter2 = Character.model2;
  Character selectedCharacter3 = Character.model3;

  // Check game state conditions
  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isIntro => state == GameState.intro;

  // Resetting the game state
  void reset() {
    score.value = 0;
    state = GameState.intro;
  }

  // Increasing the player's score
  void increaseScore() {
    score.value++;
  }

  // Selecting characters for the game
  void selectCharacter(
      Character selectedCharcter, Character selectCharacter2, Character selectCharacter3) {
    character1 = selectedCharacter1;
    character2 = selectedCharacter2;
    character3 = selectedCharacter3;
  }
}

// Enum representing different game states
enum GameState { intro, playing, gameOver }
