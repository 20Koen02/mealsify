import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealsify/controllers/UserController.dart';
import 'package:mealsify/models/RecipeModel.dart';
import 'package:mealsify/models/UserModel.dart';
import 'package:path/path.dart';
import '../locator.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({
    Key? key,
    required Function onItemTapped,
  })   : _onItemTapped = onItemTapped,
        super(key: key);

  final Function _onItemTapped;

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  var _formKey = new GlobalKey<FormBuilderState>();

  late Function _onItemTapped;

  File? _image;
  final picker = ImagePicker();
  bool imageError = false;

  UserModel? currentUser = locator.get<UserController>().currentUser;

  @override
  void initState() {
    _onItemTapped = widget._onItemTapped;
    super.initState();
  }

  Future<void> saveRecipe(Map<String, dynamic> recipeData) async {
    if (_image == null) {
      imageError = true;
      return;
    }

    if (currentUser != null) {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('posts/${basename(_image!.path)}');

      UploadTask uploadTask = storageReference.putFile(_image!);
      await uploadTask.whenComplete(() async => {
            await storageReference.getDownloadURL().then((imageURL) {
              new RecipeModel(
                      image: imageURL,
                      description: recipeData['description'],
                      timeToPrep: int.parse(recipeData['timeToPrep']),
                      date: Timestamp.now(),
                      title: recipeData['title'],
                      uid: currentUser!.uid)
                  .toFirestore();
            })
          });
    }
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        imageError = false;
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Post recipe',
                    style: GoogleFonts.lora(
                      textStyle: TextStyle(
                          color: Color(0xFF3a2318),
                          fontSize: 36,
                          height: 1.2,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  FormBuilder(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(EvaIcons.imageOutline),
                            SizedBox(
                              width: 18.0,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: _image != null
                                  ? Image.file(
                                      _image!,
                                      height: 140.0,
                                      width: 140.0,
                                      fit: BoxFit.cover,
                                    )
                                  : SizedBox(
                                      height: 140.0,
                                      width: 140.0,
                                      child: Container(
                                        color: Color(0xFFEAEAEA),
                                        child: Center(
                                          child: Text(
                                            'Upload\n a photo',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton.icon(
                                  icon: Icon(
                                    EvaIcons.image2,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      getImage(ImageSource.gallery);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.amber, // background
                                    onPrimary: Color(0xFF3a2318), // foreground
                                  ),
                                  label: Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Text(
                                      'Gallery',
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  icon: Icon(
                                    EvaIcons.camera,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      getImage(ImageSource.camera);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.amber, // background
                                    onPrimary: Color(0xFF3a2318), // foreground
                                  ),
                                  label: Text(
                                    'Camera',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (imageError)
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 41.0, top: 5.0),
                            child: Text(
                              'Please select an image.',
                              style: TextStyle(
                                  color: Colors.red.shade700, fontSize: 12.0),
                            ),
                          ),
                        SizedBox(height: 10.0),
                        FormBuilderTextField(
                          name: 'title',
                          decoration: InputDecoration(
                            labelText: 'Title',
                            icon: Icon(
                              EvaIcons.edit2Outline,
                              color: Color(0xFF3a2318),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            FormBuilderValidators.maxLength(context, 40),
                          ]),
                        ),
                        SizedBox(height: 5.0),
                        FormBuilderTextField(
                          name: 'description',
                          decoration: InputDecoration(
                            labelText: 'Description and steps',
                            icon: Icon(
                              EvaIcons.fileTextOutline,
                              color: Color(0xFF3a2318),
                            ),
                          ),
                          maxLines: 20,
                          minLines: 1,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            FormBuilderValidators.maxLength(context, 100),
                          ]),
                        ),
                        FormBuilderTextField(
                          name: 'timeToPrep',
                          decoration: InputDecoration(
                            labelText: 'Time to prepare in minutes',
                            icon: Icon(
                              EvaIcons.clockOutline,
                              color: Color(0xFF3a2318),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            FormBuilderValidators.numeric(context),
                          ]),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          child: const Icon(
                            EvaIcons.plusOutline,
                            size: 30.0,
                            color: Color(0xFF3a2318),
                          ),
                          onPressed: () {
                            setState(() {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                saveRecipe(_formKey.currentState!.value);
                                _onItemTapped(3);
                              } else {
                                print("validation failed");
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
