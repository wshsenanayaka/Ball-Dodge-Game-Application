Ball Dodge Game 🎮

Ball Dodge Game is a mobile game built using Flutter and Flame Game Engine with Firebase integration. Players dodge falling balls while scoring points, with their progress stored in Firebase. The application includes user authentication, a player profile, and offline capabilities.

Overview

Ball Dodge Game challenges the player to avoid falling balls while accumulating points. It includes:
User authentication via Firebase (Login / Register)
Player profile with score tracking
Dynamic gameplay with increasing difficulty
Online/offline data synchronization
The game is suitable for both learning Flutter and demonstrating mobile game design principles.


Architecture & Design
Major Design Decisions
Flutter + Flame for rapid cross-platform development.

Firebase for authentication, Firestore for storing user scores.
State Management via ValueNotifier for reactive UI updates.
Data Flow & Interaction
UI Layer: Screens (LoginPage, RegisterPage, GameScreen, ProfilePage)
Game Layer: BallDodgeGame handles gameplay, player movement, ball generation, and scoring.
Data Layer: FirebaseHelper manages CRUD operations for user scores.