package com.yezi.cs

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine;

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        ExtStoragePlugin.registerWith(flutterEngine.dartExecutor.binaryMessenger, contentResolver)
    }
}
