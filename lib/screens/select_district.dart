import 'package:cowin_slot_checker/model/district_response.dart';
import 'package:cowin_slot_checker/repo/state_repo.dart';
import 'package:flutter/material.dart';

class SelectDistricts extends StatefulWidget {
  final String stateId;

  const SelectDistricts({Key key, @required this.stateId}) : super(key: key);
  @override
  _SelectDistrictsState createState() => _SelectDistrictsState();
}

class _SelectDistrictsState extends State<SelectDistricts> {
  StateRepo _stateRepo;
  List<Districts> distictList = [];
  List<Districts> searchedData = [];
  String searchQuery = "";
  TextEditingController _textController = TextEditingController();

  Future fetchDistricts() async {
    _stateRepo = StateRepo();
    _stateRepo.fetchAllDistricts(widget.stateId).then((value) {
      setState(() {
        distictList = value.districts;
        searchedData = value.districts;
      });
    });
  }

  @override
  void initState() {
    fetchDistricts();
    super.initState();
  }

  onItemChanged(String query) {
    setState(() {
      searchQuery = query;
      searchedData = distictList
          .where((string) =>
              string.districtName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(color: Colors.black);
    final styleHint = TextStyle(color: Colors.black54);
    final style = searchQuery.toString().isEmpty ? styleHint : styleActive;
    return Scaffold(
      appBar: AppBar(
        title: Text("Select District"),
      ),
      body: Column(
        children: [
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
                  child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  itemCount: searchedData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      //                          <-- Card widget
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(
                            context,
                            {
                              "fromWhere": "fromDistict",
                              "name":
                                  searchedData[index].districtName.toString(),
                              "id": searchedData[index].districtId.toString(),
                            },
                          );
                        },
                        title: Text(searchedData[index].districtName),
                      ),
                    );
                  },
                ))
              : Text(""),
        ],
      ),
    );
  }
}
