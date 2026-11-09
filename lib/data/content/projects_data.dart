import '../models/project.dart';

/// All portfolio projects are defined here. Every string is editable, and the
/// image paths point to files inside `assets/images/`.
const List<Project> projects = [
  Project(
    id: 'lawin',
    name: 'Lawin',
    categoryFa: 'اپلیکیشن فول‌استک',
    categoryEn: 'Full-Stack Application',
    summaryFa: 'سامانه مدیریت کافه با تمرکز بر سفارش‌ها، محصولات، میزها، موجودی و بخش‌هایی از امور مالی.',
    summaryEn: 'A cafe management system focused on orders, products, tables, inventory, and parts of accounting.',
    descriptionFa: 'Lawin یک پروژه فول‌استک است که رابط مدیریتی Flutter را به یک API ساخته‌شده با Django و Django REST Framework متصل می‌کند. تمرکز اصلی پروژه روی جریان سفارش، مدیریت منو و سازمان‌دهی اطلاعات عملیاتی کافه است.',
    descriptionEn: 'Lawin is a full-stack project that connects a Flutter admin interface to an API built with Django and Django REST Framework. The main focus is the ordering flow, menu management, and organising cafe operations data.',
    tech: [
      'Flutter',
      'Django',
      'Django REST Framework',
      'PostgreSQL',
      'REST API',
    ],
    status: ProjectStatus.inProgress,
    imageAsset: 'assets/images/lawin.jpg',
    featured: true,
    roleFa: 'توسعه فول‌استک — رابط Flutter و API',
    roleEn: 'Full-stack development — Flutter UI and API',
    timelineFa: 'در حال توسعه',
    timelineEn: 'In progress',
    repoUrl: 'https://github.com/danyal99-kh/Lawin.git',
    caseStudy: CaseStudy(
      introFa: 'Lawin تلاش می‌کند ابزارهای پراکنده‌ی مدیریت یک کافه را در یک رابط یکپارچه جمع کند. این مطالعه موردی محتوای نمونه است و جزئیات آن قابل ویرایش است.',
      introEn: 'Lawin aims to bring the scattered tools of running a cafe into one interface. This case study is sample content and can be edited.',
      problemFa: 'مدیریت سفارش‌ها، منو و موجودی در بسیاری از کافه‌های کوچک با فایل‌ها یا ابزارهای جدا انجام می‌شود. این کار پیگیری وضعیت و هماهنگی بین بخش‌ها را سخت می‌کند.',
      problemEn: 'Many small cafes manage orders, menus, and inventory with separate files or tools. This makes tracking status and coordinating between areas difficult.',
      solutionFa: 'یک API متمرکز با Django REST Framework طراحی شد تا داده‌های محصولات، دسته‌بندی‌ها و سفارش‌ها را در اختیار رابط Flutter قرار دهد. رابط مدیریتی برای جریان‌های اصلی و نمایش منوی مشتری در نظر گرفته شده است.',
      solutionEn: 'A central API with Django REST Framework was designed to expose products, categories, and orders to the Flutter interface. The admin UI covers core flows, with a customer menu view in mind.',
      architectureFa: 'رابط Flutter از طریق درخواست‌های REST با API صحبت می‌کند. Django مسئول منطق دامنه و اعتبارسنجی است و PostgreSQL داده‌های اصلی را نگه می‌دارد. مرزهای ماژول‌ها طوری انتخاب شده‌اند که افزودن بخش‌های جدید ساده‌تر باشد.',
      architectureEn: 'The Flutter interface talks to the API through REST requests. Django owns domain logic and validation, while PostgreSQL stores the primary data. Module boundaries are chosen to make adding new areas easier.',
      challengesFa: 'هماهنگی مدل‌های داده بین سفارش، محصول و موجودی، و طراحی رابطی که برای کاربران غیرفنی هم قابل فهم باشد از چالش‌های اصلی این مسیر بوده است.',
      challengesEn: 'Coordinating data models across orders, products, and inventory, and designing an interface that makes sense to non-technical users, have been the main challenges.',
      highlights: [
        CaseStudyHighlight(
          titleFa: 'مدیریت سفارش‌ها',
          titleEn: 'Order management',
          descriptionFa: 'پیگیری وضعیت سفارش و جریان آماده‌سازی.',
          descriptionEn: 'Tracking order status and preparation flow.',
        ),
        CaseStudyHighlight(
          titleFa: 'مدیریت محصولات',
          titleEn: 'Product management',
          descriptionFa: 'سازمان‌دهی محصولات و دسته‌بندی‌های منو.',
          descriptionEn: 'Organising products and menu categories.',
        ),
        CaseStudyHighlight(
          titleFa: 'موجودی و امور مالی',
          titleEn: 'Inventory and finance',
          descriptionFa: 'بخش‌هایی برای پیگیری موجودی و اطلاعات مالی.',
          descriptionEn: 'Sections for inventory and financial information.',
        ),
      ],
      gallery: ['assets/images/lawin.jpg'],
    ),
  ),
  Project(
    id: 'azmode',
    name: 'Azmode',
    categoryFa: 'اپلیکیشن موبایل / یکپارچه‌سازی بک‌اند',
    categoryEn: 'Mobile Application / Backend Integration',
    summaryFa: 'اپلیکیشن فروشگاهی با رابط Flutter و API برای نمایش محصولات و اتصال به سرویس‌ها.',
    summaryEn: 'An e-commerce app with a Flutter interface and an API for product data and service integration.',
    descriptionFa: 'Azmode یک نمونه اپلیکیشن فروشگاهی است که رابط Flutter را به یک API جنگو متصل می‌کند. بخش‌هایی مانند نمایش محصولات و مدیریت وضعیت برنامه پیاده‌سازی شده‌اند و احراز هویت توکنی به‌عنوان بخشی از مسیر توسعه در نظر گرفته شده است.',
    descriptionEn: 'Azmode is an e-commerce app sample that connects a Flutter interface to a Django API. Areas such as product display and app state management are implemented, with token-based authentication considered as part of the development path.',
    tech: [
      'Flutter',
      'Dart',
      'Django REST Framework',
      'JWT Authentication',
      'REST API',
    ],
    status: ProjectStatus.prototype,
    imageAsset: 'assets/images/azmode.jpg',
    featured: true,
    roleFa: 'توسعه اپلیکیشن و یکپارچه‌سازی API',
    roleEn: 'App development and API integration',
    timelineFa: 'نمونه اولیه',
    timelineEn: 'Prototype',
    repoUrl: 'https://github.com/danyal99-kh/Azmode.git',
    caseStudy: CaseStudy(
      introFa: 'Azmode برای تمرین ساخت یک تجربه فروشگاهی موبایل طراحی شده است؛ از دریافت داده محصول تا نمایش آن در رابط کاربری.',
      introEn: 'Azmode was designed to practise building a mobile shopping experience, from fetching product data to presenting it in the interface.',
      problemFa: 'یک اپلیکیشن فروشگاهی باید داده‌های محصولات را به‌روز نگه دارد و در عین حال تجربه‌ای سریع و قابل فهم ارائه دهد. مدیریت وضعیت و ارتباط پایدار با API بخش مهمی از مسئله است.',
      problemEn: 'A shopping app needs to keep product data current while offering a fast, understandable experience. State management and reliable API communication are an important part of the problem.',
      solutionFa: 'ساختار اپلیکیشن به لایه‌های رابط، مدل و سرویس تقسیم شد. درخواست‌های API در یک لایه جدا قرار گرفتند تا تغییر منبع داده یا افزودن قابلیت‌های بعدی ساده‌تر شود.',
      solutionEn: 'The app structure was split into interface, model, and service layers. API requests live in a separate layer so changing the data source or adding features later is easier.',
      architectureFa: 'Flutter رابط را می‌سازد و از طریق REST با API جنگو ارتباط می‌گیرد. مدیریت وضعیت، داده‌های نمایشی را هماهنگ می‌کند و لایه سرویس مسئول درخواست‌ها و تبدیل پاسخ‌ها است.',
      architectureEn: 'Flutter renders the interface and communicates with the Django API over REST. State management coordinates view data, and the service layer owns requests and response mapping.',
      challengesFa: 'مدیریت حالت‌های بارگذاری و خطا، و طراحی جریانی که در شبکه‌های کند هم قابل استفاده باشد از نکات تمرینی این پروژه بوده است. بخش احراز هویت توکنی به‌عنوان ادامه مسیر در نظر گرفته شده و نباید آن را کاملاً تکمیل‌شده فرض کرد.',
      challengesEn: 'Handling loading and error states, and designing a flow that remains usable on slow networks, have been practice points in this project. Token authentication is planned as a next step and should not be assumed fully complete.',
      highlights: [
        CaseStudyHighlight(
          titleFa: 'نمایش محصولات',
          titleEn: 'Product display',
          descriptionFa: 'نمایش داده محصولات دریافتی از API.',
          descriptionEn: 'Presenting product data received from the API.',
        ),
        CaseStudyHighlight(
          titleFa: 'مدیریت وضعیت',
          titleEn: 'State management',
          descriptionFa: 'هماهنگی وضعیت رابط با داده‌های سرویس.',
          descriptionEn: 'Keeping interface state in sync with service data.',
        ),
        CaseStudyHighlight(
          titleFa: 'مسیر احراز هویت',
          titleEn: 'Authentication path',
          descriptionFa: 'برنامه‌ریزی برای احراز هویت توکنی در ادامه توسعه.',
          descriptionEn:
              'Planning token authentication for further development.',
        ),
      ],
      gallery: ['assets/images/azmode.jpg'],
    ),
  ),
  Project(
    id: 'chatbot',
    name: 'Flutter Chatbot',
    categoryFa: 'اپلیکیشن موبایل',
    categoryEn: 'Mobile Application',
    summaryFa: 'رابط مکالمه‌ای با Flutter برای تعامل با یک سرویس چت و تمرین مدیریت وضعیت.',
    summaryEn: 'A conversational Flutter interface for interacting with a chat service and practising state management.',
    descriptionFa: 'این پروژه یک نمونه اولیه برای ساخت رابط چت است. تمرکز آن روی تجربه کاربری مکالمه، نمایش وضعیت ارسال و دریافت، و اتصال به یک سرویس چت از طریق API است.',
    descriptionEn: 'This project is a prototype for building a chat interface. It focuses on the conversation experience, showing send and receive states, and connecting to a chat service through an API.',
    tech: ['Flutter', 'Dart', 'API Integration'],
    status: ProjectStatus.prototype,
    imageAsset: 'assets/images/chatbot.jpg',
    featured: false,
    roleFa: 'توسعه رابط و یکپارچه‌سازی API',
    roleEn: 'Interface development and API integration',
    timelineFa: 'نمونه اولیه',
    timelineEn: 'Prototype',
    repoUrl: 'https://github.com/danyal99-kh/WisQu.git',
    caseStudy: CaseStudy(
      introFa: 'این پروژه برای تمرین ساخت یک رابط مکالمه‌ای ساده و قابل توسعه ساخته شده است.',
      introEn: 'This project was built to practise creating a simple, extensible conversational interface.',
      problemFa: 'نمایش روان پیام‌ها، وضعیت ارسال و خطا، و حفظ تجربه کاربری در صفحه‌های کوچک نیازمند ساختار وضعیت مشخصی است.',
      problemEn: 'Smoothly presenting messages, send status, and errors while keeping the experience usable on small screens requires a clear state structure.',
      solutionFa: 'رابط به بخش‌های پیام‌ها، ورودی و وضعیت اتصال تقسیم شد. سرویس چت در یک لایه جدا قرار گرفت تا تعویض آن بدون تغییر کل رابط ممکن باشد.',
      solutionEn: 'The interface was split into messages, input, and connection status areas. The chat service sits in a separate layer so it can be replaced without rewriting the whole interface.',
      architectureFa: 'Flutter رابط را مدیریت می‌کند و درخواست‌ها از طریق یک سرویس API ارسال می‌شوند. وضعیت پیام‌ها در حافظه نگه داشته می‌شود و برای هر پیام، وضعیت ارسال نمایش داده می‌شود.',
      architectureEn: 'Flutter manages the interface and sends requests through an API service. Message state is held in memory, with a send status shown for each message.',
      challengesFa: 'مدیریت خطاهای شبکه، جلوگیری از ارسال تکراری و طراحی حالتی که کاربر بفهمد پیام در حال ارسال است از چالش‌های اصلی بوده‌اند.',
      challengesEn: 'Handling network errors, preventing duplicate sends, and making it clear when a message is being sent have been the main challenges.',
      highlights: [
        CaseStudyHighlight(
          titleFa: 'رابط مکالمه',
          titleEn: 'Conversation UI',
          descriptionFa: 'نمایش پیام‌ها با تمرکز بر خوانایی.',
          descriptionEn: 'Message display focused on readability.',
        ),
        CaseStudyHighlight(
          titleFa: 'وضعیت ارسال',
          titleEn: 'Send status',
          descriptionFa: 'نمایش مراحل ارسال و دریافت پیام.',
          descriptionEn: 'Showing message send and receive states.',
        ),
      ],
      gallery: ['assets/images/chatbot.jpg'],
    ),
  ),
  Project(
    id: 'language-learning',
    name: 'Language Learning',
    categoryFa: 'آموزشی / اپلیکیشن موبایل',
    categoryEn: 'Education / Mobile Application',
    summaryFa:
        'اپلیکیشن آموزشی برای یادگیری زبان با رابط موبایل و ساختار قابل توسعه.',
    summaryEn: 'An educational app for language learning with a mobile interface and an extensible structure.',
    descriptionFa: 'این پروژه یک نمونه تمرینی برای طراحی جریان یادگیری زبان است. ساختار آن برای افزودن درس‌ها، تمرین‌ها و مرور مطالب در نظر گرفته شده است.',
    descriptionEn: 'This project is a practice sample for designing a language learning flow. Its structure is intended to support adding lessons, exercises, and review material.',
    tech: ['Flutter', 'Dart'],
    status: ProjectStatus.concept,
    imageAsset: 'assets/images/language.jpg',
    featured: false,
    roleFa: 'طراحی و توسعه رابط',
    roleEn: 'Interface design and development',
    timelineFa: 'ایده / نمونه',
    timelineEn: 'Concept / sample',
    repoUrl: 'https://github.com/mehrdadfbx/linguaa.git',
    caseStudy: CaseStudy(
      introFa:
          'هدف این پروژه تمرین طراحی یک تجربه یادگیری ساده و قابل گسترش است.',
      introEn: 'The goal of this project is to practise designing a simple, extensible learning experience.',
      problemFa: 'یادگیری زبان به تمرین منظم و بازخورد واضح نیاز دارد. رابط باید کاربر را بدون شلوغی زیاد در مسیر درس نگه دارد.',
      problemEn: 'Language learning needs regular practice and clear feedback. The interface should keep the learner on track without unnecessary clutter.',
      solutionFa: 'یک ساختار مبتنی بر درس و تمرین در نظر گرفته شد که می‌تواند بعداً با مرور فاصله‌دار و پیشرفت کاربر تکمیل شود.',
      solutionEn: 'A lesson-and-exercise structure was planned that can later be extended with spaced review and user progress.',
      architectureFa: 'داده‌های درس و تمرین در مدل‌های مستقل نگه داشته می‌شوند تا افزودن انواع جدید تمرین ساده باشد. رابط Flutter بر اساس این مدل‌ها ساخته می‌شود.',
      architectureEn: 'Lesson and exercise data live in separate models so new exercise types can be added easily. The Flutter interface is built from these models.',
      challengesFa: 'طراحی جریانی که هم برای مبتدی و هم برای کاربر پیشرفته قابل استفاده باشد، و نگه‌داشتن انگیزه بدون استفاده از آمار ساختگی از نکات فکری این پروژه است.',
      challengesEn: 'Designing a flow usable by both beginners and advanced learners, and keeping motivation without fabricated statistics, are key considerations in this project.',
      highlights: [
        CaseStudyHighlight(
          titleFa: 'ساختار درس',
          titleEn: 'Lesson structure',
          descriptionFa: 'مدل قابل توسعه برای درس‌ها و تمرین‌ها.',
          descriptionEn: 'An extensible model for lessons and exercises.',
        ),
        CaseStudyHighlight(
          titleFa: 'رابط موبایل',
          titleEn: 'Mobile interface',
          descriptionFa: 'طراحی برای صفحه‌های کوچک و تعامل لمسی.',
          descriptionEn: 'Designed for small screens and touch interaction.',
        ),
      ],
      gallery: ['assets/images/language.jpg'],
    ),
  ),
  Project(
    id: 'personal-accounting',
    name: 'Personal Accounting',
    categoryFa: 'بهره‌وری / اپلیکیشن موبایل',
    categoryEn: 'Productivity / Mobile Application',
    summaryFa:
        'اپلیکیشن شخصی برای ثبت تراکنش‌ها و ارائه نمایی ساده از اطلاعات مالی.',
    summaryEn: 'A personal app for recording transactions and presenting a simple view of financial data.',
    descriptionFa: 'این پروژه برای تمرین مدیریت داده محلی و طراحی یک رابط ساده برای ثبت درآمد و هزینه ساخته شده است. تمرکز آن روی ورود سریع اطلاعات و خوانایی گزارش‌های پایه است.',
    descriptionEn: 'This project practises local data management and a simple interface for recording income and expenses. It focuses on fast data entry and readable basic reports.',
    tech: ['Flutter', 'Dart', 'Local Data Management'],
    status: ProjectStatus.prototype,
    imageAsset: 'assets/images/accounting.jpg',
    featured: false,
    roleFa: 'طراحی و توسعه اپلیکیشن',
    roleEn: 'App design and development',
    timelineFa: 'نمونه اولیه',
    timelineEn: 'Prototype',
    repoUrl: 'https://github.com/danyal99-kh/FiNiZER1.git',
    caseStudy: CaseStudy(
      introFa: 'این پروژه یک نمونه برای ثبت ساده تراکنش‌ها و مشاهده خلاصه اطلاعات مالی است.',
      introEn: 'This project is a sample for simple transaction entry and viewing a summary of financial data.',
      problemFa: 'ابزارهای مالی شخصی اگر ورود داده در آن‌ها سخت باشد، کنار گذاشته می‌شوند. رابط باید سریع، واضح و بدون اصطلاحات پیچیده باشد.',
      problemEn: 'Personal finance tools get abandoned when data entry is hard. The interface needs to be fast, clear, and free of complicated terminology.',
      solutionFa: 'جریان ورود تراکنش ساده نگه داشته شد و داده‌ها به‌صورت محلی ذخیره می‌شوند. یک نمای خلاصه برای مرور سریع در نظر گرفته شده است.',
      solutionEn: 'The transaction entry flow was kept simple and data is stored locally. A summary view was designed for quick review.',
      architectureFa: 'Flutter رابط را می‌سازد و لایه ذخیره‌سازی محلی مسئول نگه‌داری تراکنش‌هاست. مدل‌ها از رابط جدا هستند تا تغییر روش ذخیره‌سازی ساده باشد.',
      architectureEn: 'Flutter builds the interface and a local storage layer owns transactions. Models are separated from the UI so the storage method can change easily.',
      challengesFa: 'مدیریت اعتبارسنجی ورودی، نمایش مبلغ‌ها و طراحی خلاصه‌ای که بدون پیچیدگی بیش از حد مفید باشد از چالش‌های این نمونه است.',
      challengesEn: 'Handling input validation, formatting amounts, and designing a summary that is useful without being overly complex are challenges in this sample.',
      highlights: [
        CaseStudyHighlight(
          titleFa: 'ثبت تراکنش',
          titleEn: 'Transaction entry',
          descriptionFa: 'ورود سریع درآمد و هزینه.',
          descriptionEn: 'Fast income and expense entry.',
        ),
        CaseStudyHighlight(
          titleFa: 'داده محلی',
          titleEn: 'Local data',
          descriptionFa: 'نگه‌داری اطلاعات روی دستگاه.',
          descriptionEn: 'Storing information on the device.',
        ),
      ],
      gallery: ['assets/images/accounting.jpg'],
    ),
  ),
];

Project? projectById(String id) {
  for (final project in projects) {
    if (project.id == id) return project;
  }
  return null;
}

List<Project> get featuredProjects =>
    projects.where((project) => project.featured).toList();

List<String> get allTechnologies {
  final values = <String>{};
  for (final project in projects) {
    values.addAll(project.tech);
  }
  final list = values.toList()..sort();
  return list;
}
