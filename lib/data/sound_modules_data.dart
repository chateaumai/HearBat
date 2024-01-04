import 'answer_pair.dart';
final List<AnswerGroup> chapter1module1SoundGroups = [
  AnswerGroup(
    Answer("Door Close", "assets/audio/sounds/home/door close.wav"),
    Answer("Kettle Whistling", "assets/audio/sounds/home/kettle whistling.wav"),
    Answer("Cat Meow", "assets/audio/sounds/home/cat meow.wav"),
    Answer("Printer", "assets/audio/sounds/home/printer.wav")),
  AnswerGroup(
    Answer("Toilet Flush", "assets/audio/sounds/home/toilet flush.wav"),
    Answer("Wind Chimes", "assets/audio/sounds/home/wind chimes.wav"),
    Answer("Telephone Ringing", "assets/audio/sounds/home/telephone ringing.wav"),
    Answer("Vacuum", "assets/audio/sounds/home/vacuum.wav")),
  AnswerGroup(
    Answer("Dog Bark", "assets/audio/sounds/home/dog bark.wav"),
    Answer("Microwave", "assets/audio/sounds/home/microwave.wav"),
    Answer("Pencil Writing", "assets/audio/sounds/home/pencil writing.wav"),
    Answer("Clock Ticking", "assets/audio/sounds/home/clock ticking.wav")),
  AnswerGroup(
    Answer("Alarm Clock Beep", "assets/audio/sounds/home/alarm clock beep.wav"),
    Answer("Garbage Disposal", "assets/audio/sounds/home/garbage disposal.wav"),
    Answer("Doorbell", "assets/audio/sounds/home/doorbell.wav"),
    Answer("Washing Machine", "assets/audio/sounds/home/washing machine.wav")),
  AnswerGroup(
    Answer("Computer Keyboard Clicking", "assets/audio/sounds/home/computer keyboard clicking.wav"),
    Answer("Shower Curtains", "assets/audio/sounds/home/shower curtains.mp3"),
    Answer("Knife Sharpen", "assets/audio/sounds/home/knife sharpen.wav"),
    Answer("Ice Dispenser", "assets/audio/sounds/home/ice dispenser.wav")),
  AnswerGroup(
    Answer("Electric Shaver", "assets/audio/sounds/home/electric shaver.wav"),
    Answer("Cutting Paper", "assets/audio/sounds/home/cutting paper.wav"),
    Answer("Book Page Flipping", "assets/audio/sounds/home/book page flipping.wav"),
    Answer("Mouse Click", "assets/audio/sounds/home/mouse click.wav")),
  AnswerGroup(
    Answer("Toothbrush Brushing", "assets/audio/sounds/home/toothbrush brushing.wav"),
    Answer("Telephone Ringing", "assets/audio/sounds/home/telephone ringing.wav"),
    Answer("Dog Bark", "assets/audio/sounds/home/dog bark.wav"),
    Answer("Printer", "assets/audio/sounds/home/printer.wav")),
  AnswerGroup(
    Answer("Door Close", "assets/audio/sounds/home/door close.wav"),
    Answer("Kettle Whistling", "assets/audio/sounds/home/kettle whistling.wav"),
    Answer("Alarm Clock Beep", "assets/audio/sounds/home/alarm clock beep.wav"),
    Answer("Wind Chimes", "assets/audio/sounds/home/wind chimes.wav")),
  AnswerGroup(
    Answer("Microwave", "assets/audio/sounds/home/microwave.wav"),
    Answer("Vacuum", "assets/audio/sounds/home/vacuum.wav"),
    Answer("Clock Ticking", "assets/audio/sounds/home/clock ticking.wav"),
    Answer("Pencil Writing", "assets/audio/sounds/home/pencil writing.wav")),
  AnswerGroup(
    Answer("Cat Meow", "assets/audio/sounds/home/cat meow.wav"),
    Answer("Garbage Disposal", "assets/audio/sounds/home/garbage disposal.wav"),
    Answer("Washing Machine", "assets/audio/sounds/home/washing machine.wav"),
    Answer("Computer Keyboard Clicking", "assets/audio/sounds/home/computer keyboard clicking.wav")),
];

final List<AnswerGroup> chapter1module2SoundGroups = [
  AnswerGroup(
      Answer("TEST", "assets/audio/sounds/home/cat meow.wav"),
      Answer("Car Horn", "assets/audio/sounds/home/cat meow.wav"),
      Answer("mungy", "assets/audio/sounds/home/cat meow.wav"),
      Answer("oooohhh aaaa", "assets/audio/sounds/home/cat meow.wav")),
];

// Map of sound modules
final Map<String, List<AnswerGroup>> chapter1soundModules = {
  'Module 1': chapter1module1SoundGroups,
  'Module 2': chapter1module2SoundGroups,
  // Add more modules as needed
};