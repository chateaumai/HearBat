String lorem = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';

String getPrompt(int wordsNeeded, String wordInput) {
  String prompt = 
  """
  You will be assisting in creating rehabilitation content modules for people with cochlear implants. The user will listen to a word, and have 4 words presented
  in front of them (with one of those words being the one that was played) and then they have to guess what the word was.
  This will help them improve their hearing ability.

  The word(s) that you come up with must make sense in the context of the words given (for the purpose of improving their hearing).
  The format in which you should return will be the same as the format given. DO NOT DEVIATE FROM THIS.

  Here is an example of some inputs:

  input : {Tin}{Tim}
  output (you) : {Teeth}{Grim}

  input : {Patch}
  output (you) : {Latch}{Match}{Catch}

  input : {Brag}{Stag}{Drag}
  output (you) : {Flag}


  Generate $wordsNeeded words ONLY.
  Now, here are the input word(s),
  _______________________________
  $wordInput
  """;
  return prompt;
}