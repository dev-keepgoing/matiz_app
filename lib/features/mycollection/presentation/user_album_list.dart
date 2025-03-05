import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matiz/app/widgets/shimmer_list_view.dart';
import 'package:matiz/app/widgets/shimmer_single.dart';
import 'package:matiz/features/albums/data/models/album_model.dart';
import 'package:matiz/features/authentication/bloc/authentication_bloc.dart';
import 'package:matiz/features/authentication/bloc/authentication_state.dart';
import 'package:matiz/features/mycollection/bloc/achievement_bloc.dart';
import 'package:matiz/features/mycollection/bloc/achievement_event.dart';
import 'package:matiz/features/mycollection/bloc/achievement_state.dart';
import 'package:matiz/features/mycollection/widgets/achievement_bar.dart';
import 'package:matiz/app/widgets/album_card.dart';
import 'package:matiz/features/mycollection/bloc/collection_bloc.dart';
import 'package:matiz/features/mycollection/bloc/collection_event.dart';
import 'package:matiz/features/mycollection/bloc/collection_state.dart';
import 'package:matiz/features/mycollection/widgets/floating_action_menu.dart';
import 'package:matiz/utils/url_launcher_helper.dart';

class UserAlbumList extends StatefulWidget {
  const UserAlbumList({super.key});

  @override
  State<UserAlbumList> createState() => _UserAlbumListState();
}

class _UserAlbumListState extends State<UserAlbumList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state is AuthenticationAuthenticated) {
        final userData = state.userData;
        context.read<CollectionBloc>().add(FetchCollection());
        context.read<AchievementBloc>().add(FetchAchievements(
            userId: userData.uid, userType: userData.type, season: 1));
      }

      return Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 7),
            BlocBuilder<AchievementBloc, AchievementState>(
              builder: (context, state) {
                if (state is AchievementLoading) {
                  return ShimmerSingle(height: 70, radious: 0.0);
                } else if (state is AchievementLoaded) {
                  return AchievementBar(
                    label: state.achievementData.reward?.title,
                    progress: state.achievementData.completedCount /
                        state.achievementData.totalAchievements,
                    totalAchievements: state.achievementData.totalAchievements,
                    achievements: state.achievementData.achievements,
                    rewardDescription:
                        state.achievementData.reward?.description,
                  );
                } else {
                  return const Center(
                      child: Text('No achievements available.'));
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<CollectionBloc, CollectionState>(
                builder: (context, state) {
                  if (state is CollectionLoading) {
                    return const ShimmerListView();
                  } else if (state is CollectionError) {
                    return _buildErrorMessage(context);
                  } else if (state is CollectionLoaded) {
                    return _buildCollectionList(state);
                  } else {
                    return const Center(
                        child: Text('No collection available.'));
                  }
                },
              ),
            ),
          ],
        ),

        // 🔥 **Floating Action Menu Here**
        floatingActionButton: const FloatingActionMenu(),
      );
    });
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Center(
          child: Text(
            'EMPIEZA A CREAR TU COLECCIÓN VISITANDO EL SHOP',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 25),
        ElevatedButton(
          onPressed: () =>
              UrlLauncherHelper.openUrl('https://matizposters.com/'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          child: const Text('OBTÉN TU PRIMER POSTER'),
        ),
      ],
    );
  }

  Widget _buildCollectionList(CollectionLoaded state) {
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: state.collection.length,
      itemBuilder: (context, index) {
        return AlbumCard(
            album: Album(
                title: state.collection[index].title,
                price: 0.0,
                image: state.collection[index].image,
                shopifyUrl: '',
                validation: "completed",
                subtitle: state.collection[index].subtitle,
                id: ''),
            isUserLoggedin: true);
      },
    );
  }
}
