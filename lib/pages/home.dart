import 'dart:io';

import 'package:curse_flutter/models/band.dart';
import 'package:curse_flutter/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Band> listBand = [];

  @override
  void initState() {
    final _providerStatus = Provider.of<Services>(context, listen: false);
    _providerStatus.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    print(payload);
    listBand = (payload as List).map((e) => Band.fromMap(e)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final _providerStatus = Provider.of<Services>(context, listen: false);
    _providerStatus.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _providerStatus = Provider.of<Services>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Curso'),
        actions: [
          _providerStatus.serverStatus == ServerStatus.Online
              ? Icon(Icons.check_circle, color: Colors.blue[200])
              : Icon(Icons.offline_bolt, color: Colors.red)
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
                itemCount: listBand.length ?? 0,
                itemBuilder: (_, i) => _band(listBand[i])),
          ),
        ],
      ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: addNewBand),
    );
  }

  _band(Band band) {
    final _providerStatus = Provider.of<Services>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        _providerStatus.socket.emit('delete-band', {'id': band.id});
      },
      background: Container(
        color: Colors.red,
        child:
            Align(alignment: Alignment.centerRight, child: Text('Elimiando')),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            band.name.substring(0, 2),
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}'),
        onTap: () {
          _providerStatus.socket.emit('vote-band', {'id': band.id});
        },
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('New band name'),
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(
                    child: Text('Add'),
                    elevation: 5,
                    textColor: Colors.blue,
                    onPressed: () => _addBandToList(textController.text)),
              ],
            );
          });
    }
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('New band name'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('add'),
                onPressed: () => _addBandToList(textController.text),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('dismiss'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  void _addBandToList(String name) {
    if (name.length > 0) {
      final _providerStatus = Provider.of<Services>(context, listen: false);
      _providerStatus.socket.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = {};
    listBand.forEach((element) {
      dataMap.putIfAbsent(element.name, () => element.votes.toDouble());
    });

    return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
      ),
    );
  }
}
