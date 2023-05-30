import 'package:fade_folder_exe/common/style.dart';
import 'package:fade_folder_exe/screens/home.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_size/window_size.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowTitle(appTitle);
  setWindowMinSize(const Size(windowWidth, windowHeight));
  setWindowMaxSize(const Size(windowWidth, windowHeight));
  getCurrentScreen().then((screen) {
    setWindowFrame(Rect.fromCenter(
      center: screen!.frame.center,
      width: windowWidth,
      height: windowHeight,
    ));
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const FluentApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: HomeScreen(),
    );
  }
}
