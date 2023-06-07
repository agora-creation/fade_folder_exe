import 'package:fluent_ui/fluent_ui.dart';

const double windowWidth = 1440;
const double windowHeight = 900;

const String appTitle = 'FadeFolder';

const mainColor = Color(0xFF3F51B5);
const whiteColor = Color(0xFFFFFFFF);
const blackColor = Color(0xFF333333);
const greyColor = Color(0xFF9E9E9E);
const grey2Color = Color(0xFFE0E0E0);
const redColor = Color(0xFFF44336);
const blueColor = Color(0xFF2196F3);
const lightBlueColor = Color(0xFF03A9F4);
const tealColor = Color(0xFF009688);
const greenColor = Color(0xFF4CAF50);

FluentThemeData themeData() {
  return FluentThemeData(
    fontFamily: 'SourceHanSansJP-Regular',
    activeColor: mainColor,
    cardColor: whiteColor,
    scaffoldBackgroundColor: const Color(0xFFE8EAF6),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    navigationPaneTheme: const NavigationPaneThemeData(
      backgroundColor: Color(0xFFE8EAF6),
    ),
  );
}

const TextStyle kAppBarTextStyle = TextStyle(
  color: whiteColor,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);