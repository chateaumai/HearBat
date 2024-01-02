import 'answer_pair.dart';

final List<AnswerGroup> chapter1module1SoundGroups = [
  AnswerGroup(
      Answer("Bird Chirping", "sounds/bird_chirping.mp3"),
      Answer("Car Horn", "sounds/car_horn.mp3"),
      Answer("Rain Noise", "sounds/rain_noise.mp3"),
      Answer("Dog Barking", "sounds/dog_barking.mp3")),
  AnswerGroup(
      Answer("Wind Blowing", "sounds/wind_blowing.mp3"),
      Answer("Traffic", "sounds/traffic.mp3"),
      Answer("Cat Meowing", "sounds/cat_meowing.mp3"),
      Answer("Door Knocking", "sounds/door_knocking.mp3")),
  AnswerGroup(
      Answer("Alarm Ringing", "sounds/alarm_ringing.mp3"),
      Answer("Water Dropping", "sounds/water_dropping.mp3"),
      Answer("Footsteps", "sounds/footsteps.mp3"),
      Answer("Phone Ringing", "sounds/phone_ringing.mp3")),
  AnswerGroup(
      Answer("Typing", "sounds/typing.mp3"),
      Answer("Bell Ringing", "sounds/bell_ringing.mp3"),
      Answer("Airplane Flying", "sounds/airplane_flying.mp3"),
      Answer("Bicycle Bell", "sounds/bicycle_bell.mp3")),
  AnswerGroup(
      Answer("Clock Ticking", "sounds/clock_ticking.mp3"),
      Answer("Fire Crackling", "sounds/fire_crackling.mp3"),
      Answer("Heartbeat", "sounds/heartbeat.mp3"),
      Answer("Sneezing", "sounds/sneezing.mp3")),
  AnswerGroup(
      Answer("Thunder", "sounds/thunder.mp3"),
      Answer("Toilet Flushing", "sounds/toilet_flushing.mp3"),
      Answer("Train Whistle", "sounds/train_whistle.mp3"),
      Answer("Vacuum Cleaner", "sounds/vacuum_cleaner.mp3")),
  AnswerGroup(
      Answer("Children Playing", "sounds/children_playing.mp3"),
      Answer("Glass Breaking", "sounds/glass_breaking.mp3"),
      Answer("Leaves Rustling", "sounds/leaves_rustling.mp3"),
      Answer("Stream Flowing", "sounds/stream_flowing.mp3")),
  AnswerGroup(
      Answer("Crowd Cheering", "sounds/crowd_cheering.mp3"),
      Answer("Dogs Howling", "sounds/dogs_howling.mp3"),
      Answer("Elevator Ding", "sounds/elevator_ding.mp3"),
      Answer("Police Siren", "sounds/police_siren.mp3")),
  AnswerGroup(
      Answer("Basketball Dribbling", "sounds/basketball_dribbling.mp3"),
      Answer("Bee Buzzing", "sounds/bee_buzzing.mp3"),
      Answer("Birds Singing", "sounds/birds_singing.mp3"),
      Answer("Cash Register", "sounds/cash_register.mp3")),
  AnswerGroup(
      Answer("Chainsaw", "sounds/chainsaw.mp3"),
      Answer("Church Bells", "sounds/church_bells.mp3"),
      Answer("Drum Roll", "sounds/drum_roll.mp3"),
      Answer("Frog Croaking", "sounds/frog_croaking.mp3")),
];

final List<AnswerGroup> chapter1module2SoundGroups = [
  AnswerGroup(
      Answer("TEST", "sounds/bird_chirping.mp3"),
      Answer("Car Horn", "sounds/car_horn.mp3"),
      Answer("Rain Noise", "sounds/rain_noise.mp3"),
      Answer("Dog Barking", "sounds/dog_barking.mp3")),
];

// Map of sound modules
final Map<String, List<AnswerGroup>> chapter1soundModules = {
  'Module1': chapter1module1SoundGroups,
  'Module2': chapter1module2SoundGroups,
  // Add more modules as needed
};
