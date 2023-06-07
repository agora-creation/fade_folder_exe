import 'package:fade_folder_exe/screens/home.dart';
import 'package:fade_folder_exe/services/folder.dart';
import 'package:fluent_ui/fluent_ui.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FolderService folderService = FolderService();

  void _init() async {
    await folderService.select();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      FluentPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      content: Center(
        child: ProgressRing(),
      ),
    );
  }
}
