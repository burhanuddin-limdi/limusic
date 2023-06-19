import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: const Alignment(-1, 0),
          child: const Padding(
            padding: EdgeInsets.only(top: 40, left: 10),
            child: Text(
              'Search',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        const Divider(),
        Container(
          height: 70,
          padding: const EdgeInsets.all(10),
          child: const TextField(
            autofocus: true,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Search...',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
        ),
      ],
    );
  }
}
