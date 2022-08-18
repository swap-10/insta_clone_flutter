import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone_flutter/models/user.dart' as user_model;

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  void openSearchScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => const SearchScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 40,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Color.fromARGB(255, 26, 25, 25),
              ),
              child: InkWell(
                onTap: openSearchScreen,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                  child: Row(
                    children: const [
                      Icon(Icons.search),
                      Padding(padding: EdgeInsets.only(left: 16.0)),
                      Text(
                        "Search",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  QuerySnapshot? snapshot;
  List<QueryDocumentSnapshot>? docs;

  void getSearchList(String searchControllerText) async {
    setState(() {});
    snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username',
            isGreaterThanOrEqualTo: searchController.text,
            isLessThanOrEqualTo: searchController.text + "\uf7ff")
        .get();

    docs = snapshot!.docs;
    if (mounted) {
      setState(() {});
    }
  }

  void backToExploreScreen() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: backToExploreScreen,
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (searchControllerText) =>
                        getSearchList(searchController.text),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 26, 25, 25),
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            searchController.text.isEmpty
                ? Expanded(
                    child: Container(),
                  )
                : snapshot == null
                    ? const CircularProgressIndicator()
                    : docs == null
                        ? const CircularProgressIndicator()
                        : Expanded(
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int idx) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: Image.network(
                                            user_model.UserInfo.fromSnap(
                                                    docs![idx])
                                                .dpURL)
                                        .image,
                                  ),
                                  title: Text(
                                      user_model.UserInfo.fromSnap(docs![idx])
                                          .username),
                                );
                              },
                              itemCount: docs!.length,
                            ),
                          ),
          ],
        ),
      ),
    );
  }
}
