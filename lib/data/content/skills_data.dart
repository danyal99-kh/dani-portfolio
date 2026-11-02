import 'package:flutter/material.dart';

import '../models/skill.dart';

const List<Skill> skills = [
  Skill(
    name: 'Python',
    category: SkillCategory.backend,
    icon: Icons.terminal_rounded,
    noteFa: 'زبان اصلی بک‌اند',
    noteEn: 'Primary backend language',
  ),
  Skill(
    name: 'Django',
    category: SkillCategory.backend,
    icon: Icons.layers_rounded,
    noteFa: 'فریم‌ورک وب',
    noteEn: 'Web framework',
  ),
  Skill(
    name: 'Django REST Framework',
    category: SkillCategory.backend,
    icon: Icons.api_rounded,
    noteFa: 'ساخت API',
    noteEn: 'API development',
  ),
  Skill(
    name: 'Celery',
    category: SkillCategory.backend,
    icon: Icons.schedule_rounded,
    noteFa: 'کارهای پس‌زمینه',
    noteEn: 'Background tasks',
  ),
  Skill(
    name: 'Redis',
    category: SkillCategory.backend,
    icon: Icons.bolt_rounded,
    noteFa: 'کش و صف',
    noteEn: 'Cache and queues',
  ),
  Skill(
    name: 'Flutter',
    category: SkillCategory.mobile,
    icon: Icons.phone_iphone_rounded,
    noteFa: 'اپلیکیشن چندسکویی',
    noteEn: 'Cross-platform apps',
  ),
  Skill(
    name: 'Dart',
    category: SkillCategory.mobile,
    icon: Icons.code_rounded,
    noteFa: 'زبان اپلیکیشن',
    noteEn: 'Application language',
  ),
  Skill(
    name: 'State management',
    category: SkillCategory.mobile,
    icon: Icons.account_tree_rounded,
    noteFa: 'مدیریت وضعیت',
    noteEn: 'App state patterns',
  ),
  Skill(
    name: 'REST integration',
    category: SkillCategory.mobile,
    icon: Icons.cloud_sync_rounded,
    noteFa: 'اتصال به API',
    noteEn: 'Connecting to APIs',
  ),
  Skill(
    name: 'PostgreSQL',
    category: SkillCategory.database,
    icon: Icons.storage_rounded,
    noteFa: 'پایگاه داده رابطه‌ای',
    noteEn: 'Relational database',
  ),
  Skill(
    name: 'MySQL',
    category: SkillCategory.database,
    icon: Icons.dns_rounded,
    noteFa: 'پایگاه داده رابطه‌ای',
    noteEn: 'Relational database',
  ),
  Skill(
    name: 'Data modeling',
    category: SkillCategory.database,
    icon: Icons.schema_rounded,
    noteFa: 'طراحی مدل داده',
    noteEn: 'Schema design',
  ),
  Skill(
    name: 'SQL',
    category: SkillCategory.database,
    icon: Icons.table_chart_rounded,
    noteFa: 'کوئری‌نویسی',
    noteEn: 'Query writing',
  ),
  Skill(
    name: 'Git',
    category: SkillCategory.tools,
    icon: Icons.commit_rounded,
    noteFa: 'کنترل نسخه',
    noteEn: 'Version control',
  ),
  Skill(
    name: 'Linux',
    category: SkillCategory.tools,
    icon: Icons.computer_rounded,
    noteFa: 'محیط توسعه',
    noteEn: 'Development environment',
  ),
  Skill(
    name: 'Docker',
    category: SkillCategory.tools,
    icon: Icons.view_in_ar_rounded,
    noteFa: 'کانتینرسازی',
    noteEn: 'Containerization',
  ),
  Skill(
    name: 'API testing',
    category: SkillCategory.tools,
    icon: Icons.science_outlined,
    noteFa: 'تست و مستندسازی',
    noteEn: 'Testing and docs',
  ),
];

const List<String> learningTopicsFa = [
  'معماری پروژه‌های بزرگ Flutter',
  'تست‌نویسی و CI',
  'الگوهای طراحی API',
  'بهینه‌سازی کوئری‌های پایگاه داده',
];

const List<String> learningTopicsEn = [
  'Large-scale Flutter architecture',
  'Testing and CI',
  'API design patterns',
  'Database query optimisation',
];
