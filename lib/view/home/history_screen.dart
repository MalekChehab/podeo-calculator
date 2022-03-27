import 'package:flutter/material.dart';
import '../../models/calculation.dart';
import '../../services/database.dart';

class HistoryScreen extends StatefulWidget {
  final String email;
  const HistoryScreen({required this.email, Key? key}) : super(key: key);

  @override
  createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          margin: const EdgeInsets.only(left: 8),
          child: const Text('History'),
        ),
      ),
      body: FutureBuilder<List<Calculation>>(
        future: Database().getData(widget.email),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.none ||
              snap.data == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Container();
          }
          return ListView.builder(
            itemCount: snap.data!.length,
            itemBuilder: (context, index) {
              Calculation calculation = snap.data![index];
              return Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      calculation.equation,
                      style: TextStyle(
                          fontSize: 23,
                          color: Theme.of(context).primaryColor
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                        '=${calculation.result}',
                      style: TextStyle(
                        fontSize: 23,
                        color: Theme.of(context).accentColor,
                      )
                    ),
                  ),
                  const SizedBox(height: 20,),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
