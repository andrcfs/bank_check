import 'package:bank_check/src/screens/home.dart';
import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/utils/constants.dart';
import 'package:bank_check/src/utils/methods.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<Result>>? savedData;
  Future<List<SavedFile>>? savedFiles;

  @override
  void initState() {
    super.initState();
    savedData = loadData();
    savedFiles = loadFilesList();
  }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    TextScaler appTextScaler =
        MediaQuery.of(context).textScaler.clamp(maxScaleFactor: 1.1);
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQueryData.fromView(View.of(context))
              .copyWith(textScaler: appTextScaler),
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Conciliação Bancária'),
              ),
              body: FutureBuilder<List<dynamic>>(
                future: Future.wait([savedData!, savedFiles!]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${snapshot.error}'),
                      ),
                    );
                    return const MyHome(
                      results: [],
                      savedFiles: [],
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return MyHome(results: data[0], savedFiles: data[1]);
                  } else {
                    return const MyHome(
                      results: [],
                      savedFiles: [],
                    );
                  }
                },
              ),
            ),
            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            restorationScopeId: 'app',

            // Provide the generated AppLocalizations to the MaterialApp. This
            // allows descendant Widgets to display the correct translations
            // depending on the user's locale.
            /* localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('pt', ''),
              Locale('pt', 'BR'),
              Locale('es', ''),
            ], */

            // Use AppLocalizations to configure the correct application title
            // depending on the user's locale.
            //
            // The appTitle is defined in .arb files found in the localization
            // directory.
            /*  onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle, */

            // Define a light and dark color theme. Then, read the user's
            // preferred ThemeMode (light, dark, or system default) from the
            // SettingsController to display the correct theme.
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: bgColor,
              textTheme:
                  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
                      .apply(bodyColor: Colors.white),
              canvasColor: secondaryColor,
            ),
            themeMode: widget.settingsController.themeMode,

            // Define a function to handle named routes in order to support
            // Flutter web url navigation and deep linking.
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case SettingsView.routeName:
                      return SettingsView(
                          controller: widget.settingsController);
                    case SampleItemDetailsView.routeName:
                      return const SampleItemDetailsView();
                    case SampleItemListView.routeName:
                    default:
                      return const SampleItemListView();
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
