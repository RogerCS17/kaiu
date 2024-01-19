import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:kaiu/src/core/services/database.dart";
import "package:kaiu/src/ui/widget/BuildInputField/build_input_field.dart";
import "package:random_string/random_string.dart";

class KaijuForm extends StatefulWidget {
  const KaijuForm({super.key});

  @override
  State<KaijuForm> createState() => KaijuFormState();
}

class KaijuFormState extends State<KaijuForm> {
  final database = DatabaseMethods.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController colorHexController = TextEditingController();
  TextEditingController aliasOfController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController planetController = TextEditingController();
  TextEditingController ultraController = TextEditingController();
  TextEditingController commentaryController = TextEditingController();
  TextEditingController imgDrawerController = TextEditingController();
  TextEditingController episodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Kaiju",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Form",
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20, top: 30.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              buildInputField("Name", nameController),
              buildInputField("Subtitle", subtitleController),
              buildInputField("Description", descriptionController),
              buildInputField("Color Hex", colorHexController),
              buildInputField("Alias", aliasOfController),
              buildInputField("Height", heightController),
              buildInputField("Weight", weightController),
              buildInputField("Planet", planetController),
              buildInputField("Ultra", ultraController),
              buildInputField("Comentary", commentaryController),
              buildInputField("Img Drawer", imgDrawerController),
              buildInputField("Episode", episodeController), //Castear

              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      String id = randomAlphaNumeric(20);
                      Map<String, dynamic> kaijuInfoMap = {
                        "id": id,
                        "name": nameController.text,
                        "subtitle": subtitleController.text,
                        "description": descriptionController.text,
                        "colorHex": colorHexController.text,
                        "aliasOf": aliasOfController.text,
                        "height": heightController.text,
                        "weight": weightController.text,
                        "planet": planetController.text,
                        "ultra": ultraController.text,
                        "comentary": commentaryController.text,
                        "imgDrawer": imgDrawerController.text,
                        "episode": int.parse(episodeController.text),
                      };
                      //Parte BackEnd
                      await database
                          .addKaijuDetails(kaijuInfoMap, id)
                          .then((value) {
                        Fluttertoast.showToast(
                            msg: "Kaiju Registred",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      });
                    },
                    child: Text(
                      "Añadir Kaiju",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
