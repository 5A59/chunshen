import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:permission_handler/permission_handler.dart';

class ZipUtils {
  ///解压
  static Future<bool> unZip(String zipFilePath, String targetPath) async {
    if (!File(zipFilePath).existsSync()) {
      return false;
    }
    var status = await Permission.storage.request();
    if (status.isDenied) {
      return false;
    }

    // 从磁盘读取Zip文件。
    List<int> bytes = File(zipFilePath).readAsBytesSync();
    // 解码Zip文件
    Archive archive = ZipDecoder().decodeBytes(bytes);

    // 将Zip存档的内容解压缩到磁盘。
    for (ArchiveFile file in archive) {
      if (file.isFile) {
        List<int> data = file.content;
        File(targetPath + "/" + file.name)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(targetPath + "/" + file.name)..create(recursive: true);
      }
    }
    return true;
  }

  ///压缩
  static Future<bool> zip(String path, String targetPath) async {
    String directory = path;
    if (!Directory(directory).existsSync()) {
      return false;
    }
    var status = await Permission.storage.request();
    if (status.isDenied) {
      return false;
    }
    Permission.manageExternalStorage.request();
    // Zip a directory to out.zip using the zipDirectory convenience method
    //使用zipDirectory方法将目录压缩到xxx.zip
    var encoder = ZipFileEncoder();
    encoder.zipDirectory(Directory(directory), filename: targetPath);
    return true;
  }
}
