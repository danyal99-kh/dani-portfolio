enum ProjectStatus { inProgress, completed, prototype, concept }

extension ProjectStatusX on ProjectStatus {
  String get translationKey => switch (this) {
    ProjectStatus.inProgress => 'status.inProgress',
    ProjectStatus.completed => 'status.completed',
    ProjectStatus.prototype => 'status.prototype',
    ProjectStatus.concept => 'status.concept',
  };
}

class CaseStudyHighlight {
  const CaseStudyHighlight({
    required this.titleFa,
    required this.titleEn,
    required this.descriptionFa,
    required this.descriptionEn,
  });

  final String titleFa;
  final String titleEn;
  final String descriptionFa;
  final String descriptionEn;

  String title(bool isFa) => isFa ? titleFa : titleEn;
  String description(bool isFa) => isFa ? descriptionFa : descriptionEn;
}

class CaseStudy {
  const CaseStudy({
    required this.introFa,
    required this.introEn,
    required this.problemFa,
    required this.problemEn,
    required this.solutionFa,
    required this.solutionEn,
    required this.architectureFa,
    required this.architectureEn,
    required this.challengesFa,
    required this.challengesEn,
    required this.highlights,
    required this.gallery,
  });

  final String introFa;
  final String introEn;
  final String problemFa;
  final String problemEn;
  final String solutionFa;
  final String solutionEn;
  final String architectureFa;
  final String architectureEn;
  final String challengesFa;
  final String challengesEn;
  final List<CaseStudyHighlight> highlights;
  final List<String> gallery;

  String intro(bool isFa) => isFa ? introFa : introEn;
  String problem(bool isFa) => isFa ? problemFa : problemEn;
  String solution(bool isFa) => isFa ? solutionFa : solutionEn;
  String architecture(bool isFa) => isFa ? architectureFa : architectureEn;
  String challenges(bool isFa) => isFa ? challengesFa : challengesEn;
}

class Project {
  const Project({
    required this.id,
    required this.name,
    required this.categoryFa,
    required this.categoryEn,
    required this.summaryFa,
    required this.summaryEn,
    required this.descriptionFa,
    required this.descriptionEn,
    required this.tech,
    required this.status,
    required this.imageAsset,
    required this.featured,
    required this.roleFa,
    required this.roleEn,
    required this.timelineFa,
    required this.timelineEn,
    required this.caseStudy,
    this.repoUrl,
    this.demoUrl,
  });

  final String id;
  final String name;
  final String categoryFa;
  final String categoryEn;
  final String summaryFa;
  final String summaryEn;
  final String descriptionFa;
  final String descriptionEn;
  final List<String> tech;
  final ProjectStatus status;
  final String imageAsset;
  final bool featured;
  final String roleFa;
  final String roleEn;
  final String timelineFa;
  final String timelineEn;
  final CaseStudy caseStudy;
  final String? repoUrl;
  final String? demoUrl;

  String category(bool isFa) => isFa ? categoryFa : categoryEn;
  String summary(bool isFa) => isFa ? summaryFa : summaryEn;
  String description(bool isFa) => isFa ? descriptionFa : descriptionEn;
  String role(bool isFa) => isFa ? roleFa : roleEn;
  String timeline(bool isFa) => isFa ? timelineFa : timelineEn;

  bool get hasRepo => repoUrl != null && repoUrl!.trim().isNotEmpty;
  bool get hasDemo => demoUrl != null && demoUrl!.trim().isNotEmpty;

  bool get repoIsPlaceholder =>
      hasRepo &&
      (repoUrl!.contains('YOUR_') || repoUrl!.contains('example.com'));

  bool get demoIsPlaceholder =>
      hasDemo &&
      (demoUrl!.contains('YOUR_') || demoUrl!.contains('example.com'));

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) ||
        summaryFa.toLowerCase().contains(q) ||
        summaryEn.toLowerCase().contains(q) ||
        descriptionFa.toLowerCase().contains(q) ||
        descriptionEn.toLowerCase().contains(q) ||
        tech.any((item) => item.toLowerCase().contains(q));
  }
}
