import 'package:fluent_ui/fluent_ui.dart';

const double windowWidth = 1920;
const double windowHeight = 1080;

const String appTitle = 'FadeFolder';

const mainColor = Color(0xFF3F51B5);
const whiteColor = Color(0xFFFFFFFF);
const blackColor = Color(0xFF333333);
const greyColor = Color(0xFF9E9E9E);
const grey2Color = Color(0xFFE0E0E0);
const redColor = Color(0xFFF44336);
const blueColor = Color(0xFF2196F3);

FluentThemeData themeData() {
  return FluentThemeData(
    fontFamily: 'SourceHanSansJP-Regular',
    activeColor: mainColor,
    scaffoldBackgroundColor: const Color(0xFFEFEBE9),
  );
}
