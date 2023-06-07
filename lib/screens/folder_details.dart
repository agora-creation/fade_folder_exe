import 'package:fade_folder_exe/common/style.dart';
import 'package:fade_folder_exe/models/folder.dart';
import 'package:fade_folder_exe/widgets/custom_icon_button.dart';
import 'package:fluent_ui/fluent_ui.dart';

class FolderDetailsScreen extends StatefulWidget {
  final FolderModel folder;
  final Function() init;

  const FolderDetailsScreen({
    required this.folder,
    required this.init,
    super.key,
  });

  @override
  State<FolderDetailsScreen> createState() => _FolderDetailsScreenState();
}

class _FolderDetailsScreenState extends State<FolderDetailsScreen> {
  final List<String> texts = [
    'box1',
    'box2',
    'box3',
    'box4',
    'box5',
    'box6',
    'box7',
    'box8',
    'box9',
    'box10',
    'box11',
    'box12',
    'box13',
    'box14',
    'box15',
    'box16',
    'box17',
    'box18',
    'box19',
    'box20',
    'box21',
    'box22',
    'box23',
    'box24',
    'box25',
    'box26',
    'box27',
    'box28',
    'box29',
    'box30',
    'box31',
    'box32',
    'box33',
    'box34',
    'box35',
    'box36',
    'box37',
    'box38',
    'box39',
    'box40',
    'box41',
    'box42',
    'box43',
    'box44',
    'box45',
  ];

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
                  Text(
                    widget.folder.name,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Row(
                    children: [
                      CustomIconButton(
                        iconData: FluentIcons.edit,
                        iconColor: blackColor,
                        backgroundColor: blueColor,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 4),
                      CustomIconButton(
                        iconData: FluentIcons.delete,
                        iconColor: blackColor,
                        backgroundColor: redColor,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                itemCount: texts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  crossAxisCount: 10,
                ),
                //指定した要素の数分を生成
                itemBuilder: (context, index) {
                  return Container(
                    color: lightBlueColor,
                    child: Center(
                        child: Text(
                      texts[index],
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    )),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
