part of televerse.fetch;

/// A class that handles long polling.
/// This class is used to fetch updates from the Telegram API. It uses the long polling method.
class LongPolling extends Fetcher {
  /// Delay time between each long polling request.
  final Duration delayDuration;

  /// The offset of the next update to fetch.
  int offset;

  /// The timeout of the long polling request.
  final int timeout;

  /// The maximum number of updates to fetch.
  final int limit;

  /// A list of update types to fetch.
  final List<UpdateType> allowedUpdates;

  /// The maximum timeout allowed by the Telegram API.
  static const int maxTimeout = 50;

  /// Status of the long polling, true if it is polling, false otherwise.
  bool _isPolling = false;

  /// Returns the status of the long polling.
  bool get isPolling => _isPolling;

  /// Constructs a new [LongPolling] object.
  ///
  /// The timeout must be between 0 and 50 seconds. The limit must be between 1 and 100.
  LongPolling({
    this.offset = 0,
    this.timeout = 30,
    this.limit = 100,
    this.allowedUpdates = const [],
    this.delayDuration = const Duration(milliseconds: 200),
  }) {
    if (timeout > maxTimeout) throw LongPollingException.invalidTimeout;
    if (limit > 100) throw LongPollingException.invalidLimit;
  }

  /// Retry delay for long polling.
  Duration _retryDelay = Duration(seconds: 1);

  /// Doubles the retry delay.
  void _doubleRetryDelay() {
    _retryDelay *= 2;
    print(
      "We are doubling the retry delay to ${_retryDelay.inSeconds} seconds",
    );
  }

  /// Resets the retry delay to 1 second.
  void _resetRetryDelay() {
    _retryDelay = Duration(seconds: 1);
  }

  /// Starts the long polling.
  @override
  Future<void> start() async {
    if (_isPolling) throw LongPollingException.alreadyPolling;
    _isPolling = true;
    while (_isPolling) {
      await _poll();
    }
  }

  /// Stops the long polling.
  @override
  Future<void> stop() async {
    _isPolling = false;
    _updateStreamController.close();
  }

  /// Polls the Telegram API for updates.
  Future<void> _poll() async {
    if (!_isPolling) return;
    try {
      final updates = await api.getUpdates(
        offset: offset,
        limit: limit,
        timeout: timeout,
        allowedUpdates: allowedUpdates.map((e) => e.type).toList(),
      );
      for (var update in updates) {
        if (_updateStreamController.isClosed) {
          return;
        }
        addUpdate(update);
        offset = update.updateId + 1;
      }

      await Future.delayed(delayDuration);
      _resetRetryDelay();
    } catch (err, stackTrace) {
      _isPolling = false;
      if (err is TelegramException) {
        if (_onError != null) {
          final longError = err.toLongPollingException(stackTrace);
          await _onError!(longError, stackTrace);
        }
        if (err.parameters?.retryAfter != null) {
          print(
            'Polling will be resumed after ${err.parameters!.retryAfter!} seconds',
          );
          _retryDelay = Duration(seconds: err.parameters!.retryAfter!);
          await Future.delayed(_retryDelay);
          _isPolling = true;
        } else {
          _doubleRetryDelay();
        }
      } else {
        if (_onError != null) {
          await _onError!(err, stackTrace);
        } else {
          _doubleRetryDelay();
        }
        rethrow;
      }
    }
  }

  /// [LongPolling] with all updates allowed.
  static LongPolling allUpdates({
    int offset = 0,
    int timeout = 30,
    int limit = 100,
    Duration delayDuration = const Duration(milliseconds: 200),
  }) {
    List<UpdateType> allowedUpdates = [
      for (var type in UpdateType.values)
        if (type != UpdateType.unknown) type
    ];
    return LongPolling(
      allowedUpdates: allowedUpdates,
      offset: offset,
      timeout: timeout,
      limit: limit,
      delayDuration: delayDuration,
    );
  }
}
