import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mario_game/game/car_race.dart';

class MainMenuOverlay extends StatefulWidget {
  const MainMenuOverlay(this.game, {super.key});

  final Game game;

  @override
  State<MainMenuOverlay> createState() => _MainMenuOverlayState();
}

class _MainMenuOverlayState extends State<MainMenuOverlay> {
  Character character = Character.model1;

  @override
  Widget build(BuildContext context) {
    CarRace game = widget.game as CarRace;

    return LayoutBuilder(builder: (context, constraints) {
      final characterWidth = constraints.maxWidth / 5;

  
      return Material(
        color:const Color.fromARGB(255, 5, 7, 8),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/game/logo.png',
             scale:2,
                  
                  ),
                  const WhiteSpace(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text('Select your Car:',
                        style: Theme.of(context).textTheme.headlineSmall!),
                  ),
                  const WhiteSpace(height: 30),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CharacterButton(
                          character: Character.view1,
                          selected: character == Character.view1,
                          onSelectChar: () {
                            setState(() {
                              character = Character.view1;
                            });
                          },
                          characterWidth: characterWidth,
                        ),
                        CharacterButton(
                          character: Character.view2,
                          selected: character == Character.view2,
                          onSelectChar: () {
                            setState(() {
                              character = Character.view2;
                            });
                          },
                          characterWidth: characterWidth,
                        ),  CharacterButton(
                    character: Character.view3,
                    selected: character == Character.view3,
                    onSelectChar: () {
                      setState(() {
                        character = Character.view3;
                      });
                    },
                    characterWidth: characterWidth,
                  ),
                      ],
                    ),
                  ),
                
                  const WhiteSpace(height: 50),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        game.gameManager.selectCharacter(character,character,character);
                        game.startGame();
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                          const Size(100, 50),
                        ),
                        textStyle: MaterialStateProperty.all(
                            Theme.of(context).textTheme.titleLarge),
                      ),
                      child: const Text('Start'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class CharacterButton extends StatelessWidget {
  const CharacterButton(
      {super.key,
      required this.character,
      this.selected = false,
      required this.onSelectChar,
      required this.characterWidth});

  final Character character;
  final bool selected;
  final void Function() onSelectChar;
  final double characterWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextButton(
          style: (selected)
            ? ButtonStyle(
            side: MaterialStateProperty.all<BorderSide>(
              const BorderSide(
                color: Colors.white, 
                width: 2.0, 
              ),
            ), shape: MaterialStateProperty.all<OutlinedBorder>(
                   RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
          )
                        : null,
          onPressed: onSelectChar,
          child:   Column(
            children: [
          Image.asset(
                    'assets/images/game/${character.name}.png',
                    height: characterWidth,
                    width: 250,
                  ),    Text(
                      character.name,
                      style: const TextStyle(fontSize: 15),
                    ),
            ],
          ),
                      ), 
        ],
      ),
    );
  }
}

class WhiteSpace extends StatelessWidget {
  const WhiteSpace({super.key, this.height = 100});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
