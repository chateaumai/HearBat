import '../models/sound_pair.dart';

final List<SoundGroup> module1SoundGroups = [
  SoundGroup(
      Sound("Bird Chirping", "sounds/bird_chirping.mp3"),
      Sound("Car Horn", "sounds/car_horn.mp3"),
      Sound("Rain Noise", "sounds/rain_noise.mp3"),
      Sound("Dog Barking", "sounds/dog_barking.mp3")),
  SoundGroup(
      Sound("Wind Blowing", "sounds/wind_blowing.mp3"),
      Sound("Traffic", "sounds/traffic.mp3"),
      Sound("Cat Meowing", "sounds/cat_meowing.mp3"),
      Sound("Door Knocking", "sounds/door_knocking.mp3")),
  SoundGroup(
      Sound("Alarm Ringing", "sounds/alarm_ringing.mp3"),
      Sound("Water Dropping", "sounds/water_dropping.mp3"),
      Sound("Footsteps", "sounds/footsteps.mp3"),
      Sound("Phone Ringing", "sounds/phone_ringing.mp3")),
  SoundGroup(
      Sound("Typing", "sounds/typing.mp3"),
      Sound("Bell Ringing", "sounds/bell_ringing.mp3"),
      Sound("Airplane Flying", "sounds/airplane_flying.mp3"),
      Sound("Bicycle Bell", "sounds/bicycle_bell.mp3")),
  SoundGroup(
      Sound("Clock Ticking", "sounds/clock_ticking.mp3"),
      Sound("Fire Crackling", "sounds/fire_crackling.mp3"),
      Sound("Heartbeat", "sounds/heartbeat.mp3"),
      Sound("Sneezing", "sounds/sneezing.mp3")),
  SoundGroup(
      Sound("Thunder", "sounds/thunder.mp3"),
      Sound("Toilet Flushing", "sounds/toilet_flushing.mp3"),
      Sound("Train Whistle", "sounds/train_whistle.mp3"),
      Sound("Vacuum Cleaner", "sounds/vacuum_cleaner.mp3")),
  SoundGroup(
      Sound("Children Playing", "sounds/children_playing.mp3"),
      Sound("Glass Breaking", "sounds/glass_breaking.mp3"),
      Sound("Leaves Rustling", "sounds/leaves_rustling.mp3"),
      Sound("Stream Flowing", "sounds/stream_flowing.mp3")),
  SoundGroup(
      Sound("Crowd Cheering", "sounds/crowd_cheering.mp3"),
      Sound("Dogs Howling", "sounds/dogs_howling.mp3"),
      Sound("Elevator Ding", "sounds/elevator_ding.mp3"),
      Sound("Police Siren", "sounds/police_siren.mp3")),
  SoundGroup(
      Sound("Basketball Dribbling", "sounds/basketball_dribbling.mp3"),
      Sound("Bee Buzzing", "sounds/bee_buzzing.mp3"),
      Sound("Birds Singing", "sounds/birds_singing.mp3"),
      Sound("Cash Register", "sounds/cash_register.mp3")),
  SoundGroup(
      Sound("Chainsaw", "sounds/chainsaw.mp3"),
      Sound("Church Bells", "sounds/church_bells.mp3"),
      Sound("Drum Roll", "sounds/drum_roll.mp3"),
      Sound("Frog Croaking", "sounds/frog_croaking.mp3")),
];

final List<SoundGroup> module2SoundGroups = [
  SoundGroup(
      Sound("Bird Chirping", "sounds/bird_chirping.mp3"),
      Sound("Car Horn", "sounds/car_horn.mp3"),
      Sound("Rain Noise", "sounds/rain_noise.mp3"),
      Sound("Dog Barking", "sounds/dog_barking.mp3")),
  SoundGroup(
      Sound("Wind Blowing", "sounds/wind_blowing.mp3"),
      Sound("Traffic", "sounds/traffic.mp3"),
      Sound("Cat Meowing", "sounds/cat_meowing.mp3"),
      Sound("Door Knocking", "sounds/door_knocking.mp3")),
  SoundGroup(
      Sound("Alarm Ringing", "sounds/alarm_ringing.mp3"),
      Sound("Water Dropping", "sounds/water_dropping.mp3"),
      Sound("Footsteps", "sounds/footsteps.mp3"),
      Sound("Phone Ringing", "sounds/phone_ringing.mp3")),
  SoundGroup(
      Sound("Typing", "sounds/typing.mp3"),
      Sound("Bell Ringing", "sounds/bell_ringing.mp3"),
      Sound("Airplane Flying", "sounds/airplane_flying.mp3"),
      Sound("Bicycle Bell", "sounds/bicycle_bell.mp3")),
  SoundGroup(
      Sound("Clock Ticking", "sounds/clock_ticking.mp3"),
      Sound("Fire Crackling", "sounds/fire_crackling.mp3"),
      Sound("Heartbeat", "sounds/heartbeat.mp3"),
      Sound("Sneezing", "sounds/sneezing.mp3")),
  SoundGroup(
      Sound("Thunder", "sounds/thunder.mp3"),
      Sound("Toilet Flushing", "sounds/toilet_flushing.mp3"),
      Sound("Train Whistle", "sounds/train_whistle.mp3"),
      Sound("Vacuum Cleaner", "sounds/vacuum_cleaner.mp3")),
  SoundGroup(
      Sound("Children Playing", "sounds/children_playing.mp3"),
      Sound("Glass Breaking", "sounds/glass_breaking.mp3"),
      Sound("Leaves Rustling", "sounds/leaves_rustling.mp3"),
      Sound("Stream Flowing", "sounds/stream_flowing.mp3")),
  SoundGroup(
      Sound("Crowd Cheering", "sounds/crowd_cheering.mp3"),
      Sound("Dogs Howling", "sounds/dogs_howling.mp3"),
      Sound("Elevator Ding", "sounds/elevator_ding.mp3"),
      Sound("Police Siren", "sounds/police_siren.mp3")),
  SoundGroup(
      Sound("Basketball Dribbling", "sounds/basketball_dribbling.mp3"),
      Sound("Bee Buzzing", "sounds/bee_buzzing.mp3"),
      Sound("Birds Singing", "sounds/birds_singing.mp3"),
      Sound("Cash Register", "sounds/cash_register.mp3")),
  SoundGroup(
      Sound("Chainsaw", "sounds/chainsaw.mp3"),
      Sound("Church Bells", "sounds/church_bells.mp3"),
      Sound("Drum Roll", "sounds/drum_roll.mp3"),
      Sound("Frog Croaking", "sounds/frog_croaking.mp3")),
];

// Map of sound modules
final Map<String, List<SoundGroup>> soundModules = {
  'Module1': module1SoundGroups,
  'Module2': module2SoundGroups,
  // Add more modules as needed
};
