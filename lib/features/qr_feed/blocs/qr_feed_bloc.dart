import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/features/qr_feed/events/qr_feed_event.dart';
import 'package:vierqr/features/qr_feed/states/qr_feed_state.dart';

class QrFeedBloc extends Bloc<QrFeedEvent, QrFeedState> {
  QrFeedBloc() : super(QrFeedState()) {}
}
