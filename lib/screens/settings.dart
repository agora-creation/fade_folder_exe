import 'package:fade_folder_exe/common/functions.dart';
import 'package:fade_folder_exe/common/style.dart';
import 'package:fade_folder_exe/widgets/custom_border_title.dart';
import 'package:fade_folder_exe/widgets/custom_button.dart';
import 'package:fade_folder_exe/widgets/custom_text_box.dart';
import 'package:fluent_ui/fluent_ui.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  bool lock = false;
  String lockPassword = '';
  int autoDelete = 0;

  void _init() async {
    bool tmpLock = await getPrefsBool('lock') ?? false;
    String tmpLockPassword = await getPrefsString('lockPassword') ?? '';
    int tmpAutoDelete = await getPrefsInt('autoDelete') ?? 0;
    if (mounted) {
      setState(() {
        lock = tmpLock;
        lockPassword = tmpLockPassword;
        autoDelete = tmpAutoDelete;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '設定',
                    style: TextStyle(fontSize: 18),
                  ),
                  CustomButton(
                    labelText: '設定内容を保存',
                    labelColor: whiteColor,
                    backgroundColor: blueColor,
                    onPressed: () async {
                      await setPrefsBool('lock', lock);
                      await setPrefsString('lockPassword', lockPassword);
                      await setPrefsInt('autoDelete', autoDelete);
                      setState(() {});
                      if (!mounted) return;
                      showMessage(context, '設定内容を保存しました', true);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const CustomBorderTitle('セキュリティロック設定'),
              const Text(
                'ソフトウェアの起動時、第三者が閲覧できてしまうことを防止するため、パスワードを設定することができます。',
              ),
              const SizedBox(height: 16),
              ToggleSwitch(
                checked: lock,
                onChanged: (value) {
                  setState(() {
                    lock = value;
                  });
                },
                content: Text(lock ? 'ロックする' : 'ロックしない'),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: 'パスワード',
                child: CustomTextBox(
                  controller: TextEditingController(text: lockPassword),
                  onChanged: (value) {
                    lockPassword = value;
                  },
                ),
              ),
              const SizedBox(height: 16),
              const CustomBorderTitle('自動削除設定'),
              const Text(
                'ソフトウェアの起動を一定期間確認できなかった場合、このソフトウェア内に入っているデータを全て削除します。削除するまでの期日を設定してください。',
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioButton(
                    checked: autoDelete == 0,
                    onChanged: (value) {
                      setState(() {
                        autoDelete = 0;
                      });
                    },
                    content: const Text('自動削除しない'),
                  ),
                  const SizedBox(height: 8),
                  RadioButton(
                    checked: autoDelete == 5,
                    onChanged: (value) {
                      setState(() {
                        autoDelete = 5;
                      });
                    },
                    content: const Text('閉じてから5日後に自動削除'),
                  ),
                  const SizedBox(height: 8),
                  RadioButton(
                    checked: autoDelete == 10,
                    onChanged: (value) {
                      setState(() {
                        autoDelete = 10;
                      });
                    },
                    content: const Text('閉じてから10日後に自動削除'),
                  ),
                  const SizedBox(height: 8),
                  RadioButton(
                    checked: autoDelete == 15,
                    onChanged: (value) {
                      setState(() {
                        autoDelete = 15;
                      });
                    },
                    content: const Text('閉じてから15日後に自動削除'),
                  ),
                  const SizedBox(height: 8),
                  RadioButton(
                    checked: autoDelete == 30,
                    onChanged: (value) {
                      setState(() {
                        autoDelete = 30;
                      });
                    },
                    content: const Text('閉じてから30日後に自動削除'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
