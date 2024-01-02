import 'answer_pair.dart';

final List<AnswerGroup> chapter1module1WordGroups = [
  AnswerGroup(
      Answer("Bird Chirping", "words/bird_chirping.mp3"),
      Answer("Car Horn", "words/car_horn.mp3"),
      Answer("Rain Noise", "words/rain_noise.mp3"),
      Answer("Dog Barking", "words/dog_barking.mp3")),
  AnswerGroup(
      Answer("Wind Blowing", "words/wind_blowing.mp3"),
      Answer("Traffic", "words/traffic.mp3"),
      Answer("Cat Meowing", "words/cat_meowing.mp3"),
      Answer("Door Knocking", "words/door_knocking.mp3")),
  AnswerGroup(
      Answer("Alarm Ringing", "words/alarm_ringing.mp3"),
      Answer("Water Dropping", "words/water_dropping.mp3"),
      Answer("Footsteps", "words/footsteps.mp3"),
      Answer("Phone Ringing", "words/phone_ringing.mp3")),
  AnswerGroup(
      Answer("Typing", "words/typing.mp3"),
      Answer("Bell Ringing", "words/bell_ringing.mp3"),
      Answer("Airplane Flying", "words/airplane_flying.mp3"),
      Answer("Bicycle Bell", "words/bicycle_bell.mp3")),
  AnswerGroup(
      Answer("Clock Ticking", "words/clock_ticking.mp3"),
      Answer("Fire Crackling", "words/fire_crackling.mp3"),
      Answer("Heartbeat", "words/heartbeat.mp3"),
      Answer("Sneezing", "words/sneezing.mp3")),
  AnswerGroup(
      Answer("Thunder", "words/thunder.mp3"),
      Answer("Toilet Flushing", "words/toilet_flushing.mp3"),
      Answer("Train Whistle", "words/train_whistle.mp3"),
      Answer("Vacuum Cleaner", "words/vacuum_cleaner.mp3")),
  AnswerGroup(
      Answer("Children Playing", "words/children_playing.mp3"),
      Answer("Glass Breaking", "words/glass_breaking.mp3"),
      Answer("Leaves Rustling", "words/leaves_rustling.mp3"),
      Answer("Stream Flowing", "words/stream_flowing.mp3")),
  AnswerGroup(
      Answer("Crowd Cheering", "words/crowd_cheering.mp3"),
      Answer("Dogs Howling", "words/dogs_howling.mp3"),
      Answer("Elevator Ding", "words/elevator_ding.mp3"),
      Answer("Police Siren", "words/police_siren.mp3")),
  AnswerGroup(
      Answer("Basketball Dribbling", "words/basketball_dribbling.mp3"),
      Answer("Bee Buzzing", "words/bee_buzzing.mp3"),
      Answer("Birds Singing", "words/birds_singing.mp3"),
      Answer("Cash Register", "words/cash_register.mp3")),
  AnswerGroup(
      Answer("Chainsaw", "words/chainsaw.mp3"),
      Answer("Church Bells", "words/church_bells.mp3"),
      Answer("Drum Roll", "words/drum_roll.mp3"),
      Answer("Frog Croaking", "words/frog_croaking.mp3")),
];

final List<AnswerGroup> chapter1module2WordGroups = [
  AnswerGroup(
      Answer("TEST", "words/bird_chirping.mp3"),
      Answer("Car Horn", "words/car_horn.mp3"),
      Answer("Rain Noise", "words/rain_noise.mp3"),
      Answer("Dog Barking", "words/dog_barking.mp3")),
];

final Map<String, List<AnswerGroup>> chapter1wordModules = {
  'Module1': chapter1module1WordGroups,
  'Module2': chapter1module2WordGroups,
  // Add more modules as needed
};

final Map<String, List<AnswerGroup>> chapter2wordModules = {
  'Module1': chapter1module1WordGroups,
  'Module2': chapter1module2WordGroups,
  // Add more modules as needed
};
