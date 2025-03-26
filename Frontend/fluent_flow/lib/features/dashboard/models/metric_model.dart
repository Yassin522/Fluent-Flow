class MetricModel {
  String title;
  String subtitle;
  double min;
  double max;
  MetricModel(
      {required this.subtitle,
      required this.title,
      required this.max,
      required this.min});
}

List<MetricModel> gesturesScoresMetrics = [
  MetricModel(
    title: "Gesture Use Score",
    subtitle:
        "A measure of how effectively the speaker uses gestures to complement and emphasize their speech\n-5 (the presenter isn't using any gestures) 0 (good use of gesture) 5 (the gestures are distracting/too much)",
    max: 5,
    min: -5,
  ),
  MetricModel(
    title: "Eye Gaze Score",
    subtitle:
        "A measure of how effectively the speaker uses eye contact to connect with the audience\n0 (the presenter isn't engaging with the audience (ex: looking away or down) 5 (the presenter is engaging in a good way)",
    max: 5,
    min: 0,
  ),
  MetricModel(
    title: "Head Gaze Score",
    subtitle:
        "A measure of how effectively the speaker's head movements align with their gaze and speech, contributing to communication effectiveness\n0 (the presenter isn't engaging with the audience (ex: looking away or down) 5 (the presenter is engaging in a good way)",
    max: 5,
    min: 0,
  ),
];

List<MetricModel> gesturesAnalyticsMetrics = [
  MetricModel(
    title: "Gesture Place",
    subtitle: "The percentage of time your gestures where near your face. When presenting you should aren’t far away from your face so the person watching you don't get distracted",
    max: 100,
    min: 0,
  ),
  MetricModel(
    title: "Gesture Close",
    subtitle: "The percentage of time the speaker’s gestures are appropriately close to the body, typically indicating controlled and intentional movement",
    max: 100,
    min: 0,
  ),
  MetricModel(
    title: "Good Poses",
    subtitle: "The percentage of time the speaker maintains a good posture or stance, which can convey confidence and professionalism",
    max: 100,
    min: 0,
  ),
  MetricModel(
    title: "Bad Poses (Hands On Hips)",
    subtitle: "The percentage of time the speaker's hands are on their hips, which can be perceived as aggressive or defensive",
    max: 100,
    min: 0,
  ),
  MetricModel(
    title: "Bad Poses (Hands Crossed)",
    subtitle: "The percentage of time the speaker's hands crossed, which can be perceived as aggressive or defensive",
    max: 100,
    min: 0,
  ),
  MetricModel(
    title: "Gaze Ratio",
    subtitle: "The percentage of time the speaker maintains proper eye contact, which is key for engaging the audience",
    max: 100,
    min: 0,
  ),
];

List<MetricModel> voiceScoresMetrics = [
  MetricModel(
    title: "Filler Words Score",
    subtitle: "A score that reflects the frequency of filler words like \"um,\" \"uh,\" or \"like,\" which can detract from the clarity of speech\n0 (the filler words aren't distracting) 5 (there are a lot of filler words and that they are distracting)",              
    max: 5,
    min: 0,
  ),
  MetricModel(
    title: "Speed/Pace Score",
    subtitle: "A measure of the pace at which the speaker talks, indicating whether the speech is too fast, too slow, or at an appropriate speed\n-5 (means too slow) 0 (perfect or optimal) 5 (means too fast)",                     
    max: 5,
    min: -5,
  ),
  MetricModel(
    title: "Speed Variation Score",
    subtitle: "A measure of how much the speaking speed varies, with some variation typically being beneficial for engagement\n -5 (too monotonic) 0 (optimal or perfect) 5 (too varying)",
    max: 5,
    min: -5,
  ),
  MetricModel(
    title: "Pausing Score",
    subtitle: "A score that indicates the effectiveness of pauses during speech, which can enhance comprehension and emphasize key points\n-5 (the person isn't pausing at all) 0 (good / optimal) 5 (the person is pausing too much)",            
    max: 5,
    min: -5,
  ),
  MetricModel(
    title: "Vocal Variation pdq",
    subtitle: "dynamics of pitch changes in a speaker's voice throughout their speech. It reflects the energy and expressiveness a speaker brings to their presentation, contributing to the overall engagement and liveliness of their delivery.\nA well-modulated vocal variation can enhance the listener's experience by making the speech more interesting and emotionally resonant\n-5 (no variation at all) 0 (perfect or optimal) 5 (too much variation)",
    max: 5,
    min: -5,
  ),
];

List<MetricModel> scriptScoresMetrics = [
  MetricModel(
    title: "Script Total Score",
    subtitle: "A combined score representing the overall quality of the script, considering various factors like clarity, structure, and grammar\n0 (the script too bad) 10 (excellent script)",
    max: 10,
    min: 0,
  ),
  MetricModel(
    title: "Language Variation Score",
    subtitle: "the diversity and variety of vocabulary that used\n0 (poor language) 5 (too variate)",
    max: 5,
    min: 0,
  ),
];

List<MetricModel> scriptAnalyticsMetrics = [
  MetricModel(
    title: "Unique Words Count",
    subtitle: "The number of distinct words or phrases used in the script, indicating lexical variety",
    max: 1000,
    min: 0,
  ),
  MetricModel(
    title: "Words Count",
    subtitle: "The total number of words or tokens in the script, providing a measure of script length",
    max: 2000,
    min: 0,
  ),
  MetricModel(
    title: "Stop Word Count",
    subtitle: "The number of common words (like \"and,\" \"the,\" \"uh\") that usually carry less meaning and are often excluded from key analyses",
    max: 1000,
    min: 0,
  ),
  MetricModel(
    title: "Sentences Count",
    subtitle: "The total number of sentences in the script, indicating the script's structure and flow",
    max: 500,
    min: 0,
  ),
  MetricModel(
    title: "Grammar Mistakes Count",
    subtitle: "Number of grammatical mistakes in you speech",                     
    max: 1000,
    min: 0,
  ),
];