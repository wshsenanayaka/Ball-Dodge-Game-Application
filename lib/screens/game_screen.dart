import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../game/ball_dodge_game.dart';
import '../utils/firebase_helper.dart';
import 'profile_page.dart';
import '../widgets/control_button.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late BallDodgeGame game;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    game = BallDodgeGame();

    // Called when the game detects a game over
    game.onGameOver = () async {
      if (currentUser != null) {
        int finalScore = game.score; // Ensure score is int

        // Update user score in Firestore
        await FirebaseHelper.updateUserScore(currentUser!.uid, finalScore);

        // Sync score if needed
        await FirebaseHelper.syncScore(currentUser!.uid);

        // Show overlay
        game.overlays.add('GameOver');
      }
    };
  }

  @override
  void dispose() {
    game.onGameOver = null;
    game.pauseEngine();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget<BallDodgeGame>(
            game: game,
            overlayBuilderMap: {
              'GameOver': (context, game) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Game Over',
                          style: TextStyle(fontSize: 32, color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Score: ${game.score}',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            game.reset();
                            game.overlays.remove('GameOver');
                            game.resumeEngine();
                          },
                          child: const Text('Restart'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ProfilePage()),
                            );
                          },
                          child: const Text('Profile'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            },
          ),

          // Top controls: score and profile
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: game.scoreNotifier,
                  builder: (_, score, __) {
                    return Text(
                      'Score: $score',
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ProfilePage()),
                    );
                  },
                ),
              ],
            ),
          ),

          // Left control
          Positioned(
            bottom: 30,
            left: 20,
            child: ControlButton(
              icon: Icons.arrow_left,
              label: 'Left',
              color: Colors.blueAccent,
              onPressed: () => game.player.moveLeft(30),
            ),
          ),

          // Right control
          Positioned(
            bottom: 30,
            right: 20,
            child: ControlButton(
              icon: Icons.arrow_right,
              label: 'Right',
              color: Colors.orangeAccent,
              onPressed: () => game.player.moveRight(30),
            ),
          ),

          // Pause/Resume toggle
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: ElevatedButton(
              onPressed: () {
                game.paused ? game.resumeEngine() : game.pauseEngine();
                setState(() {});
              },
              child: Text(game.paused ? 'Resume' : 'Pause'),
            ),
          ),
        ],
      ),
    );
  }
}
