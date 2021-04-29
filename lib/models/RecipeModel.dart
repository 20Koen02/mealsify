import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  String? id;
  String image;
  String title;
  String description;
  Timestamp date;
  int timeToPrep;
  String uid;

  RecipeModel(
      {this.id,
      required this.image,
      required this.title,
      required this.timeToPrep,
      required this.description,
      required this.date,
      required this.uid});

  factory RecipeModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data()!;

    return RecipeModel(
        id: doc.id,
        image: data['image'] ?? '',
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        timeToPrep: data['timeToPrep'] ?? 0,
        date: data['date'] ?? Timestamp.now(),
        uid: data['uid'] ?? '');
  }

  void toFirestore() {
    CollectionReference postsCollection =
        FirebaseFirestore.instance.collection('posts');
    postsCollection
        .add({
          'image': this.image,
          'title': this.title,
          'description': this.description,
          'timeToPrep': this.timeToPrep,
          'date': this.date,
          'uid': this.uid
        })
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add post: $error"));
  }
}
