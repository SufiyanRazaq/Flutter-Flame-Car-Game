import 'dart:io' show Platform;
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mario_game/game/car_race.dart';
import 'package:mario_game/game/widgets/main_menu_overlay.dart';
import 'package:mario_game/game/widgets/score_display.dart';

// Class representing the game overlay with in-game controls and UI
class GameOverlay extends StatefulWidget {
  const GameOverlay(this.game, {super.key});

  final Game game;

  @override
  State<GameOverlay> createState() => GameOverlayState();
}

// State class for the GameOverlay widget
class GameOverlayState extends State<GameOverlay> {
  bool isPaused = false;
  final bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  final Game game = CarRace();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: 30,
            child: GameScoreDisplay(game: widget.game),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: ElevatedButton(
              child: isPaused
                  ? const Icon(
                      Icons.play_arrow,
                      size: 48,
                    )
                  : const Icon(
                      Icons.pause,
                      size: 48,
                    ),
              onPressed: () {
                (widget.game as CarRace).togglePauseState();
                setState(
                  () {
                    isPaused = !isPaused;
                  },
                );
              },
            ),
          ),
          // In-game controls for mobile devices
          Positioned(
            bottom: 10,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: GestureDetector(
                          onTapDown: (details) {
                            (widget.game as CarRace).player.moveLeft();
                          },
                          onTapUp: (details) {
                            (widget.game as CarRace).player.resetDirection();
                          },
                          child: const Material(
                            color: Colors.transparent,
                            elevation: 3.0,
                            shadowColor: Color.fromARGB(255, 186, 14, 14),
                            child: Icon(Icons.arrow_left, size: 64),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        onTapDown: (details) {
                          (widget.game as CarRace).player.moveRight();
                        },
                        onTapUp: (details) {
                          (widget.game as CarRace).player.resetDirection();
                        },
                        child: const Material(
                          color: Colors.transparent,
                          elevation: 3.0,
                          shadowColor: Color.fromARGB(255, 186, 14, 14),
                          child: Icon(Icons.arrow_right, size: 64),
                        ),
                      ),
                    ],
                  ),
                  const WhiteSpace(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          // Pause overlay
          if (isPaused)
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 72.0,
              right: MediaQuery.of(context).size.width / 2 - 72.0,
              child: const Icon(
                Icons.pause_circle,
                size: 144.0,
                color: Colors.black12,
              ),
            ),
        ],
      ),
    );
  }
}
