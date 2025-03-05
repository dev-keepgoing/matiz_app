import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:matiz/app/themes/theme.dart';
import 'package:matiz/features/albums/data/repositories/album_repository.dart';
import 'package:matiz/features/earnings/bloc/transaction_bloc.dart';
import 'package:matiz/features/earnings/data/repositories/fact_respository.dart';
import 'package:matiz/features/earnings/data/repositories/transaction_repository.dart';
import 'package:matiz/features/home/presentation/home_page.dart';
import 'package:matiz/features/authentication/bloc/authentication_bloc.dart';
import 'package:matiz/features/authentication/bloc/authentication_event.dart';
import 'package:matiz/features/authentication/data/respositories/authentication_repository.dart';
import 'package:matiz/features/albums/bloc/album_bloc.dart';
import 'package:matiz/features/mycollection/bloc/achievement_bloc.dart';
import 'package:matiz/features/mycollection/bloc/collection_bloc.dart';
import 'package:matiz/features/mycollection/data/repositories/achievement_repository.dart';
import 'package:matiz/features/mycollection/data/repositories/collection_repository.dart';
import 'package:matiz/features/earnings/bloc/payout_bloc.dart';
import 'package:matiz/features/earnings/data/repositories/payout_repository.dart';
import 'package:matiz/features/validation/bloc/merch_validation_bloc.dart';
import 'package:matiz/features/validation/data/merch_validation_repository.dart';
import 'package:matiz/utils/format_date.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⏳ Keep splash for 3 seconds
  await Future.delayed(const Duration(seconds: 1));

  // 🚀 Remove splash manually
  FlutterNativeSplash.remove();

  DateFormatHelper.initialize();
  await Firebase.initializeApp(); // Initialize Firebase

  // Initialize repositories
  final authenticationRepository = AuthenticationRepository();
  final factRepository = FactRepository(
      baseUrl: 'https://getfunfacts-iphkbmmvja-uc.a.run.app',
      authenticationRepository: authenticationRepository);
  final albumRepository = AlbumRepository(
      baseUrl: 'https://getmerch-iphkbmmvja-uc.a.run.app',
      authenticationRepository: authenticationRepository);
  final collectionRepository = CollectionRepository(
    baseUrl: "https://getcollection-iphkbmmvja-uc.a.run.app",
    authenticationRepository: authenticationRepository,
  );
  final payoutRepository = PayoutRepository(
    baseUrl: "https://getpayouthistory-iphkbmmvja-uc.a.run.app",
    authenticationRepository: authenticationRepository,
  );
  final achievementRepository = AchievementRepository(
    baseUrl: "https://getuserachievementsstatus-iphkbmmvja-uc.a.run.app",
    authenticationRepository: authenticationRepository,
  );
  final merchValidationRepository = MerchValidationRepository(
    baseUrl: "https://validatemerch-iphkbmmvja-uc.a.run.app",
    authenticationRepository: authenticationRepository,
  );
  final transactionRepository = TransactionRepository(
    baseUrl: "https://gettransactions-iphkbmmvja-uc.a.run.app",
    authenticationRepository: authenticationRepository,
  );

  runApp(
    MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (_) => authenticationRepository),
          RepositoryProvider(create: (_) => albumRepository),
          RepositoryProvider(create: (_) => collectionRepository),
          RepositoryProvider(create: (_) => payoutRepository),
          RepositoryProvider(create: (_) => factRepository),
          RepositoryProvider(create: (_) => achievementRepository),
          RepositoryProvider(create: (_) => merchValidationRepository),
          RepositoryProvider(create: (_) => transactionRepository),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  TransactionBloc(transactionRepository: transactionRepository),
            ),
            // AuthenticationBloc to manage authentication state
            BlocProvider(
              create: (_) => AuthenticationBloc(
                authenticationRepository: authenticationRepository,
              )..add(AppStarted()),
            ),
            // AlbumBloc to manage album-related state
            BlocProvider(
              create: (_) => AlbumBloc(
                albumRepository: albumRepository,
              ),
            ),
            // CollectionBloc to manage user's collection state
            BlocProvider(
              create: (_) => CollectionBloc(
                collectionRepository: collectionRepository,
              ),
            ),
            // PayoutBloc to manage earnings and payout history
            BlocProvider(
              create: (_) => PayoutBloc(
                payoutRepository: payoutRepository,
              ),
            ),
            // AchievementBloc to manage achievement progress
            BlocProvider(
              create: (_) => AchievementBloc(
                achievementRepository: achievementRepository,
              ),
            ),
            BlocProvider(
              create: (_) => MerchValidationBloc(
                repository: merchValidationRepository,
              ),
            ),
          ],
          child: const AlbumApp(),
        )),
  );
}

class AlbumApp extends StatelessWidget {
  const AlbumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'matiz',
      theme: AppTheme.lightTheme, // Apply the light theme
      themeMode: ThemeMode.light, // Change to ThemeMode.dark for dark theme
      home: const HomePage(),
    );
  }
}
