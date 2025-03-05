import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:matiz/core/data/services/analytics_service.dart';
import 'package:matiz/features/authentication/bloc/authentication_bloc.dart';
import 'package:matiz/features/authentication/bloc/authentication_state.dart';
import 'package:matiz/features/earnings/bloc/fact_bloc.dart';
import 'package:matiz/features/earnings/bloc/fact_event.dart';
import 'package:matiz/features/earnings/bloc/payout_bloc.dart';
import 'package:matiz/features/earnings/bloc/payout_event.dart';
import 'package:matiz/features/earnings/bloc/payout_state.dart';
import 'package:matiz/features/earnings/data/models/monthly_earning.dart';
import 'package:matiz/features/earnings/data/repositories/fact_respository.dart';
import 'package:matiz/features/earnings/data/repositories/payout_repository.dart';
import 'package:matiz/features/earnings/widgets/balance_display.dart';
import 'package:matiz/features/earnings/widgets/earnings_chart.dart';
import 'package:matiz/features/earnings/widgets/payout_notice.dart';
import 'package:matiz/features/earnings/widgets/transaction_list_item.dart';
import 'package:matiz/utils/format_date.dart';
import 'package:matiz/utils/month_converter.dart';

class MyEarnings extends StatelessWidget {
  const MyEarnings({super.key});

  String _getUserId(BuildContext context) {
    final authState = context.read<AuthenticationBloc>().state;
    return authState is AuthenticationAuthenticated
        ? authState.userData.uid
        : "";
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PayoutBloc>(
          create: (context) => PayoutBloc(
            payoutRepository: context.read<PayoutRepository>(),
          )..add(FetchPayoutHistory(userId: _getUserId(context))),
        ),
        BlocProvider<FactBloc>(
          create: (context) => FactBloc(
            factRepository: context.read<FactRepository>(),
          )..add(FetchFacts()),
        ),
      ],
      child: const MyEarningsContent(),
    );
  }
}

class MyEarningsContent extends StatefulWidget {
  const MyEarningsContent({super.key});

  @override
  _MyEarningsContentState createState() => _MyEarningsContentState();
}

class _MyEarningsContentState extends State<MyEarningsContent> {
  List<MonthlyEarning> monthlyData = [];

  @override
  void initState() {
    super.initState();
    _logAnalyticsEvent();
    monthlyData = _generateEmptyMonthlyData();
  }

  // Method to log analytics event
  void _logAnalyticsEvent() {
    final authState = context.read<AuthenticationBloc>().state;
    if (authState is AuthenticationAuthenticated) {
      final userId = authState.userData.uid;
      AnalyticsService().logCheckEarnings(userId: userId);
    }
  }

  List<MonthlyEarning> _generateEmptyMonthlyData() {
    final List<MonthlyEarning> emptyData = [];
    final DateTime currentDate = DateTime.now();
    for (int i = 11; i >= 0; i--) {
      final DateTime monthDate =
          DateTime(currentDate.year, currentDate.month - i, 1);
      final String monthNumber = DateFormat('MM').format(monthDate);
      final String monthName = MonthConverter.convert(monthNumber);
      emptyData.add(MonthlyEarning(month: monthName, earnings: 0.0));
    }
    return emptyData;
  }

  void _updateMonthlyData(List<MonthlyEarning> newData) {
    setState(() {
      monthlyData = List.from(newData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is! AuthenticationAuthenticated) {
          return const Center(child: CircularProgressIndicator());
        }
        final userData = state.userData;
        final balance = userData.nextPayout?.amount ?? 0.0;
        final payoutDate = userData.nextPayout?.date ?? "";
        final artistTier =
            '\$${NumberFormat("#,##0.00", "en_US").format(userData.nextPayout?.tiered ?? 5)}';
        final posterAmount = userData.nextPayout?.posterAmount ?? 0;
        final formattedBalance =
            '\$${NumberFormat("#,##0.00", "en_US").format(balance)}';

        return Scaffold(
          body: SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(), // ✅ Ensures smooth scrolling
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24.0),
                    BalanceDisplay(balance: balance, currency: 'US DOLLAR'),
                    const SizedBox(height: 24.0),
                    PayoutNotice(
                      title: DateFormatHelper.formatDate(payoutDate),
                      description:
                          "INICIAREMOS EL DEPOSITO DE $formattedBalance A TU CUENTA DE BANCO.",
                    ),
                    const SizedBox(height: 24.0),
                    Text("LAS VENTAS",
                        style: Theme.of(context).textTheme.headlineLarge),
                    IntrinsicHeight(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                            child: PayoutNotice(
                          title: artistTier,
                          description: "GANAS POR POSTER",
                        )),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: PayoutNotice(
                          title: "$posterAmount",
                          description: "POSTERS VENDIDOS ESTE MES",
                        )),
                      ],
                    )),
                    const SizedBox(height: 24.0),
                    Text("HISTORIAL",
                        style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 10.0),
                    _buildEarningsChart(),
                    const SizedBox(height: 24.0),
                    // Text("LISTA DE COMPRAS",
                    //     style: Theme.of(context).textTheme.headlineSmall),
                    // const SizedBox(height: 10.0),
                    // SizedBox(
                    //   height: 500, // ✅ Allow enough height for scrolling
                    //   child: TransactionListScreen(),
                    // ),
                  ],
                )),
          ),
        );
      },
    );
  }

  Widget _buildEarningsChart() {
    return BlocListener<PayoutBloc, PayoutState>(
      listener: (context, payoutState) {
        if (payoutState is PayoutLoaded) {
          final newData = payoutState.payoutHistory.recentPayouts.map((payout) {
            final monthNumber = payout.month.substring(5, 7);
            final monthName = MonthConverter.convert(monthNumber);
            return MonthlyEarning(month: monthName, earnings: payout.amount);
          }).toList();
          _updateMonthlyData(newData);
        }
      },
      child: BlocBuilder<PayoutBloc, PayoutState>(
        builder: (context, payoutState) {
          return EarningsChart(monthlyData: monthlyData);
        },
      ),
    );
  }
}
