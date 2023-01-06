import 'package:assignment_3/Home.dart';
import 'package:flutter/material.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(
        const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SqliteApp()
        )
    );
}