String lorem = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';

String getPrompt(int wordsNeeded, String wordInput) {
  /* String prompt = 
    """
    Your task involves creating rehabilitation content modules for individuals with cochlear implants. The output format must strictly adhere to the provided structure. Ensure there is no deviation from this format, as consistency is key.

    Examples to demonstrate the required format:

    Input: Tin Tim
    Expected Output: 
    Teeth
    Grim

    Input: Patch
    Expected Output: 
    Latch
    Match
    Catch

    Input: Brag Stag Drag
    Expected Output: 
    Flag

    Now, for the provided input word(s), you are to generate exactly $wordsNeeded distinct words. Each word must be completely unique and not replicate the other generated words.

    1. Ensure each generated word is on a new line
    2. Each word in your output is distinct and does not repeat any of the other generated words.
    3. The words generated are audibly different (for example too and two is not allowed because it sounds the exact same)

    Inputted word(s) for context (Do not repeat these words, but generate $wordsNeeded distinct words):
    $wordInput

    Note: Strictly maintain the format with each word being on a new line, ensuring all $wordsNeeded words are unique and different from the input.
    """;

  return prompt;*/
  String prompt = 
  """
  Create exactly $wordsNeeded unique words for a cochlear implant rehabilitation module. Each word must be:

  1. Audibly distinct: Avoid homophones (e.g., 'too' and 'two' should not both appear).
  2. Not a repetition of any other generated word or the input words.
  3. Listed on a new line.

  Input Words: $wordInput

  Example:

  Input: Tin Tim
  Output: 
  Teeth
  Grim
  
  Input: Patch
  Expected Output: 
  Latch
  Poach
  Elapse

  Input: Brag Boat Drag
  Expected Output: 
  Float

  Your Output:
  """;

  return prompt;

}

String stripNonAlphaCharacters(String input) {
  // Regular expression pattern to match any non-alphabetic character and non-space character
  final RegExp nonAlphaNonSpacePattern = RegExp(r'[^a-zA-Z ]');

  // Replace all non-alphabetic and non-space characters with an empty string
  return input.replaceAll(nonAlphaNonSpacePattern, '');
}