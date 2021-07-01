import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:joujou_lounge/api/http_service.dart';
import 'package:joujou_lounge/constant/config.dart';
import 'package:joujou_lounge/constant/style.dart';
import 'package:joujou_lounge/model/category_model.dart';
import 'package:joujou_lounge/model/food_model.dart';
import 'package:joujou_lounge/repository/category_repository.dart';
import 'package:joujou_lounge/repository/food_repository.dart';
import 'package:joujou_lounge/repository/meta_repository.dart';
import 'package:joujou_lounge/screen/feedback_screen.dart';
import 'package:joujou_lounge/screen/menu_cart_screen.dart';
import 'package:joujou_lounge/widget/dialog/awesome_dialog.dart';
import 'package:joujou_lounge/widget/home/main_select_button.dart';
import 'package:joujou_lounge/widget/home/password_dialog.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as Http;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:joujou_lounge/util/toasts.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _isInSync;
  int _syncCount;
  double _syncPercent;
  Locale _selectedLang;
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _isInSync = false;
    _syncCount = 0;
    _syncPercent = 0;
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Locale locale = _selectedLang ?? EasyLocalization.of(context).locale;
    return Scaffold(
      body: ModalProgressHUD(
        child: Stack(
          children: <Widget>[
            FutureBuilder(
              future: MetaRepository.getBackground(),
              builder: (context, snapshot) {
                if (snapshot.data == null || snapshot.data.isEmpty || snapshot.data[0].isEmpty || snapshot.data[1].isEmpty) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/6.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }

                String type = snapshot.data[0];
                String url = snapshot.data[1];
                if (type == "image") {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("${Config.BASE_IMAGE_URL}/$url"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }

                _controller = VideoPlayerController.network("${Config.BASE_IMAGE_URL}/$url")
                  ..initialize().then((_) {
                    _controller.play();
                    _controller.setLooping(true);
                    setState(() {});
                  });

                return SizedBox.expand(
                  child: FittedBox(
                    // If your background video doesn't look right, try changing the BoxFit property.
                    // BoxFit.fill created the look I was going for.
                    fit: BoxFit.fill,
                    child: SizedBox(
                      width: _controller.value.size?.width ?? 0,
                      height: _controller.value.size?.height ?? 0,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                );
              },
            ),
            Align(
              alignment: locale.languageCode == "ar" ? Alignment.bottomLeft : Alignment.bottomRight,
              child: Padding(
                padding: locale.languageCode == "ar" ? const EdgeInsets.only(bottom: 30, left: 30) : const EdgeInsets.only(bottom: 30, right: 30),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.language, color: Styles.appPrimaryColor, size: 30,),
                      SizedBox(width: 20),
                      DropdownButton<Locale>(
                        value: locale,
                        underline: Container(),
                        style: TextStyle(color: Styles.appPrimaryColor, fontSize: 20),
                        onChanged: (Locale lang) {
                          if (lang.languageCode == "en") {
                            context.locale = EasyLocalization.of(context).supportedLocales[0];
                          } else {
                            context.locale = EasyLocalization.of(context).supportedLocales[1];
                          }
                          setState(() {
                            _selectedLang = lang;
                          });
                        },
                        items: EasyLocalization.of(context).supportedLocales.map((item) {
                          return DropdownMenuItem<Locale>(
                            value: item,
                            child: Text(tr(item.languageCode)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: MainSelectButton(Icon(Icons.restaurant, color: Colors.white, size: 60), tr("menu"), () => _openMenuScreen()),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: locale.languageCode == "ar" ? const EdgeInsets.only(bottom: 200, right: 400) : const EdgeInsets.only(bottom: 200, left: 400),
                child: MainSelectButton(Icon(Icons.shopping_cart, color: Colors.white, size: 60), tr("cart"), () => _openCartScreen()),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: locale.languageCode == "ar" ? const EdgeInsets.only(bottom: 200, left: 400) : const EdgeInsets.only(bottom: 200, right: 400),
                child: MainSelectButton(Icon(Icons.feedback, color: Colors.white, size: 60), tr("feedback"), () => _openFeedbackScreen()),
              ),
            ),
            Align(
              alignment: locale.languageCode == "ar" ? Alignment.bottomRight : Alignment.bottomLeft,
              child: Padding(
                padding: locale.languageCode == "ar" ? const EdgeInsets.only(bottom: 30, right: 30) : const EdgeInsets.only(bottom: 30, left: 30),
                child: ButtonTheme(
                  height: 60,
                  child: RaisedButton(
                    onPressed: () => openPasswordDialog(),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.white)),
                    child: Text(tr("syncdb"), style: TextStyle(color: Styles.appPrimaryColor, fontSize: 18),),
                  ),
                ),
              ),
            ),
          ],
        ),
        inAsyncCall: _isInSync,
        opacity: 0.5,
        color: Colors.black,
        progressIndicator: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 13.0,
                animation: true,
                addAutomaticKeepAlive: true,
                animateFromLastPercent: true,
                percent: _syncPercent / 100,
                center: new Text(
                  "percent",
                  style:
                  new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
                ).tr(args: ['${_syncPercent.toStringAsFixed(1)}']),
                footer: new Text(
                  tr("syncing_db"),
                  style:
                  new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.purple,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openMenuScreen() {
    Navigator.push(context, MaterialPageRoute(
      fullscreenDialog: false,
      builder: (context) => MenuCartScreen(false),
    ));
  }

  void _openFeedbackScreen() {
    Navigator.push(context, MaterialPageRoute(
      fullscreenDialog: false,
      builder: (context) => FeedbackScreen(),
    ));
  }

  void _openCartScreen() {
    Navigator.push(context, MaterialPageRoute(
      fullscreenDialog: false,
      builder: (context) => MenuCartScreen(true),
    ));
  }

  void openPasswordDialog() {
    showDialog(context: context,
      builder: (context) => PasswordDialog(onNext: () => _openSyncConfirmDlg(),),);
  }

  void _openSyncConfirmDlg() {
    AwesomeDialog(
      context: context,
      padding: const EdgeInsets.symmetric(horizontal: 200),
      headerAnimationLoop: false,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      dismissOnTouchOutside: false,
      title: tr("confirm"),
      desc: tr("sync_confirm_question"),
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        setState(() {
          _isInSync = true;
          _syncDatabase();
        });
      },
    )..show();
  }

  void _syncDatabase() async {
    Http.Response responseMeta = await HttpService.post("getSettings", null);
    if (responseMeta.statusCode != 200) {
      setState(() {
        _isInSync = false;
        _syncCount = 0;
        _syncPercent = 0;
      });
      return ToastUtils.showErrorToast(context, tr("something_wrong_late"));
    }
    await MetaRepository.clearMeta();
    Map<String, dynamic> mapMeta = jsonDecode(responseMeta.body);
    print("meta: $mapMeta");
    await MetaRepository.updateMeta("feedback", mapMeta['feedback']);
    await MetaRepository.updateMeta("note", mapMeta['note']);
    await MetaRepository.updateMeta("background_type", mapMeta['background_type']);
    await MetaRepository.updateMeta("background_url", mapMeta['background_url']);
    await MetaRepository.updateMeta("main_category_color", mapMeta['main_category_color']);
    await MetaRepository.updateMeta("sub_category_color", mapMeta['sub_category_color']);

    Http.Response response = await HttpService.post("getInfo", null);
    print("Response code: ${response.statusCode}");
    if (response.statusCode != 200) {
      setState(() {
        _isInSync = false;
        _syncCount = 0;
        _syncPercent = 0;
      });
      return ToastUtils.showErrorToast(context, tr("something_wrong_late"));
    }
    Map<String, dynamic> map = jsonDecode(response.body);
    List<dynamic> categories = map['categories'];
    List<dynamic> foods = map['foods'];
    await CategoryRepository.clearCategories();
    await FoodRepository.clearFoods();
    await FoodRepository.clearFoodCategoryRelations();

    int totalCount = foods.length + categories.length;

    int catRemainder = categories.length % 10;
    int catSqrtLength = catRemainder == 0 ? (categories.length / 10).toInt() : ((categories.length - catRemainder) / 10 + 1).toInt();
    var catSqrList = List.generate(10, (i) => List.generate(catSqrtLength, (j) => categories.length > (i + 10 * j) ? categories[i + 10 * j] : null));

    int foodRemainder = foods.length % 10;
    int foodSqrtLength = foodRemainder == 0 ? (foods.length / 10).toInt() : ((foods.length - foodRemainder) / 10 + 1).toInt();
    var foodSqrList = List.generate(10, (i) => List.generate(foodSqrtLength, (j) => foods.length > (i + 10 * j) ? foods[i + 10 * j] : null));

    try {
      List<int> responses = await Future.wait([
        saveCategories(catSqrList[0], totalCount),
        saveCategories(catSqrList[1], totalCount),
        saveCategories(catSqrList[2], totalCount),
        saveCategories(catSqrList[3], totalCount),
        saveCategories(catSqrList[4], totalCount),
        saveCategories(catSqrList[5], totalCount),
        saveCategories(catSqrList[6], totalCount),
        saveCategories(catSqrList[7], totalCount),
        saveCategories(catSqrList[8], totalCount),
        saveCategories(catSqrList[9], totalCount),
        saveFoods(foodSqrList[0], totalCount),
        saveFoods(foodSqrList[1], totalCount),
        saveFoods(foodSqrList[2], totalCount),
        saveFoods(foodSqrList[3], totalCount),
        saveFoods(foodSqrList[4], totalCount),
        saveFoods(foodSqrList[5], totalCount),
        saveFoods(foodSqrList[6], totalCount),
        saveFoods(foodSqrList[7], totalCount),
        saveFoods(foodSqrList[8], totalCount),
        saveFoods(foodSqrList[9], totalCount),
      ]);
      setState(() {
        _isInSync = false;
        _syncCount = 0;
        _syncPercent = 0;
      });
    } catch (e) {
      print("Save error: " + e.toString());
    }
  }

  Future<int> saveCategories(List<dynamic> categories, int total) async {
    for (var category in categories) {
      await saveCategory(category, total);
    }
    return categories.length;
  }

  Future<int> saveFoods(List<dynamic> foods, int total) async {
    for (var food in foods) {
      await saveFood(food, total);
    }
    return foods.length;
  }

  void saveCategory(dynamic element, int total) async {
    if (element == null) return;
    String image = await HttpService.getImageString("${Config.BASE_IMAGE_URL}/${element['image']}");
    while (image == null) {
      image = await HttpService.getImageString("${Config.BASE_IMAGE_URL}/${element['image']}");
    }

    CategoryModel category = CategoryModel(id: element['id'], title: element['name'], titleAr: element['ar_name'], parentId: element['parentId'], image: image);
    await CategoryRepository.insertCategory(category);
    setState(() {
      _syncCount++;
      _syncPercent = (_syncCount / total) * 100;
    });
    return;
  }

  void saveFood(dynamic element, int total) async {
    if (element == null) return;
    String categories = element['categories'];
    var categoryList = categories.split(',');
    double price = element['price'] - 0.0;
    String image = await HttpService.getImageString("${Config.BASE_IMAGE_URL}/${element['image']}");
    while (image == null) {
      image = await HttpService.getImageString("${Config.BASE_IMAGE_URL}/${element['image']}");
    }
    FoodModel food = FoodModel(id: element['id'], title: element['name'], titleAr: element['ar_name'], price: price.toDouble(), image: image);
    await FoodRepository.insertFood(food);
    for (var elementCat in categoryList) {
      await FoodRepository.insertFoodCategoryRelation(food.id, int.parse(elementCat));
    }
    setState(() {
      _syncCount++;
      _syncPercent = (_syncCount / total) * 100;
    });
    return;
  }
}
