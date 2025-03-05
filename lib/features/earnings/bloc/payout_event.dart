abstract class PayoutEvent {}

class FetchPayoutHistory extends PayoutEvent {
  final String userId;

  FetchPayoutHistory({required this.userId});
}
