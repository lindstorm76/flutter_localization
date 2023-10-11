import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'src/constants/index.dart';
import 'src/helper/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales:
          Language.values.map((language) => Locale(language.name)).toList(),
      // Local files
      path: 'assets/l10n',
      fallbackLocale: Locale(Language.en.name),
      // For files on the internet
      // path: '',
      // assetLoader: const HttpAssetLoader(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Flutter Localization',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Localization'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Locale? currentLocale;

  List<String> availableLanguages =
      Language.values.map((language) => language.name).toList();

  void initDeviceLocale(BuildContext context) {
    Locale deviceLocale = Locale(context.deviceLocale.toString().split("_")[0]);
    Locale? targetLocale;

    if (currentLocale != null && currentLocale == deviceLocale) return;

    if (context.supportedLocales.contains(deviceLocale)) {
      targetLocale = deviceLocale;
    } else {
      targetLocale = Locale(Language.en.name);
    }

    context.setLocale(targetLocale);
    setState(() {
      currentLocale = targetLocale;
    });
  }

  void toggleLanguage(BuildContext context, String? targetLanguage) {
    context.setLocale(Locale(targetLanguage!));
  }

  @override
  Widget build(BuildContext context) {
    initDeviceLocale(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(fontSize: 24),
        ),
        actions: [
          DropdownButton(
            onChanged: (String? value) => toggleLanguage(context, value),
            value: context.locale.toString(),
            items: availableLanguages
                .map(
                  (languageCode) => DropdownMenuItem(
                    value: languageCode,
                    child: Text(languageCode.toUpperCase()),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '${tr('hello')} Flutter!',
              style: GoogleFonts.poppins(
                fontSize: 36,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Center(
            child: Text(
              'greet'.tr(namedArgs: {'name': 'P'}),
              style: GoogleFonts.poppins(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
