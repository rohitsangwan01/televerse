part of televerse.models;

/// This class is used to represent a file to be sent.
///
/// Currently we have three ways to send a file:
/// 1. Use the file id.
/// 2. Use the file path.
/// 3. Use the file url.
///
/// The [InputFile] class has three separate constructors for each of these methods.
/// - [InputFile.fromFileId]
/// - [InputFile.fromFile]
/// - [InputFile.fromUrl]
///
/// For example, if you want to send a file using the file id, you can use the [InputFile.fromFileId] constructor.
/// ```dart
/// // Simply create an InputFile using the file id.
/// var photo = InputFile.fromFileId('file_id');
///
/// // Then pass the InputFile to the method that requires a file.
/// bot.sendPhoto(chatId, photo);
/// ```
class InputFile {
  /// Unique identifier for this file
  final String? fileId;

  /// File path. Use either this field or fileId to specify a file.
  final io.File? file;

  /// URL of the file to be sent. Use either this field or fileId to specify a file.
  final Uri? url;

  /// Creates a new [InputFile].
  InputFile({
    this.fileId,
    this.file,
    this.url,
  }) {
    if (fileId == null && file == null && url == null) {
      throw TeleverseException(
        'InputFile must be initialized with a value. Use either fileId, file, or url.\n\nYou can use [InputFile.fromFileId], [InputFile.fromFile], or [InputFile.fromUrl] to create an InputFile.',
      );
    }
  }

  /// Creates a new [InputFile] using a local file.
  factory InputFile.fromFile(io.File file) => InputFile(file: file);

  /// Creates a new [InputFile] using the file url.
  factory InputFile.fromUrl(String url) => InputFile(url: Uri.parse(url));

  /// Creates a new [InputFile] using the File ID on the Telegram Servers.
  factory InputFile.fromFileId(String fileId) => InputFile(fileId: fileId);

  /// Returns the type of the [InputFile].
  InputFileType get type {
    if (fileId != null) {
      return InputFileType.fileId;
    } else if (file != null) {
      return InputFileType.file;
    } else if (url != null) {
      return InputFileType.url;
    } else {
      throw TeleverseException('InputFile must have a value');
    }
  }

  /// Returns the file name of the [InputFile].
  String toJson() {
    switch (type) {
      case InputFileType.fileId:
        return fileId!;
      case InputFileType.file:
        return "attach://${file!.filename}";
      case InputFileType.url:
        return url!.toString();
    }
  }
}
