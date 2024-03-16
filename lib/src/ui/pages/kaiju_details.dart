import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/models/kaiju.dart';
import 'package:kaiu/src/core/models/ultra.dart';
import 'package:kaiu/src/ui/pages/error_page.dart';
import 'package:kaiu/src/ui/pages/home.dart';
import 'package:kaiu/src/ui/widget/CarrouselText/CarrouselText.dart';
import 'package:kaiu/src/ui/widget/ImageChanger/image_changer.dart';
import 'package:kaiu/src/ui/widget/KaijuDrawer/kaiju_drawer.dart';
import 'package:kaiu/src/ui/widget/MoreDetailsDrawer/more_details_kaiju.dart';

class KaijuDetails extends StatefulWidget {
  final Kaiju kaiju;
  final Ultra ultra;
  final theme = ThemeController.instance;

  KaijuDetails({Key? key, required this.kaiju, required this.ultra})
      : super(key: key);

  @override
  State<KaijuDetails> createState() => _KaijuDetailsState();
}

class _KaijuDetailsState extends State<KaijuDetails>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _opacityController;
  late Animation<double> _opacityAnimation;

  bool _isConnected = true;

  // Método para verificar la conexión a Internet
  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No hay conexión
      setState(() {
        _isConnected = false;
      });
    } else {
      // Hay conexión
      setState(() {
        _isConnected = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkInternetConnection().then((value) {
      if (_isConnected) {
        _opacityController = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 500),
        );
        _opacityAnimation =
            Tween<double>(begin: 0.0, end: 1.0).animate(_opacityController);
        _opacityController.forward();
      }
    });
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height - (statusHeight);
    var screenWidth = size.width;

    return _isConnected? Scaffold(
      drawer: KaijuDrawer(kaiju: widget.kaiju, ultra: widget.ultra),
      backgroundColor: widget.theme.background(),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          widget.kaiju.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: colorFromHex(widget.kaiju.colorHex),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                (Route<dynamic> route) => false,
              );
            },
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Container(
                  padding: const EdgeInsets.only(right: 7, left: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  height: 45,
                  width: 90,
                  child: Image.network(
                    widget.ultra.imgLogo!,
                    height: 50,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  SizedBox(
                    height: screenHeight / 2.85,
                    width: screenWidth,
                    child: ImageChanger(kaiju: widget.kaiju),
                  ),
                  CarrouselText(
                      userNames: widget.kaiju.usersPremium!.cast<String>())
                ],
              ),
            ),
            SizedBox(height: screenHeight / 50),
            Text(
              'Alias: ${widget.kaiju.subtitle}',
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: widget.theme.textPrimary(),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight / 50),
            Container(
              height: screenHeight / 2.85,
              width: screenWidth,
              decoration: BoxDecoration(
                color: widget.theme.backgroundSecondary(),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white,
                  width: 0.5,
                ),
              ),
              child: Scrollbar(
                controller: _scrollController,
                child: ListView(
                  controller: _scrollController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.kaiju.description,
                            style: TextStyle(
                              fontSize: 19,
                              color: widget.theme.textPrimary(),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(child: Container()),
            MoreDetailsKaiju(kaiju: widget.kaiju),
            Expanded(child: Container()),
          ],
        ),
      ),
    ):ErrorPage();
  }
}
