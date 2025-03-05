import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';
import '../data/repositories/transaction_repository.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository transactionRepository;

  TransactionBloc({required this.transactionRepository})
      : super(TransactionInitial()) {
    on<FetchTransactions>(_onFetchTransactions);
  }

  Future<void> _onFetchTransactions(
      FetchTransactions event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      final response = await transactionRepository.fetchTransactions();

      if (response.success) {
        emit(TransactionLoaded(
            transactions: response.data ?? [])); // ✅ Extract data correctly
      } else {
        emit(TransactionError(
            error: response.message ??
                'SOMETHING WENT WRONG RETRIEVING THE TRANSACTIONS.'));
      }
    } catch (e) {
      emit(TransactionError(error: e.toString()));
    }
  }
}
