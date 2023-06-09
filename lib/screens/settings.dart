import 'package:fade_folder_exe/common/functions.dart';
import 'package:fade_folder_exe/common/style.dart';
import 'package:fade_folder_exe/widgets/custom_border_title.dart';
import 'package:fade_folder_exe/widgets/custom_button.dart';
import 'package:fade_folder_exe/widgets/custom_number_box.dart';
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
  bool autoDelete = false;
  int autoDeleteNum = 5;

  void _init() async {
    bool tmpLock = await getPrefsBool('lock') ?? false;
    String tmpLockPassword = await getPrefsString('lockPassword') ?? '';
    bool tmpAutoDelete = await getPrefsBool('autoDelete') ?? false;
    int tmpAutoDeleteNum = await getPrefsInt('autoDeleteNum') ?? 0;
    if (mounted) {
      setState(() {
        lock = tmpLock;
        lockPassword = tmpLockPassword;
        autoDelete = tmpAutoDelete;
        autoDeleteNum = tmpAutoDeleteNum;
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
                      await setPrefsBool('autoDelete', autoDelete);
                      await setPrefsInt('autoDeleteNum', autoDeleteNum);
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
              lock
                  ? InfoLabel(
                      label: 'パスワード',
                      child: CustomTextBox(
                        controller: TextEditingController(text: lockPassword),
                        onChanged: (value) {
                          lockPassword = value;
                        },
                      ),
                    )
                  : Container(),
              const SizedBox(height: 16),
              const CustomBorderTitle('自動削除設定'),
              const Text(
                'ソフトウェアの起動を一定期間確認できなかった場合、このソフトウェア内に入っているデータを全て削除します。削除するまでの期日を設定してください。',
              ),
              const SizedBox(height: 16),
              ToggleSwitch(
                checked: autoDelete,
                onChanged: (value) {
                  setState(() {
                    autoDelete = value;
                  });
                },
                content: Text(autoDelete ? '自動削除する' : '自動削除しない'),
              ),
              const SizedBox(height: 8),
              autoDelete
                  ? InfoLabel(
                      label: '閉じてから〇日後に自動削除',
                      child: CustomNumberBox(
                        value: autoDeleteNum,
                        onChanged: (value) {
                          autoDeleteNum = value ?? 0;
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
