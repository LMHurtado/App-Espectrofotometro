import 'package:flutter/material.dart';

void main() {
  runApp(const agua_lw());
}

// ignore: camel_case_types
class agua_lw extends StatefulWidget {
  const agua_lw({super.key});

  @override
  State<agua_lw> createState() => _agua_lwState();
}

// ignore: camel_case_types
class _agua_lwState extends State<agua_lw> {
  int clickCounter = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.orange),

      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Vamos bien")),
          leading: IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                clickCounter = 0;
              });
            },
          ),
        ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                clickCounter.toString(),
                style: TextStyle(fontSize: 100, fontWeight: FontWeight.w500),
              ),
              Text(
                clickCounter == 1
                    ? "$clickCounter click" // singular
                    : "$clickCounter clicks", // plural
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: const StadiumBorder(),
          onPressed: () {
            setState(() {
              clickCounter += 1;
            });
          },
          child: const Icon(Icons.plus_one),
        ),
      ),
    );
  }
}
