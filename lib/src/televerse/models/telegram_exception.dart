part of televerse.models;

/// HttpException is thrown when the HTTP request fails.
class TelegramException implements Exception {
  /// The HTTP status code.
  final int code;

  /// Optional description.
  final String? description;

  /// Stack trace of the exception.
  final StackTrace stackTrace;

  /// Constructs a new [TelegramException].
  TelegramException(
    this.code, {
    this.description,
    this.parameters,
    StackTrace? stackTrace,
  }) : stackTrace = stackTrace ?? StackTrace.current;

  /// Constructs a new [TelegramException] from a JSON object.
  factory TelegramException.fromJson(Map<String, dynamic> json) {
    return TelegramException(
      json['error_code'],
      description: json['description'],
      parameters: json['parameters'] != null
          ? ResponseParameters.fromJson(json['parameters'])
          : null,
    );
  }

  /// Response Parameters
  ResponseParameters? parameters;

  /// Returns a string representation of the exception.
  @override
  String toString() {
    return "TelegramException [$code]: ${description != null ? '\n($description)' : ''}";
  }

  /// Returns true if the exception is a client exception.
  bool get isClientException => code >= 400 && code < 500;

  /// Returns true if the exception is a server exception.
  bool get isServerExeption => code >= 500 && code < 600;

  /// Converts this exception to a [LongPollingException].
  LongPollingException toLongPollingException(StackTrace stackTrace) {
    return LongPollingException(
      description ?? "Unknown error occurred",
      code: code,
      parameters: parameters,
      stackTrace: stackTrace,
    );
  }
}

/// Bad Request Exception is thrown when the request is invalid.
class BadRequestException extends TelegramException {
  /// Constructs a new [BadRequestException]. The [message] is the error message.
  BadRequestException(
    String message, {
    ResponseParameters? parameters,
  }) : super(400, description: message, parameters: parameters);
}

/// This exception is thrown when the bot token is invalid.
class UnauthorizedException extends TelegramException {
  /// Constructs a new [UnauthorizedException].
  UnauthorizedException()
      : super(
          401,
          description:
              "This exception is thrown when the bot token is invalid.",
        );
}
