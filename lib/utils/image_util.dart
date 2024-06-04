import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/utils/notification_bloc.dart';

openCamera() {
  var imagePicker = ImagePicker();
  imagePicker.pickImage(source: ImageSource.camera).then((imageFile) {
    if (imageFile != null) {
      // 处理拍摄的照片
      editImage(imageFile);
    }
  });
}

openGallery() {
  var imagePicker = ImagePicker();
  imagePicker.pickImage(source: ImageSource.gallery).then((imageFile) {
    if (imageFile != null) {
      // 处理从相册选择的图片
      editImage(imageFile);
    }
  });
}

editImage(XFile pickedFile) async {
  final croppedFile = await ImageCropper().cropImage(
    maxHeight: 50,
    maxWidth: 50,
    cropStyle: CropStyle.circle,
    sourcePath: pickedFile != null ? pickedFile!.path : '',
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
    ],
    androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false),
    iosUiSettings: IOSUiSettings(
      title: 'Cropper',
    ),
  );
  if (croppedFile != null) {
    saveImageToSandbox(croppedFile!);
  }
}

Future<void> saveImageToSandbox(File imageFile) async {
  final directory = await getApplicationDocumentsDirectory();
  final imagePath = '${directory.path}/user.png';
  await imageFile.copy(imagePath);
  EventBus().sendEvent(kUpdateAvatar);
  print('Image saved to sandbox at $imagePath');
}
