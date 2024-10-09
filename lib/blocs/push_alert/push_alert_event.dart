part of 'push_alert_bloc.dart';

enum PushAlertType {
  success,
  error,
  warning,
  info,
}

class PushAlert {
  final String title;
  final String body;
  final PushAlertType type;
  final String? action;
  final String? actionUrl;
  final VoidCallback? onActionTap;

  const PushAlert({
    required this.title,
    required this.body,
    this.type = PushAlertType.info,
    this.action,
    this.actionUrl,
    this.onActionTap,
  });

  @override
  String toString() => 'PushAlert { title: $title, body: $body }';
}

sealed class PushAlertEvent extends Equatable {
  const PushAlertEvent();

  @override
  List<Object> get props => [];
}

sealed class PushAlertBasic extends PushAlertEvent {
  final String title;
  final String body;
  final PushAlertType type;

  const PushAlertBasic({
    required this.title,
    required this.body,
    required this.type,
  });

  @override
  List<Object> get props => [title, body];
}

final class PushAlertBasicSuccess extends PushAlertBasic {
  const PushAlertBasicSuccess({
    required super.title,
    required super.body,
  }) : super(
          type: PushAlertType.success,
        );
}

final class PushAlertBasicError extends PushAlertBasic {
  const PushAlertBasicError({
    required super.title,
    required super.body,
  }) : super(
          type: PushAlertType.error,
        );
}

final class PushAlertBasicWarning extends PushAlertBasic {
  const PushAlertBasicWarning({
    required super.title,
    required super.body,
  }) : super(
          type: PushAlertType.warning,
        );
}

final class PushAlertBasicInfo extends PushAlertBasic {
  const PushAlertBasicInfo({
    required super.title,
    required super.body,
  }) : super(
          type: PushAlertType.info,
        );
}

final class PushAlertCustom extends PushAlertEvent {
  final PushAlert pushAlert;

  const PushAlertCustom({
    required this.pushAlert,
  });

  @override
  List<Object> get props => [pushAlert];
}
