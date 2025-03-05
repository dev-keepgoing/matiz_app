import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matiz/features/authentication/bloc/authentication_bloc.dart';
import 'package:matiz/features/authentication/bloc/authentication_state.dart';
import 'package:matiz/features/authentication/presentation/login_screen.dart';
import 'package:matiz/features/albums/presentation/album_home_page.dart';
import 'package:matiz/features/authentication/widgets/auth_loading.dart';
import 'package:matiz/features/mycollection/presentation/user_album_list.dart';
import 'package:matiz/features/earnings/presentation/my_earnings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController? _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeTabController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 🛑 **Listen for Authentication State Changes**
    context.read<AuthenticationBloc>().stream.listen((state) {
      if (state is AuthenticationUnauthenticated) {
        _selectedIndex = 0;
        _initializeTabController(length: 2);
      }
    });
  }

  void _initializeTabController({int length = 2}) {
    _tabController = TabController(
      length: length,
      vsync: this,
      initialIndex: _selectedIndex,
    );

    _tabController?.addListener(() {
      if (_tabController!.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController!.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.black,
              duration: const Duration(seconds: 10),
            ),
          );
        }

        if (state is AuthenticationAuthenticated) {
          setState(() {
            _selectedIndex = 0;
          });
          _initializeTabController();
        }
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return Stack(
            children: [
              if (state is AuthenticationAuthenticated)
                _buildAuthenticatedUI(state),
              if (state is! AuthenticationAuthenticated)
                _buildUnauthenticatedUI(),
              if (state is AuthenticationLoading)
                const AuthenticationLoadingWidget(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAuthenticatedUI(AuthenticationAuthenticated state) {
    final userData = state.userData;
    final tabs = [
      if (userData.type == 'artist') const Tab(text: 'MIS GANANCIAS'),
      const Tab(text: 'LOS PÓSTERS'),
      const Tab(text: 'MI COLECCIÓN'),
    ];

    final tabViews = [
      if (userData.type == 'artist') MyEarnings(),
      const AlbumHomePage(isAuthenticated: true),
      UserAlbumList(),
    ];

    // 🔥 **Update TabController if the number of tabs has changed**
    if (_tabController?.length != tabs.length) {
      _initializeTabController(length: tabs.length);
    }

    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabViews,
      ),
    );
  }

  Widget _buildUnauthenticatedUI() {
    final tabs = const [
      Tab(text: 'LOS PÓSTERS'),
      Tab(text: 'LOG IN'),
    ];

    final tabViews = [
      const AlbumHomePage(isAuthenticated: false),
      const LoginScreen(),
    ];

    // 🔥 **Update TabController if the number of tabs has changed**
    if (_tabController?.length != tabs.length) {
      _initializeTabController(length: tabs.length);
    }

    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabViews,
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/matiz_black.png',
          height: 60,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
