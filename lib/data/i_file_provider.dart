import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';

abstract class IFileProvider {
  Future<File> selectFile({
    required BuildContext context,
    required String title,
    List<String>? allowedExtensions,
  });
}

class FileProvider implements IFileProvider {
  static IFileProvider? _instance;

  static IFileProvider getInstance() {
    if (_instance == null) {
      if (Platform.isAndroid) {
        _instance = _FilesystemPickerFileProvider();
        return _instance!;
      }
      _instance = _FilepeakerFileProvider();
    }
    return _instance!;
  }

  @override
  Future<File> selectFile({
    required BuildContext context,
    required String title,
    List<String>? allowedExtensions,
  }) async =>
      _instance!.selectFile(context: context, title: title);
}

class _FilepeakerFileProvider implements IFileProvider {
  @override
  Future<File> selectFile(
      {required BuildContext context,
      required String title,
      List<String>? allowedExtensions}) async {
    try {
      final f = await FilePicker.platform.pickFiles(
        dialogTitle: title,
        allowedExtensions: allowedExtensions,
        type: allowedExtensions == null ? FileType.any : FileType.custom,
      );
      if (f == null) throw Exception('No file selected');
      final filePath = f.files.first.path;
      if (filePath == null) throw Exception("Wrong file path");
      return File(filePath);
    } catch (e) {
      rethrow;
    }
  }
}

class _FilesystemPickerFileProvider implements IFileProvider {
  @override
  Future<File> selectFile({
    required BuildContext context,
    required String title,
    List<String>? allowedExtensions,
  }) async {
    final f = await FilesystemPicker.open(
      title: title,
      context: context,
      rootDirectory: Directory("storage/emulated/0"),
    );
    if (f == null) throw Exception('No file selected');
    return File(f);
  }
}
