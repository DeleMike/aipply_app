class Metrics {
  final int cvGenerated;
  final int coverLetterGenerated;

  Metrics({required this.cvGenerated, required this.coverLetterGenerated});

  factory Metrics.fromJson(Map<String, dynamic> json) {
    return Metrics(
      cvGenerated: json['cv_generated'] ?? 0,
      coverLetterGenerated: json['cover_letter_generated'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Metrics(cvGenerated: $cvGenerated, coverLetterGenerated:$coverLetterGenerated)';
  }
}
