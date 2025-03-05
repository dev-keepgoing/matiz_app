import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matiz/app/widgets/dot_loading_indicator.dart';
import 'package:matiz/features/earnings/bloc/fact_bloc.dart';
import 'package:matiz/features/earnings/bloc/fact_state.dart';

class KnowledgeBaseWidget extends StatelessWidget {
  const KnowledgeBaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FactBloc, FactState>(
      builder: (context, state) {
        if (state is FactLoading) {
          return const Center(child: DotLoadingIndicator());
        } else if (state is FactLoaded) {
          if (state.facts.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: state.facts.map((fact) {
                return _buildFactSection(
                  context,
                  title: fact.title,
                  description: fact.description,
                );
              }).toList(),
            );
          } else {
            return const Center(child: Text("PRONTO AÑADIREMOS FACTS"));
          }
        } else {
          return const Center(child: Text("NO HAY FACTS DISPONIBLE"));
        }
      },
    );
  }

  Widget _buildFactSection(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8.0),
        Text(description, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8.0),
        Divider(color: Colors.grey[300], thickness: 1.0),
      ],
    );
  }
}
