import 'package:fade_folder_exe/common/functions.dart';
import 'package:fade_folder_exe/common/style.dart';
import 'package:fade_folder_exe/models/folder.dart';
import 'package:fade_folder_exe/screens/folder_details.dart';
import 'package:fade_folder_exe/services/folder.dart';
import 'package:fade_folder_exe/widgets/custom_button.dart';
import 'package:fade_folder_exe/widgets/custom_icon_button.dart';
import 'package:fade_folder_exe/widgets/custom_icon_text_button_small.dart';
import 'package:fade_folder_exe/widgets/custom_text_box.dart';
import 'package:fluent_ui/fluent_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FolderService folderService = FolderService();
  List<NavigationPaneItem> items = [];
  int? selectedIndex;

  Future _generateItems() async {
    items.clear();
    List<FolderModel> folders = await folderService.select();
    if (folders.isNotEmpty) {
      for (FolderModel folder in folders) {
        items.add(PaneItem(
          selectedTileColor: ButtonState.all(whiteColor),
          icon: const Icon(FluentIcons.folder),
          title: Text(folder.name),
          body: FolderDetailsScreen(
            folder: folder,
            init: _init,
          ),
        ));
      }
    } else {
      items.add(PaneItem(
        icon: const Icon(FluentIcons.folder),
        title: const Text('フォルダがありません'),
        body: Container(),
        enabled: false,
      ));
    }
  }

  void _added() async {
    await _generateItems();
    selectedIndex = items.length - 1;
    setState(() {});
  }

  void _init() async {
    await _generateItems();
    if (items.isNotEmpty) {
      selectedIndex = 0;
    } else {
      selectedIndex = null;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mainColor,
        title: const Text(appTitle, style: kAppBarTextStyle),
        actions: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Align(
            alignment: Alignment.centerRight,
            child: CustomIconButton(
              iconData: FluentIcons.info,
              iconColor: whiteColor,
              backgroundColor: mainColor,
              onPressed: () {},
            ),
          ),
        ),
      ),
      pane: NavigationPane(
        selected: selectedIndex,
        onChanged: (index) {
          setState(() => selectedIndex = index);
        },
        header: Padding(
          padding: const EdgeInsets.only(top: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'フォルダ一覧',
                style: TextStyle(fontSize: 14),
              ),
              CustomIconTextButtonSmall(
                iconData: FluentIcons.add,
                iconColor: whiteColor,
                labelText: 'フォルダ作成',
                labelColor: whiteColor,
                backgroundColor: blueColor,
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AddFolderDialog(added: _added),
                ),
              ),
            ],
          ),
        ),
        items: items,
        footerItems: [
          PaneItemSeparator(),
          PaneItem(
            selectedTileColor: ButtonState.all(whiteColor),
            icon: const Icon(FluentIcons.settings),
            title: const Text('設定'),
            body: Container(),
          ),
          PaneItemSeparator(),
          PaneItem(
            selectedTileColor: ButtonState.all(whiteColor),
            icon: const Icon(FluentIcons.text_document),
            title: const Text('使い方について'),
            body: Container(),
          ),
          PaneItemSeparator(),
        ],
      ),
    );
  }
}

class AddFolderDialog extends StatefulWidget {
  final Function() added;

  const AddFolderDialog({
    required this.added,
    super.key,
  });

  @override
  State<AddFolderDialog> createState() => _AddFolderDialogState();
}

class _AddFolderDialogState extends State<AddFolderDialog> {
  FolderService folderService = FolderService();
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'フォルダ作成',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: 'フォルダ名',
            child: CustomTextBox(
              controller: name,
              maxLines: 1,
            ),
          ),
        ],
      ),
      actions: [
        CustomButton(
          labelText: 'キャンセル',
          labelColor: whiteColor,
          backgroundColor: greyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          labelText: '作成する',
          labelColor: whiteColor,
          backgroundColor: blueColor,
          onPressed: () async {
            String? error = await folderService.insert(name: name.text);
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.added();
            if (!mounted) return;
            showMessage(context, 'フォルダを作成しました', true);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
