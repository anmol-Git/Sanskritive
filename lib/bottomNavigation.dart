import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import './pages/home.dart';
import './pages/learn.dart';
import './pages/profile.dart';
import './pages/request.dart';
import './pages/widgets/badge.dart';
import 'models/bottomPanelModel.dart';
import 'models/data.dart';

Map<String, Widget> _pages = {
  'Learn': LearnPage(),
  'Connect': Home(),
  'Profile': ProfileScreen()
};

class BottomPanel extends StatelessWidget {
  final ScrollController controller = ScrollController();
  static const String sanskritURL = "https://www.101languages.net/sanskrit";

  @override
  Widget build(BuildContext context) {
    int _selectedPageIndex = Provider.of<BottomPanelModel>(context).ind;

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        //backgroundColor: Colors.blue[300],
        actions: [
          _selectedPageIndex == 0
              ? Consumer<Data>(
                  builder: (context, data, child) => Badge(
                    value: data.count.toString(),
                    child: child,
                    color: Colors.redAccent,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_alert_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Request(),
                        ),
                      );
                    },
                  ),
                )
              : _selectedPageIndex == 1
                  ? IconButton(
                      icon: const Icon(
                        CupertinoIcons.question,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) => Center(
                                  child: Wrap(children: [
                                    AlertDialog(
                                      scrollable: true,
                                      title: Center(
                                        child: const Text(
                                          'Hey there!',
                                        ),
                                      ),
                                      content: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: const Text(
                                                'The Learn tab consists of a set of basic words in Sanskrit along with their pronunciations (as written in brackets) and their English translations so that you may keep some of the most common words handy and refer with ease!'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                launch(sanskritURL);
                                              },
                                              child: Text(
                                                'Credit: $sanskritURL',
                                                style: const TextStyle(
                                                    color: Colors.deepPurple),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                                ));
                      })
                  : IconButton(
                      icon: const Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => AlertDialog(
                                  scrollable: true,
                                  title: const Center(
                                    child: Text('About'),
                                  ),
                                  content: Container(
                                    child: Scrollbar(
                                      controller: controller,
                                      thickness: 15,
                                      isAlwaysShown: true,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Center(
                                            child: const Image(
                                              image: AssetImage(
                                                  'assets/sanskritivelogo.jpeg'),
                                              width: 200,
                                              height: 200,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: const Text(
                                              'Sanskritive is a product aimed at instilling a momentum for a Sanskrit driven community by connecting people from different backgrounds to have a common platform for sharing ideas , teaching and solving Sanskrit related doubts , and be a part of a social Sanskrit ecosystem.',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: const Text(
                                              'Developed by: ANMOL SHARMA and PRAKUL JAIN for the final year project ',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                      }),
        ],
        title: Text(
          _pages.keys.elementAt(_selectedPageIndex),
        ),
      ),
      body: IndexedStack(
        children: _pages.values.toList(),
        index: _selectedPageIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          Provider.of<BottomPanelModel>(context, listen: false).setInd(index);
        },
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.tealAccent[700],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.connect_without_contact_sharp,
              ),
              label: 'Connect'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
