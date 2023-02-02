import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/data.dart';
import '../models/dataModel.dart';

class Request extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> sentByMe = Provider.of<Data>(context).sentByMe;
    List<String> receivedForMe = Provider.of<Data>(context).receivedForMe;
    List<DataModel> usersData = Provider.of<Data>(context).usersData;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Requests',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Requests Sent By Me',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            ...sentByMe.map((id) {
              DataModel dataModel = usersData
                  .where((dataModel) => dataModel.userId == id)
                  .toList()[0];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: Image.network(
                    dataModel.photoUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  onTap: () {},
                  title: Text(
                    dataModel.name,
                  ),
                  subtitle: Text(
                    dataModel.label,
                  ),
                  trailing: TextButton(
                    child: const Text(
                      'Request Sent',
                    ),
                    onPressed: () {},
                  ),
                ),
              );
            }).toList(),
            const Divider(
              thickness: 2,
              color: Colors.black,
            ),
            const Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Requests received',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            ...receivedForMe.map((id) {
              DataModel dataModel = usersData
                  .where((dataModel) => dataModel.userId == id)
                  .toList()[0];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: Image.network(
                    dataModel.photoUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  onTap: () {},
                  title: Text(
                    dataModel.name,
                  ),
                  subtitle: Text(
                    dataModel.label,
                  ),
                  trailing: TextButton(
                    child: const Text(
                      'Accept',
                    ),
                    onPressed: () {
                      Provider.of<Data>(context, listen: false)
                          .accept(dataModel.userId);
                    },
                  ),
                ),
              );
            }).toList(),
            const Divider(
              thickness: 2,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
