part of models;

/// Represents a Game.
class InlineQueryResultGame extends InlineQueryResult {
  /// Type of the result, must be [InlineQueryResultType.game]
  @override
  InlineQueryResultType get type => InlineQueryResultType.game;

  /// Short name of the game
  String gameShortName;

  /// Optional. Inline keyboard attached to the message
  InlineKeyboardMarkup? replyMarkup;

  /// Constructs an [InlineQueryResultGame] object
  InlineQueryResultGame({
    required this.gameShortName,
    required String id,
    this.replyMarkup,
  }) : super(id: id);

  /// Converts an [InlineQueryResultGame] object to a JSON map
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'id': id,
      'game_short_name': gameShortName,
      'reply_markup': replyMarkup?.toJson(),
    }..removeWhere((key, value) => value == null);
  }

  /// Constructs an [InlineQueryResultGame] object from a JSON map
  factory InlineQueryResultGame.fromJson(Map<String, dynamic> json) {
    return InlineQueryResultGame(
      gameShortName: json['game_short_name'] as String,
      id: json['id'] as String,
      replyMarkup: json['reply_markup'] == null
          ? null
          : InlineKeyboardMarkup.fromJson(
              json['reply_markup'] as Map<String, dynamic>),
    );
  }
}
