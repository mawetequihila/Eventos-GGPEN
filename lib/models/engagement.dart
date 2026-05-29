class QaItem {
  final String author;
  final String initials;
  final String text;
  final int votes;
  final bool voted;
  final String time;

  const QaItem({
    required this.author,
    required this.initials,
    required this.text,
    required this.votes,
    required this.voted,
    required this.time,
  });
}

class PollOption {
  final String label;
  final int percent;
  const PollOption(this.label, this.percent);
}

class Poll {
  final String question;
  final int totalVotes;
  final String closesIn;
  final List<PollOption> options;

  const Poll({
    required this.question,
    required this.totalVotes,
    required this.closesIn,
    required this.options,
  });
}
