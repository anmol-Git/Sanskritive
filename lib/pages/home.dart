import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../models/data.dart';
import '../models/dataModel.dart';
import '../models/firebaseModel.dart';
import 'messaging.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool completed = false;
  List<DataModel> usersData = [];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshPage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'People nearby',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.chat),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessagingScreen(),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Consumer<Data>(
            builder: (context, data, child) {
              usersData = data.usersData;
              return usersData.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: usersData.length,
                        itemBuilder: (context, index) {
                          DataModel dataModel = usersData[index];
                          return Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              leading: Image.network(
                                dataModel.photoUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    scrollable: true,
                                    titlePadding: const EdgeInsets.all(8),
                                    actions: [
                                      Provider.of<Data>(context)
                                              .sentByMeRequest(dataModel.userId)
                                          ? TextButton(
                                              child: const Text(
                                                'Request Sent',
                                              ),
                                              onPressed: () {},
                                            )
                                          : Provider.of<Data>(context)
                                                  .receivedForMeRequest(
                                                      dataModel.userId)
                                              ? TextButton(
                                                  child: const Text(
                                                    'Accept',
                                                  ),
                                                  onPressed: () {
                                                    Provider.of<Data>(context,
                                                            listen: false)
                                                        .accept(
                                                            dataModel.userId);
                                                  },
                                                )
                                              : Provider.of<Data>(context)
                                                      .isConnected(
                                                          dataModel.userId)
                                                  ? TextButton(
                                                      child: const Text(
                                                        'Connected',
                                                      ),
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                                title: const Text(
                                                                    'Confirm'),
                                                                content:
                                                                    const Text(
                                                                  'Are You Sure you want to remove this person as your connection?',
                                                                ),
                                                                elevation: 40,
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      await Navigator.maybePop(context).then((value) => Provider.of<Data>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .removeConnect(
                                                                              dataModel.userId));
                                                                    },
                                                                    // color: Theme.of(
                                                                    //         context)
                                                                    //     .primaryColor,
                                                                    child:
                                                                        const Text(
                                                                      'Yes',
                                                                    ),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      await Navigator
                                                                          .maybePop(
                                                                              context);
                                                                    },
                                                                    // color: Theme.of(
                                                                    //         context)
                                                                    //     .primaryColor,
                                                                    child:
                                                                        const Text(
                                                                      'No',
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                    )
                                                  : TextButton(
                                                      // : Colors.black,
                                                      child: const Text(
                                                        'Connect',
                                                      ),
                                                      onPressed: () {
                                                        Provider.of<Data>(
                                                                context,
                                                                listen: false)
                                                            .connect(dataModel
                                                                .userId);
                                                      },
                                                    ),
                                    ],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                        width: 2,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.all(10),
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        dataModel.photoUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    content: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: const Text(
                                                'Name:',
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationStyle:
                                                      TextDecorationStyle
                                                          .dashed,
                                                  decorationThickness: 3,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                dataModel.name,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: const Text(
                                                'Label:',
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationStyle:
                                                      TextDecorationStyle
                                                          .dashed,
                                                  decorationThickness: 3,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                dataModel.label,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: const Text(
                                                'Bio:',
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationStyle:
                                                      TextDecorationStyle
                                                          .dashed,
                                                  decorationThickness: 3,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                dataModel.bio,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              title: Text(
                                dataModel.name,
                              ),
                              subtitle: Text(
                                dataModel.label,
                              ),
                              trailing: Provider.of<Data>(context)
                                      .sentByMeRequest(dataModel.userId)
                                  ? TextButton(
                                      child: const Text(
                                        'Request Sent',
                                      ),
                                      onPressed: () {},
                                    )
                                  : Provider.of<Data>(context)
                                          .receivedForMeRequest(
                                              dataModel.userId)
                                      ? TextButton(
                                          child: const Text(
                                            'Accept',
                                          ),
                                          onPressed: () {
                                            Provider.of<Data>(context,
                                                    listen: false)
                                                .accept(dataModel.userId);
                                          },
                                        )
                                      : Provider.of<Data>(context)
                                              .isConnected(dataModel.userId)
                                          ? TextButton(
                                              child: const Text(
                                                'Connected',
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        title: const Text(
                                                            'Confirm'),
                                                        content: const Text(
                                                          'Are You Sure you want to remove this person as your connection?',
                                                        ),
                                                        elevation: 40,
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              await Navigator
                                                                      .maybePop(
                                                                          context)
                                                                  .then((value) => Provider.of<
                                                                              Data>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .removeConnect(
                                                                          dataModel
                                                                              .userId));
                                                            },
                                                            // color: Theme.of(
                                                            //         context)
                                                            //     .primaryColor,
                                                            child: const Text(
                                                              'Yes',
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              await Navigator
                                                                  .maybePop(
                                                                      context);
                                                            },
                                                            // color: Theme.of(
                                                            //         context)
                                                            //     .primaryColor,
                                                            child: const Text(
                                                              'No',
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              },
                                            )
                                          : TextButton(
                                              // textColor: Colors.black,
                                              child: const Text(
                                                'Connect',
                                              ),
                                              onPressed: () {
                                                Provider.of<Data>(context,
                                                        listen: false)
                                                    .connect(dataModel.userId);
                                              },
                                            ),
                            ),
                          );
                        },
                      ),
                    )
                  : (!completed
                      ? SpinKitDoubleBounce(
                          color: Colors.black,
                        )
                      : Center(
                          child: const Text(
                            'No Users Nearby',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ));
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchUsers() async {
    FirebaseModel firebaseModel = FirebaseModel();
    completed = await firebaseModel.fetchUsers(context);
    setState(() {
      completed = completed;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> refreshPage() async {
    setState(() {
      completed = false;
      fetchUsers();
    });
  }
}
