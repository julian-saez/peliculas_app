import 'package:peliculas_app/models/menu_options.dart';
import 'package:peliculas_app/screens/screens.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const initialRoute = 'home';

  static final menuOptions = <MenuOption>[
    MenuOption(route: 'home', icon: Icons.home, name: 'Home', screen: const HomeScreen() ),
    MenuOption(route: 'details', icon: Icons.details, name: 'Details', screen: const DetailsScreen() ),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    for ( final option in menuOptions ) {
      appRoutes.addAll({ option.route: ( BuildContext context ) => option.screen });
    }

    return appRoutes;
  }

  static Route<dynamic> onGenerateRoute( RouteSettings settings ) {
    return MaterialPageRoute(builder: ( context ) => const NotFoundScreen());
  }
}