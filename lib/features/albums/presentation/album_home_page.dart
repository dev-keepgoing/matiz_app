import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matiz/app/widgets/shimmer_list_view.dart';
import '../bloc/album_bloc.dart';
import '../bloc/album_event.dart';
import '../bloc/album_state.dart';
import '../widgets/album_list_view.dart';

class AlbumHomePage extends StatefulWidget {
  final bool isAuthenticated;

  const AlbumHomePage({super.key, this.isAuthenticated = false});

  @override
  _AlbumHomePageState createState() => _AlbumHomePageState();
}

class _AlbumHomePageState extends State<AlbumHomePage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final List<String> filters = ['ALBUMs', 'EPs', 'SINGLES'];
  String selectedFilter = 'ALBUMs';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Fetch initial data
    _fetchAlbums();
  }

  void _fetchAlbums() {
    final type = selectedFilter.toLowerCase(); // Map filters to types
    context.read<AlbumBloc>().add(FetchAlbums(type: 'posters', subtype: type));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        // Filters Row
        const SizedBox(height: 12.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((filter) {
              final isSelected = selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedFilter = filter;
                    });
                    _fetchAlbums(); // Fetch data when filter changes
                    _scrollController.animateTo(
                      0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
        // Filtered Content
        Expanded(
          child: BlocBuilder<AlbumBloc, AlbumState>(
            builder: (context, state) {
              if (state is AlbumLoading) {
                return const ShimmerListView();
              } else if (state is AlbumLoaded) {
                return AlbumListView(
                    items: state.albums,
                    scrollController: _scrollController,
                    isAuthenticated: widget.isAuthenticated);
              } else if (state is AlbumNotFound) {
                return Column(children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Text(
                    "PRONTO AÑADIREMOS MÁS PÓSTERS",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                ]);
              } else if (state is AlbumError) {
                return Center(child: Text("Error: ${state.error}"));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
