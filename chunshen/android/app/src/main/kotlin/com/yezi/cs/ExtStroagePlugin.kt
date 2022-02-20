package com.yezi.cs;

import android.content.ContentResolver
import android.content.ContentValues
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.io.OutputStream


class ExtStoragePlugin : MethodCallHandler {
    private var contentResolver: ContentResolver? = null

    constructor(contentResolver: ContentResolver) {
        this.contentResolver = contentResolver;
    }

    companion object {
        @JvmStatic
        fun registerWith(binaryMessenger: BinaryMessenger, contentResolver: ContentResolver) {
            MethodChannel(binaryMessenger, "ext_storage").setMethodCallHandler(ExtStoragePlugin(contentResolver));
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getExternalStorageDirectory" ->
                result.success(Environment.getExternalStorageDirectory().toString());
            "getExternalStoragePublicDirectory" -> {
                val type = call.argument<String>("type")
                result.success(Environment.getExternalStoragePublicDirectory(type).toString());
            }
            "writeToDownload" -> {
                val path = call.argument<String>("path")
                val name = call.argument<String>("name")
                val type = call.argument<String>("type")
                var res = ""
                if (path != null && name != null && type != null) {
                    res = writeToDownload(path, name, type)
                }
                result.success(res)
            }
            else -> result.notImplemented()
        }
    }

    private fun writeToDownload(path: String, name: String, type: String): String {
        var res = ""
        val values = ContentValues()
        values.put(MediaStore.MediaColumns.DISPLAY_NAME, name)
        values.put(MediaStore.MediaColumns.MIME_TYPE, type)

        val outPath = Environment.DIRECTORY_DOWNLOADS
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            values.put(MediaStore.MediaColumns.RELATIVE_PATH, outPath)
        }
        var outputStream: OutputStream? = null
        var uri: Uri? = contentResolver?.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
                ?: return ""
        try {
            outputStream = contentResolver?.openOutputStream(uri!!)
            val inputStream = File(path).inputStream()
            outputStream?.use { out ->
                inputStream.copyTo(out)
            }
            outputStream?.flush()
            outputStream?.close()

            val proj = arrayOf(MediaStore.Images.Media.DATA)
            val cursor = contentResolver?.query(uri!!, proj, null, null, null)
            val columnIndex: Int? = cursor?.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
            cursor?.moveToFirst()
            columnIndex?.let {
                res = cursor.getString(it)
            }
        } catch (e: Exception) {
            res = ""
        } finally {
            outputStream?.close()
        }
        return res
    }
}