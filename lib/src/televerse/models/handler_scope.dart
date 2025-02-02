part of televerse.models;

/// A Handler Scope is used to define the scope and related information of a handler method.
class HandlerScope<T extends Function> {
  /// Whether the handler is a special handler.
  final bool special;

  /// If it's a command handler, we might check for /start command and set `startParameter` to the parameter of the command.
  final bool isCommand;

  /// If it's a RegExp handler, we'll set the `MessageContext.matches` to the matches of the RegExp.
  final bool isRegExp;

  /// The RegExp pattern.
  final RegExp? pattern;

  /// Handler
  final T handler;

  /// The update type
  final List<UpdateType> types;

  /// Predicate to filter updates
  final bool Function(Context ctx) predicate;

  /// Creates a new [HandlerScope].
  const HandlerScope({
    required this.handler,
    required this.predicate,
    required this.types,
    this.isCommand = false,
    this.isRegExp = false,
    this.pattern,
  }) : special = isCommand || isRegExp;

  /// Creates a new Context object for the specified update.
  Context context(Televerse t, Update update) {
    switch (update.type) {
      case UpdateType.message:
        return MessageContext(t, update.message!, update: update);
      case UpdateType.editedMessage:
        return MessageContext(t, update.editedMessage!, update: update);
      case UpdateType.channelPost:
        return MessageContext(t, update.channelPost!, update: update);

      case UpdateType.editedChannelPost:
        return MessageContext(t, update.editedChannelPost!, update: update);

      case UpdateType.inlineQuery:
        return InlineQueryContext(t, update: update);

      case UpdateType.chosenInlineResult:
        return ChosenInlineResultContext(t, update: update);

      case UpdateType.callbackQuery:
        return CallbackQueryContext(t, update: update);

      case UpdateType.shippingQuery:
        return ShippingQueryContext(t, update: update);

      case UpdateType.preCheckoutQuery:
        return PreCheckoutQueryContext(t, update: update);

      case UpdateType.poll:
        return PollContext(t, update: update);

      case UpdateType.pollAnswer:
        return PollAnswerContext(t, update: update);

      case UpdateType.myChatMember:
        return ChatMemberUpdatedContext(t, update: update);

      case UpdateType.chatMember:
        return ChatMemberUpdatedContext(t, update: update);

      case UpdateType.chatJoinRequest:
        return ChatJoinRequestContext(t, update: update);

      case UpdateType.unknown:
        return Context(t, update: update);
    }
  }
}
