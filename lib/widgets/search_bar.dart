import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    required Function searchRecipes,
    required Function searching,
  })   : _searchRecipes = searchRecipes,
        _searching = searching,
        super(key: key);

  final Function _searchRecipes;
  final Function _searching;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late Function _searchRecipes;
  late Function _searching;

  @override
  void initState() {
    _searchRecipes = widget._searchRecipes;
    _searching = widget._searching;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: Color(0xFFF8F7F7),
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 13.0, bottom: 13.0),
            child: Icon(
              EvaIcons.searchOutline,
              color: Colors.amber.shade800,
              size: 30.0,
              semanticLabel: 'Search',
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    if (text.length > 0) {
                      _searching(true);
                      _searchRecipes(text);
                    } else {
                      _searching(false);
                    }
                  });
                },
                cursorColor: Colors.amber.shade800,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.go,
                style: TextStyle(color: Color(0xFF3a2318), fontSize: 18),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  hintText: "Recipe",
                  hintStyle: TextStyle(color: Color(0xFFE1DBDB)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
