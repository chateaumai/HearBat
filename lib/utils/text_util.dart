String lorem = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';

String getPrompt(int wordsNeeded, String wordInput) {
  String prompt = 
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

    Now, for the provided input word(s), you are to generate exactly $wordsNeeded distinct words. Each word must be completely unique and not replicate the other generated words. Emphasize on audible distinction while maintaining a slight similarity in sound.

    Please ensure:
    1. Ensure each generated word is on a new line
    2. No repetition of the input word(s).
    3. Each word in your output is distinct and does not repeat any of the other generated words.

    Inputted word(s) for context (Do not repeat these words, but generate $wordsNeeded distinct words):
    $wordInput

    Note: Strictly maintain the format with each word being on a new line, ensuring all $wordsNeeded words are unique and different from the input.
    """;

  return prompt;
}