import 'answer_pair.dart';
final List<AnswerGroup> chapter1module1SoundGroups = [
  AnswerGroup(
    Answer("Door Close", "/audio/sounds/home/door close.wav"),
    Answer("Kettle Whistling", "audio/sounds/home/kettle whistling.wav"),
    Answer("Cat Meow", "audio/sounds/home/cat meow.wav"),
    Answer("Printer", "audio/sounds/home/printer.wav")),
  AnswerGroup(
    Answer("Toilet Flush", "audio/sounds/home/toilet flush.wav"),
    Answer("Wind Chimes", "audio/sounds/home/wind chimes.wav"),
    Answer("Telephone Ringing", "audio/sounds/home/telephone ringing.wav"),
    Answer("Vacuum", "audio/sounds/home/vacuum.wav")),
  AnswerGroup(
    Answer("Dog Bark", "audio/sounds/home/dog bark.wav"),
    Answer("Microwave", "audio/sounds/home/microwave.wav"),
    Answer("Pencil Writing", "audio/sounds/home/pencil writing.wav"),
    Answer("Clock Ticking", "audio/sounds/home/clock ticking.wav")),
  AnswerGroup(
    Answer("Alarm Clock Beep", "audio/sounds/home/alarm clock beep.wav"),
    Answer("Garbage Disposal", "audio/sounds/home/garbage disposal.wav"),
    Answer("Doorbell", "audio/sounds/home/doorbell.wav"),
    Answer("Washing Machine", "audio/sounds/home/washing machine.wav")),
  AnswerGroup(
    Answer("Computer Keyboard Clicking", "audio/sounds/home/computer keyboard clicking.wav"),
    Answer("Shower Curtains", "audio/sounds/home/shower curtains.mp3"),
    Answer("Knife Sharpen", "audio/sounds/home/knife sharpen.wav"),
    Answer("Ice Dispenser", "audio/sounds/home/ice dispenser.wav")),
  AnswerGroup(
    Answer("Electric Shaver", "audio/sounds/home/electric shaver.wav"),
    Answer("Cutting Paper", "audio/sounds/home/cutting paper.wav"),
    Answer("Book Page Flipping", "audio/sounds/home/book page flipping.wav"),
    Answer("Mouse Click", "audio/sounds/home/mouse click.wav")),
  AnswerGroup(
    Answer("Toothbrush Brushing", "audio/sounds/home/toothbrush brushing.wav"),
    Answer("Telephone Ringing", "audio/sounds/home/telephone ringing.wav"),
    Answer("Dog Bark", "audio/sounds/home/dog bark.wav"),
    Answer("Printer", "audio/sounds/home/printer.wav")),
  AnswerGroup(
    Answer("Door Close", "audio/sounds/home/door close.wav"),
    Answer("Kettle Whistling", "audio/sounds/home/kettle whistling.wav"),
    Answer("Alarm Clock Beep", "audio/sounds/home/alarm clock beep.wav"),
    Answer("Wind Chimes", "audio/sounds/home/wind chimes.wav")),
  AnswerGroup(
    Answer("Microwave", "audio/sounds/home/microwave.wav"),
    Answer("Vacuum", "audio/sounds/home/vacuum.wav"),
    Answer("Clock Ticking", "audio/sounds/home/clock ticking.wav"),
    Answer("Pencil Writing", "audio/sounds/home/pencil writing.wav")),
  AnswerGroup(
    Answer("Cat Meow", "audio/sounds/home/cat meow.wav"),
    Answer("Garbage Disposal", "audio/sounds/home/garbage disposal.wav"),
    Answer("Washing Machine", "audio/sounds/home/washing machine.wav"),
    Answer("Computer Keyboard Clicking", "audio/sounds/home/computer keyboard clicking.wav")),
];

final List<AnswerGroup> chapter1module2SoundGroups = [
  AnswerGroup(
      Answer("TEST", "audio/sounds/home/cat meow.wav"),
      Answer("Car Horn", "audio/sounds/home/cat meow.wav"),
      Answer("mungy", "audio/sounds/home/cat meow.wav"),
      Answer("oooohhh aaaa", "audio/sounds/home/cat meow.wav")),
];

// Map of sound modules
final Map<String, List<AnswerGroup>> chapter1soundModules = {
  'Module 1': chapter1module1SoundGroups,
  'Module 2': chapter1module2SoundGroups,
  // Add more modules as needed
};