import 'package:fade_folder_exe/common/functions.dart';
import 'package:fade_folder_exe/common/style.dart';
import 'package:fade_folder_exe/screens/home.dart';
import 'package:fade_folder_exe/services/folder.dart';
import 'package:fade_folder_exe/widgets/custom_button.dart';
import 'package:fade_folder_exe/widgets/custom_text_box.dart';
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
    bool lock = await getPrefsBool('lock') ?? false;
    String lockPassword = await getPrefsString('lockPassword') ?? '';
    if (lock == true) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => PasswordDialog(lockPassword: lockPassword),
      ).then((value) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          FluentPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      });
      return;
    }
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      FluentPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
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

class PasswordDialog extends StatefulWidget {
  final String lockPassword;

  const PasswordDialog({
    required this.lockPassword,
    super.key,
  });

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  TextEditingController password = TextEditingController();
  String? msg;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'パスワードでロックされています',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          msg != null
              ? Text(
                  '$msg',
                  style: const TextStyle(color: redColor),
                )
              : Container(),
          InfoLabel(
            label: 'パスワード',
            child: CustomTextBox(
              controller: password,
              maxLines: 1,
            ),
          ),
        ],
      ),
      actions: [
        CustomButton(
          labelText: '認証する',
          labelColor: whiteColor,
          backgroundColor: mainColor,
          onPressed: () async {
            if (widget.lockPassword != password.text) {
              setState(() {
                msg = 'パスワードが違います';
              });
              return;
            }
            int timestamp = DateTime.now().millisecondsSinceEpoch;
            await setPrefsInt('lastTime', timestamp);
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
