part of models;

/// Represents a join request sent to a chat.
class ChatJoinRequest {
  /// Chat to which the request was sent
  final Chat chat;

  /// User that sent the join request
  final User user;

  /// Date the request was sent in Unix time
  ///
  /// You can use the [dateTime] getter to get a [DateTime] object
  final int date;

  /// Optional. Bio of the user.
  final String? bio;

  /// Optional. Chat invite link that was used by the user to send the join request
  final ChatInviteLink? inviteLink;

  /// Since Bot API 6.5
  ///
  /// Identifier of a private chat with the user who sent the join request. This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a 64-bit integer or double-precision float type are safe for storing this identifier. The bot can use this identifier for 24 hours to send messages until the join request is processed, assuming no other administrator contacted the user.
  final int userChatId;

  /// Creates a new [ChatJoinRequest] object.
  const ChatJoinRequest({
    required this.chat,
    required this.user,
    required this.date,
    this.bio,
    this.inviteLink,
    required this.userChatId,
  });

  /// Creates a new [ChatJoinRequest] object from json.
  factory ChatJoinRequest.fromJson(Map<String, dynamic> json) {
    return ChatJoinRequest(
      chat: Chat.fromJson(json['chat']),
      user: User.fromJson(json['user']),
      date: json['date'],
      bio: json['bio'],
      inviteLink: json['invite_link'] == null
          ? null
          : ChatInviteLink.fromJson(json['invite_link']),
      userChatId: json['user_chat_id'],
    );
  }

  /// Converts a [ChatJoinRequest] to a [Map] for JSON encoding.
  Map<String, dynamic> toJson() {
    return {
      'chat': chat.toJson(),
      'user': user.toJson(),
      'date': date,
      'bio': bio,
      'invite_link': inviteLink?.toJson(),
      'user_chat_id': userChatId,
    }..removeWhere((key, value) => value == null);
  }

  /// Returns a [DateTime] object representing the [date] field
  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(date * 1000);
}
