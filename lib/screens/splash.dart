import 'package:fade_folder_exe/common/folder_controller.dart';
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
    //データべ―スチェック
    await folderService.select();
    await Future.delayed(const Duration(seconds: 2));
    await _startUpCheck();
  }

  Future _startUpCheck() async {
    //最終起動日から何日たったかチェック
    DateTime lastTime = DateTime.now();
    int? timestamp = await getPrefsInt('lastTime');
    if (timestamp != null) {
      lastTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    DateTime now = DateTime.now();
    Duration diff = now.difference(lastTime);
    int diffDays = diff.inDays;
    bool autoDelete = await getPrefsBool('autoDelete') ?? false;
    int autoDeleteNum = await getPrefsInt('autoDeleteNum') ?? 0;
    String lockPassword = await getPrefsString('lockPassword') ?? '';
    if (autoDelete == true && diffDays != 0 && diffDays > autoDeleteNum) {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (context) => AutoDeleteDialog(
          folderService: folderService,
          fileService: fileService,
          days: diffDays,
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
    //パスワードロック
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
        '自動削除前の確認',
        style: kDialogTitleStyle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ソフトフェアを最後に起動してから${widget.days}日が経過しましたので、削除プログラムを起動します。',
            style: kErrorStyle,
          ),
          const SizedBox(height: 8),
          const Text(
            '最後に確認のため、パスワードを入力して認証してください。\nパスワードを間違えると全て削除され、パスワードが一致すると、削除されず以前と同じようにご利用いただけます。',
            style: kErrorStyle,
          ),
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
              //全削除
              await allRemovePrefs();
              await widget.folderService.truncate();
              await widget.fileService.truncate();
              await FolderController().allDelete();
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
