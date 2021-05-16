import 'package:cowin_slot_checker/model/state_response.dart';
import 'package:cowin_slot_checker/repo/state_repo.dart';
import 'package:flutter/material.dart';

class SelecteState extends StatefulWidget {
  @override
  _SelecteStateState createState() => _SelecteStateState();
}

class _SelecteStateState extends State<SelecteState> {
  StateRepo _stateRepo;
  TextEditingController _textController = TextEditingController();

  List<States> statesList = [];
  List<States> searchedData = [];
  String searchQuery = "";

  Future fetchState() async {
    _stateRepo = StateRepo();
    _stateRepo.fetchAlbumDetails().then((value) {
      setState(() {
        statesList = value.states;
        searchedData = value.states;
      });
    });
  }

  @override
  void initState() {
    fetchState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(color: Colors.black);
    final styleHint = TextStyle(color: Colors.black54);
    final style = searchQuery.toString().isEmpty ? styleHint : styleActive;
    onItemChanged(String query) {
      setState(() {
        searchQuery = query;
        searchedData = statesList
            .where((string) =>
                string.stateName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Select State"),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: Column(children: [
            Container(
              height: 42,
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(color: Colors.black26),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: style.color),
                  hintText: 'Search Here...',
                  suffixIcon: searchQuery.isNotEmpty
                      ? GestureDetector(
                          child: Icon(Icons.close, color: style.color),
                          onTap: () {
                            _textController.clear();
                            onItemChanged('');
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        )
                      : null,
                  hintStyle: style,
                  border: InputBorder.none,
                ),
                onChanged: onItemChanged,
              ),
            ),
            searchedData.length > 0
                ? Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      itemCount: searchedData.length,
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());

                            Navigator.pop(context, [
                              "fromState",
                              searchedData[index].stateName,
                              searchedData[index].stateId.toString()
                            ]
                                // {
                                //   "fromWhere": "fromState",
                                //   "name": searchedData[index].stateName,
                                //   "id": searchedData[index].stateId.toString(),
                                // },
                                );
                          },
                          title: Text(searchedData[index].stateName),
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          ]),
        ),
      ),
    );
  }
}
