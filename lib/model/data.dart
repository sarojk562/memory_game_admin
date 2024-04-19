import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';

String imagePath = levelOneImagePath;
const levelOneImagePath = 'assets/images/level_one_images';
const levelTwoImagePath = 'assets/images/level_two_images';
const levelThreeImagePath = 'assets/images/level_three_images';

List<String> imageSource() {
  return [
    '$imagePath/image_1.png',
    '$imagePath/image_2.png',
    '$imagePath/image_3.png',
    '$imagePath/image_4.png',
    '$imagePath/image_5.png',
    '$imagePath/image_6.png',
    '$imagePath/image_7.png',
    '$imagePath/image_8.png',
    '$imagePath/image_1.png',
    '$imagePath/image_2.png',
    '$imagePath/image_3.png',
    '$imagePath/image_4.png',
    '$imagePath/image_5.png',
    '$imagePath/image_6.png',
    '$imagePath/image_7.png',
    '$imagePath/image_8.png',
  ];
}

List<String> level1Images = [
  "$imagePath/image_6.png",
  "$imagePath/image_3.png",
  "$imagePath/image_1.png",
  "$imagePath/image_8.png",
  "$imagePath/image_7.png",
  "$imagePath/image_4.png",
  "$imagePath/image_2.png",
  "$imagePath/image_5.png",
  "$imagePath/image_8.png",
  "$imagePath/image_4.png",
  "$imagePath/image_7.png",
  "$imagePath/image_3.png",
  "$imagePath/image_1.png",
  "$imagePath/image_5.png",
  "$imagePath/image_6.png",
  "$imagePath/image_2.png"
];

List<String> level2Images = [
  "$imagePath/image_7.png",
  "$imagePath/image_1.png",
  "$imagePath/image_3.png",
  "$imagePath/image_2.png",
  "$imagePath/image_5.png",
  "$imagePath/image_2.png",
  "$imagePath/image_8.png",
  "$imagePath/image_4.png",
  "$imagePath/image_8.png",
  "$imagePath/image_5.png",
  "$imagePath/image_6.png",
  "$imagePath/image_6.png",
  "$imagePath/image_3.png",
  "$imagePath/image_4.png",
  "$imagePath/image_1.png",
  "$imagePath/image_7.png"
];

List<String> level3Images = [
  "$imagePath/image_5.png",
  "$imagePath/image_7.png",
  "$imagePath/image_4.png",
  "$imagePath/image_3.png",
  "$imagePath/image_6.png",
  "$imagePath/image_2.png",
  "$imagePath/image_4.png",
  "$imagePath/image_1.png",
  "$imagePath/image_1.png",
  "$imagePath/image_7.png",
  "$imagePath/image_8.png",
  "$imagePath/image_5.png",
  "$imagePath/image_6.png",
  "$imagePath/image_3.png",
  "$imagePath/image_8.png",
  "$imagePath/image_2.png",
];

List createShuffledListFromImageSource() {
  List shuffledImages = [];
  List sourceArray = imageSource();
  for (var element in sourceArray) {
    shuffledImages.add(element);
  }
  shuffledImages.shuffle();
  return sourceArray;
}

List<bool> getInitialItemStateList() {
  List<bool> initialItem = <bool>[];
  for (int i = 0; i < 16; i++) {
    initialItem.add(true);
  }
  return initialItem;
}

List<GlobalKey<FlipCardState>> createFlipCardStateKeysList() {
  List<GlobalKey<FlipCardState>> cardStateKeys = <GlobalKey<FlipCardState>>[];
  for (int i = 0; i < 16; i++) {
    cardStateKeys.add(GlobalKey<FlipCardState>());
  }
  return cardStateKeys;
}
