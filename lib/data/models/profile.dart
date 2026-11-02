class Profile {
  const Profile({
    required this.nameFa,
    required this.nameEn,
    required this.roleFa,
    required this.roleEn,
    required this.shortBioFa,
    required this.shortBioEn,
    required this.aboutBio1Fa,
    required this.aboutBio1En,
    required this.aboutBio2Fa,
    required this.aboutBio2En,
    required this.locationFa,
    required this.locationEn,
    required this.availabilityFa,
    required this.availabilityEn,
    required this.imageAsset,
    required this.resumeAsset,
  });

  final String nameFa;
  final String nameEn;
  final String roleFa;
  final String roleEn;
  final String shortBioFa;
  final String shortBioEn;
  final String aboutBio1Fa;
  final String aboutBio1En;
  final String aboutBio2Fa;
  final String aboutBio2En;
  final String locationFa;
  final String locationEn;
  final String availabilityFa;
  final String availabilityEn;
  final String imageAsset;
  final String resumeAsset;

  String name(bool isFa) => isFa ? nameFa : nameEn;
  String role(bool isFa) => isFa ? roleFa : roleEn;
  String shortBio(bool isFa) => isFa ? shortBioFa : shortBioEn;
  String aboutBio1(bool isFa) => isFa ? aboutBio1Fa : aboutBio1En;
  String aboutBio2(bool isFa) => isFa ? aboutBio2Fa : aboutBio2En;
  String location(bool isFa) => isFa ? locationFa : locationEn;
  String availability(bool isFa) => isFa ? availabilityFa : availabilityEn;

  String get firstNameEn => nameEn.split(' ').first;
}
