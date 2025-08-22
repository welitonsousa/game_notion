// import 'package:fast_ui_kit/fast_ui_kit.dart';
// import 'package:flutter/material.dart';

// enum GameState {
//   playing,
//   finished,
//   platinum,
//   wishlist,
//   paused;

//   String get label {
//     return switch (this) {
//       playing => 'Jogando',
//       finished => 'Zerado',
//       platinum => 'Platinado',
//       wishlist => 'Lista de Desejos',
//       paused => 'Parado',
//     };
//   }

//   IconData get icon {
//     return switch (this) {
//       playing => FastIcons.awesome.gamepad,
//       finished => FastIcons.feather.award,
//       platinum => FastIcons.awesome.trophy,
//       wishlist => FastIcons.awesome.heart,
//       paused => FastIcons.awesome.clock_o
//     };
//   }

//   int get id {
//     return switch (this) {
//       playing => 0,
//       finished => 1,
//       wishlist => 2,
//       platinum => 3,
//       paused => 4,
//     };
//   }

//   static GameState? fromId(int? id) {
//     return switch (id) {
//       0 => playing,
//       1 => finished,
//       3 => platinum,
//       2 => wishlist,
//       4 => paused,
//       _ => null,
//     };
//   }

//   @override
//   String toString() {
//     return label;
//   }
// }
