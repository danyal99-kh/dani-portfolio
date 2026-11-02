import 'package:flutter/material.dart';

enum SkillCategory { backend, mobile, database, tools }

extension SkillCategoryX on SkillCategory {
  String get translationKey => switch (this) {
    SkillCategory.backend => 'skills.backend',
    SkillCategory.mobile => 'skills.mobile',
    SkillCategory.database => 'skills.database',
    SkillCategory.tools => 'skills.tools',
  };

  String get descriptionKey => switch (this) {
    SkillCategory.backend => 'skills.backendDesc',
    SkillCategory.mobile => 'skills.mobileDesc',
    SkillCategory.database => 'skills.databaseDesc',
    SkillCategory.tools => 'skills.toolsDesc',
  };
}

class Skill {
  const Skill({
    required this.name,
    required this.category,
    required this.icon,
    required this.noteFa,
    required this.noteEn,
  });

  final String name;
  final SkillCategory category;
  final IconData icon;
  final String noteFa;
  final String noteEn;

  String note(bool isFa) => isFa ? noteFa : noteEn;
}
