import 'package:flutter/material.dart';

class HomeRecipeCard extends StatefulWidget {
  const HomeRecipeCard({
    Key? key,
    required String image,
    required String title,
    required int timeToPrep,
  })   : _image = image,
        _title = title,
        _timeToPrep = timeToPrep,
        super(key: key);

  final String _image;
  final String _title;
  final int _timeToPrep;

  @override
  _HomeRecipeCardState createState() => _HomeRecipeCardState();
}

class _HomeRecipeCardState extends State<HomeRecipeCard> {
  late String _image;
  late String _title;
  late int _timeToPrep;

  @override
  void initState() {
    _image = widget._image;
    _title = widget._title;
    _timeToPrep = widget._timeToPrep;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        width: 200.0,
        decoration: BoxDecoration(
          color: Color(0xFFE1DBDB),
          borderRadius: BorderRadius.all(
            Radius.circular(22),
          ),
          image: DecorationImage(
            image: NetworkImage(_image),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2.5,
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              height: 130.0,
              transform: Matrix4.translationValues(
                0.0,
                1.0,
                0.0,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFF8F7F7),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        color: Color(0xFF3a2318),
                        fontSize: 26,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "$_timeToPrep min",
                      style: TextStyle(
                        color: Color(0xFFB8B8B8),
                        fontSize: 18,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
