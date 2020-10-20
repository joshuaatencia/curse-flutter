import 'package:curse_flutter/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerStatus = Provider.of<Services>(context);

    return Scaffold(
      body: Center(child: Text('${providerStatus.serverStatus}')),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            providerStatus.socket.emit('emitir-mensaje', [
              {'nombre': "joshua", 'mensaje': 'pruebas'}
            ]);
          }),
    );
  }
}
