import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matiz/features/earnings/bloc/payout_event.dart';
import 'package:matiz/features/earnings/bloc/payout_state.dart';
import 'package:matiz/features/earnings/data/repositories/payout_repository.dart';

class PayoutBloc extends Bloc<PayoutEvent, PayoutState> {
  final PayoutRepository payoutRepository;

  PayoutBloc({required this.payoutRepository}) : super(PayoutInitial()) {
    on<FetchPayoutHistory>(_onFetchPayoutHistory);
  }

  Future<void> _onFetchPayoutHistory(
      FetchPayoutHistory event, Emitter<PayoutState> emit) async {
    emit(PayoutLoading());

    try {
      final response = await payoutRepository.fetchPayoutHistory(event.userId);
      emit(PayoutLoaded(payoutHistory: response.data));
    } catch (e) {
      emit(PayoutError(error: e.toString()));
    }
  }
}
