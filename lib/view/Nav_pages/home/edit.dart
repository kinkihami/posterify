// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:posterify/constants/constants.dart';
import 'package:posterify/service/web_service.dart';
import 'package:posterify/view%20model/common_view_model.dart';
import 'package:provider/provider.dart';
import 'package:text_editor/text_editor.dart';

// ignore: must_be_immutable
class ScreenEdit extends StatefulWidget {
  String image;
  ScreenEdit({super.key, required this.image});

  @override
  State<ScreenEdit> createState() => _ScreenEditState();
}

class _ScreenEditState extends State<ScreenEdit> {
  final GlobalKey _widgetKey = GlobalKey();
  List<XFile> imageList = [];
  List<Offset> position = [];
  double height = 200.00;
  bool editorText = false;
  LindiController controller = LindiController();
  bool isSaved = false;
  String? logo;
  bool? isDark;
  String text = '';

  List<String> details = [];
  CommonViewModel? vm;

  @override
  void initState() {
    vm = Provider.of<CommonViewModel>(context, listen: false);

    details.addAll([
      vm!.detailsList!.shop,
      
      vm!.detailsList!.phone,
      vm!.detailsList!.email
    ]);
    logo = vm!.detailsList!.logo;
    log('logo $logo');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<CommonViewModel>(builder: (context, value, child) {
      return value.detailsLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Stack(
                children: [
                  Scaffold(
                    appBar: AppBar(
                      elevation: 5,
                      backgroundColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      bottom: const PreferredSize(
                          preferredSize: Size.fromHeight(0),
                          child: Divider(
                            height: 0,
                          )),
                      centerTitle: true,
                      leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                          )),
                      title: Text(
                        'Edit',
                        style: headingBlackStyle,
                      ),
                      actions: [
                        IconButton(
                            onPressed: () async {
                              await _captureAndSave(context);
                            },
                            icon: const Icon(
                              Icons.save,
                            )),
                      ],
                    ),
                    bottomNavigationBar: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(
                          height: 0,
                        ),
                        SizedBox(
                          height: 60,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              logo!='' ? Row(
                                children: [
                                  GestureDetector(
                                     onTap: (){
                                        controller.addWidget(
                                          Image.network(
                                              '${WebService().baseurl}/logo/${logo!}',height: 40,),
                                        );
                                      },
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            '${WebService().baseurl}/logo/${logo!}'),
                                      )),
                                  const VerticalDivider(),
                                ],
                              ):const SizedBox(),
                              ...List.generate(
                                  details.length,
                                  (index) => Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                editorText = true;
                                                text = details[index];
                                              });
                                            },
                                            child: Text(
                                              details[index],
                                              style: const TextStyle(
                                                  fontFamily: 'Sora',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          index == details.length - 1
                                              ? const SizedBox()
                                              : const VerticalDivider()
                                        ],
                                      )),
                              const SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 0,
                        ),
                        BottomNavigationBar(
                            elevation: 5,
                            type: BottomNavigationBarType.fixed,
                            unselectedItemColor: isDark! ? white : black,
                            selectedItemColor: isDark! ? white : black,
                            showSelectedLabels: false,
                            showUnselectedLabels: false,
                            items: [
                              BottomNavigationBarItem(
                                label: 'text',
                                icon: GestureDetector(
                                    onTap: () => setState(() {
                                          editorText = true;
                                          text = '';
                                        }),
                                    child: const Icon(EvaIcons.text)),
                              ),
                              BottomNavigationBarItem(
                                  label: 'image',
                                  icon: GestureDetector(
                                    onTap: () => fromGallery(),
                                    child: const Icon(Bootstrap.image_fill),
                                  )),
                              BottomNavigationBarItem(
                                  label: 'sticker',
                                  icon: GestureDetector(
                                    onTap: () => showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (ctx) =>
                                            stickerbottomsheet(context)),
                                    child:
                                        const Icon(Bootstrap.emoji_smile_fill),
                                  ))
                            ]),
                      ],
                    ),
                    body: Center(
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: RepaintBoundary(
                            key: _widgetKey,
                            child: LindiStickerWidget(
                              controller: controller,
                              child: Stack(
                                children: [
                                  Image(
                                    image: NetworkImage(
                                        WebService().imageUrl + widget.image),
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  if (editorText) editorTextScreen(context, text)
                ],
              ),
            );
    });
  }

  Widget editorTextScreen(context, String text) => Scaffold(
        backgroundColor: isDark!
            ? Colors.black.withOpacity(0.75)
            : Colors.white.withOpacity(0.75),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: TextEditor(
            decoration: EditorDecoration(
              textBackground: TextBackgroundDecoration(
                  disable: const Icon(Bootstrap.bootstrap),
                  enable: const Icon(Bootstrap.bootstrap_fill)),
              doneButton: const Icon(Icons.done),
              alignment: AlignmentDecoration(
                center: const Icon(Icons.format_align_center_rounded),
                right: const Icon(Icons.format_align_right_rounded),
                left: const Icon(Icons.format_align_left_rounded),
              ),
            ),
            fonts: [
              GoogleFonts.oswald().fontFamily!,
              GoogleFonts.poppins().fontFamily!,
              GoogleFonts.lobster().fontFamily!,
              GoogleFonts.playfairDisplay().fontFamily!,
              GoogleFonts.raleway().fontFamily!,
              GoogleFonts.pacifico().fontFamily!,
              GoogleFonts.bebasNeue().fontFamily!,
              GoogleFonts.abrilFatface().fontFamily!,
              GoogleFonts.merriweather().fontFamily!,
              GoogleFonts.anton().fontFamily!,
            ],
            textStyle: TextStyle(
                fontFamily: GoogleFonts.oswald().fontFamily,
                color: isDark! ? white : black),
            text: text,
            onEditCompleted: (style, align, text) {
              controller.addWidget(Text(text, style: style, textAlign: align));
              setState(
                () {
                  editorText = false;
                },
              );
            },
          ),
        ),
      );

  List stickers = [
    Brand(Brands.adobe_after_effects),
    Brand(Brands.adobe_audition),
    Brand(Brands.adobe_illustrator),
    Brand(Brands.adobe_lightroom),
    Brand(Brands.airbnb),
    Brand(Brands.amazon),
    Brand(Brands.angellist),
    Brand(Brands.app_store),
    Brand(Brands.behance),
    Brand(Brands.bing),
    Brand(Brands.bitbucket),
    Brand(Brands.bitcoin),
    Brand(Brands.blogger),
    Brand(Brands.bootstrap),
    Brand(Brands.chrome),
    Brand(Brands.codepen),
    Brand(Brands.css3),
    Brand(Brands.discord),
    Brand(Brands.docker),
    Brand(Brands.dribbble),
    Brand(Brands.dropbox),
    Brand(Brands.drupal),
    Brand(Brands.ebay),
    Brand(Brands.facebook),
    Brand(Brands.firebase),
    Brand(Brands.figma),
    Brand(Brands.git),
    Brand(Brands.github),
    Brand(Brands.gitlab),
    Brand(Brands.gmail),
    Brand(Brands.google),
    Brand(Brands.google_drive),
    Brand(Brands.google_play),
    Brand(Brands.instagram),
    Brand(Brands.java),
    Brand(Brands.javascript),
    Brand(Brands.joomla),
    Brand(Brands.linkedin),
    Brand(Brands.medium),
    Brand(Brands.mail),
    Brand(Brands.microsoft),
    Brand(Brands.netflix),
    Brand(Brands.nodejs),
    Brand(Brands.npm),
    Brand(Brands.phone),
    Brand(Brands.paypal),
    Brand(Brands.pinterest),
    Brand(Brands.python),
    Brand(Brands.reddit),
    Brand(Brands.redux),
    Brand(Brands.sass),
    Brand(Brands.shopify),
    Brand(Brands.slack),
    Brand(Brands.snapchat),
    Brand(Brands.soundcloud),
    Brand(Brands.spotify),
    Brand(Brands.stripe),
    Brand(Brands.trello),
    Brand(Brands.tumblr),
    Brand(Brands.twitch),
    Brand(Brands.twitter),
    Brand(Brands.vimeo),
    Brand(Brands.whatsapp),
    Brand(Brands.wikipedia),
    Brand(Brands.wordpress),
    Brand(Brands.yahoo),
    Brand(Brands.youtube),
    Brand(Brands.zoom),
  ];

  Widget stickerbottomsheet(context) => Container(
        height: MediaQuery.of(context).size.height / 1.2,
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.close,
                            color: Colors.transparent,
                          )),
                      const Text(
                        'Stickers',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close))
                    ],
                  ),
                ),
                const Divider(
                  height: 5,
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(
                    stickers.length,
                    (index) => GestureDetector(
                      onTap: () {
                        controller.addWidget(stickers[index]);
                        Navigator.pop(context);
                      },
                      child: stickers[index],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  final time = DateTime.now()
      .toIso8601String()
      .replaceAll('.', '-')
      .replaceAll(':', '-');

  

  Future<void> _captureAndSave(BuildContext context) async {
    try {
      if (await Permission.storage.request().isGranted) {
        final isSavedNotifier = ValueNotifier<bool>(false);

        // Show the loader dialog with the notifier
        showLoaderDialog(context, isSavedNotifier);
        // 1) capture logic
        RenderRepaintBoundary boundary = _widgetKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 10.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        // 2) save image logic
        Directory? downloadsDir;

        if (Platform.isAndroid) {
          // For Android, manually set the path to Downloads folder
          downloadsDir = Directory('/storage/emulated/0/Pictures/Posterify');
        } else if (Platform.isIOS) {
          // For iOS, use the app-specific document directory
          downloadsDir = await getApplicationDocumentsDirectory();
        }

        Directory posterifyDir = Directory(downloadsDir!.path);

        // Create the directory if it doesn't exist
        if (!await posterifyDir.exists()) {
          await posterifyDir.create(recursive: true);
        }

        // Save the file
        final file = File(
            '${downloadsDir.path}/IMG-${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(pngBytes);

        MediaScanner.loadMedia(path: file.path);

        await WebService().uploadProject(file);

        await vm!.fetchProject();

        // Update the state
        isSavedNotifier.value = true;

        await Future.delayed(const Duration(seconds: 1));

        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> fromGallery() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img != null) {
        // Load the image to get its dimensions
        final imageFile = File(img.path);
        final bytes = await imageFile.readAsBytes();
        final image = await decodeImageFromList(bytes);

        log('fdsfdsfdsfds ======= $image');

        // Calculate the aspect ratio
        final isportrait = image.width < image.height;

        log('aspect ration==========$isportrait');

        // Add the widget with the calculated aspect ratio
        controller.addWidget(
          Image.file(
            imageFile,
            width: isportrait ? 80 : 120,
            height: isportrait ? 120 : 80,
            fit: BoxFit.cover,
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

void showLoaderDialog(
      BuildContext context, ValueNotifier<bool> isSavedNotifier) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ValueListenableBuilder<bool>(
          valueListenable: isSavedNotifier,
          builder: (context, isSaved, child) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isSaved
                      ? LottieBuilder.asset(
                          'assets/lottie/tick.json',
                          repeat: false,
                          height: 100,
                        )
                      : LottieBuilder.asset(
                          'assets/lottie/loading.json',
                          height: 100,
                        ),
                  isSaved
                      ? const Text(
                          "Image saved to Gallery",
                          style: TextStyle(fontFamily: 'Sora', fontSize: 20),
                        )
                      : const Text("Loading...",
                          style: TextStyle(fontFamily: 'Sora', fontSize: 20)),
                ],
              ),
            );
          },
        );
      },
    );
  }