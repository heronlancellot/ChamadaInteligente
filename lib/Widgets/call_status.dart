import 'package:flutter/material.dart';

class CardCallStatusApp extends StatelessWidget {
  const CardCallStatusApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return cardCallStatus();
  }
}

Widget cardCallStatus() {
  return Center(
    child: Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.cached),
            title: Text('Chamada em aberto'),
            subtitle: Text('Confirme sua presença'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Confirmar Presença'),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    ),
  );
}
