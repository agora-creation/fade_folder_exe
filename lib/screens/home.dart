import 'package:fade_folder_exe/common/style.dart';
import 'package:fluent_ui/fluent_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: const Text(appTitle),
        actions: Container(),
      ),
      pane: NavigationPane(
        selected: selectedIndex,
        onChanged: (index) {
          setState(() => selectedIndex = index);
        },
        header: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            '入れ物一覧',
            style: TextStyle(fontSize: 12),
          ),
        ),
        items: [],
      ),
    );
  }
}
