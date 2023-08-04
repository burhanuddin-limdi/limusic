import 'package:flutter/material.dart';

import '../API/api.dart';
import '../widgets/song_bar.dart';

// ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchBar;
  late ValueNotifier<bool> _fetchingSongs;
  late FocusNode _inputNode;
  List _searchResult = [];

  @override
  void initState() {
    super.initState();
    _searchBar = TextEditingController();
    _fetchingSongs = ValueNotifier(false);
    _inputNode = FocusNode();
  }

  Future<void> search() async {
    final query = _searchBar.text;

    if (query.isEmpty) {
      _searchResult = [];
      // _suggestionsList = [];
      setState(() {});
      return;
    }

    if (!_fetchingSongs.value) {
      _fetchingSongs.value = true;
    }

    // if (!searchHistory.contains(query)) {
    //   searchHistory.insert(0, query);
    //   addOrUpdateData('user', 'searchHistory', searchHistory);
    // }

    try {
      _searchResult = await fetchSongsList(query);
    } catch (e) {
      // Logger.log('Error while searching online songs: $e');
    }

    if (_fetchingSongs.value) {
      _fetchingSongs.value = false;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
            child: TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                search();
              },
              controller: _searchBar,
              focusNode: _inputNode,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Search...',
                fillColor: Colors.white,
                filled: true,
                border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                suffixIcon: ValueListenableBuilder(
                  valueListenable: _fetchingSongs,
                  builder: (_, value, __) {
                    if (value) {
                      return IconButton(
                        icon: const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(),
                        ),
                        color: Colors.black,
                        onPressed: () {
                          search();
                          _inputNode.unfocus();
                        },
                      );
                    } else {
                      return IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        color: Colors.black,
                        onPressed: () {
                          search();
                          _inputNode.unfocus();
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: _searchResult.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SongBar(
                  _searchResult[index],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
