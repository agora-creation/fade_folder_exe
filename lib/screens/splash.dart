import 'package:fade_folder_exe/common/functions.dart';
import 'package:fade_folder_exe/common/style.dart';
import 'package:fade_folder_exe/screens/home.dart';
import 'package:fade_folder_exe/services/file.dart';
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
  FileService fileService = FileService();

  void _init() async {
    await folderService.select();
    await Future.delayed(const Duration(seconds: 2));
    await _startUpCheck();
  }

  Future _startUpCheck() async {
    DateTime lastTime = DateTime.now();
    int? timestamp = await getPrefsInt('lastTime');
    if (timestamp != null) {
      lastTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    DateTime now = DateTime.now();
    Duration diff = now.difference(lastTime);
    bool autoDelete = await getPrefsBool('autoDelete') ?? false;
    int autoDeleteNum = await getPrefsInt('autoDeleteNum') ?? 0;
    String lockPassword = await getPrefsString('lockPassword') ?? '';
    if (autoDelete == true && diff.inDays != 0 && diff.inDays > autoDeleteNum) {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (context) => AutoDeleteDialog(
          folderService: folderService,
          fileService: fileService,
          days: diff.inDays,
          lockPassword: lockPassword,
        ),
      ).then((value) async {
        await _lockCheck();
      });
      return;
    } else {
      await _lockCheck();
      return;
    }
  }

  Future _lockCheck() async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    await setPrefsInt('lastTime', timestamp);
    bool lock = await getPrefsBool('lock') ?? false;
    String lockPassword = await getPrefsString('lockPassword') ?? '';
    if (lock == true) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => PasswordDialog(lockPassword: lockPassword),
      );
    } else {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        FluentPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
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

class AutoDeleteDialog extends StatefulWidget {
  final FolderService folderService;
  final FileService fileService;
  final int days;
  final String lockPassword;

  const AutoDeleteDialog({
    required this.folderService,
    required this.fileService,
    required this.days,
    required this.lockPassword,
    super.key,
  });

  @override
  State<AutoDeleteDialog> createState() => _AutoDeleteDialogState();
}

class _AutoDeleteDialogState extends State<AutoDeleteDialog> {
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '削除前の通知',
        style: kDialogTitleStyle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('最終起動日から${widget.days}日が経過しましたので、ソフトウェア内のデータを全て削除します。'),
          const Text('最後に確認のため、ロック用パスワードを入力してください。間違えると、全て削除になります。'),
          const SizedBox(height: 8),
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
          backgroundColor: greyColor,
          onPressed: () async {
            if (widget.lockPassword != password.text) {
              await allRemovePrefs();
              await widget.folderService.truncate();
              await widget.fileService.truncate();
              await Future.delayed(const Duration(seconds: 2));
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                FluentPageRoute(
                  builder: (context) => const SplashScreen(),
                ),
              );
            } else {
              int timestamp = DateTime.now().millisecondsSinceEpoch;
              await setPrefsInt('lastTime', timestamp);
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                FluentPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            }
          },
        ),
      ],
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
        style: kDialogTitleStyle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          msg != null ? Text('$msg', style: kErrorStyle) : Container(),
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
            Navigator.pushReplacement(
              context,
              FluentPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
