class ResumeEntry {
  const ResumeEntry({
    required this.titleFa,
    required this.titleEn,
    required this.organizationFa,
    required this.organizationEn,
    required this.periodFa,
    required this.periodEn,
    required this.bulletsFa,
    required this.bulletsEn,
    this.isSample = true,
  });

  final String titleFa;
  final String titleEn;
  final String organizationFa;
  final String organizationEn;
  final String periodFa;
  final String periodEn;
  final List<String> bulletsFa;
  final List<String> bulletsEn;
  final bool isSample;

  String title(bool isFa) => isFa ? titleFa : titleEn;
  String organization(bool isFa) => isFa ? organizationFa : organizationEn;
  String period(bool isFa) => isFa ? periodFa : periodEn;
  List<String> bullets(bool isFa) => isFa ? bulletsFa : bulletsEn;
}
