// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:file_picker/file_picker.dart';

/// Pick a file from the device without platform-specific permission handling.
Future<PlatformFile?> pickFile({FileType type = FileType.any}) async {
  return await FilePicker.pickFile(type: type, compressionQuality: 0);
}
