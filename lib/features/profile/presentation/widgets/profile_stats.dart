import 'package:flutter/material.dart';

import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    final postCount = context.select((ProfileBloc bloc) {
      final state = bloc.state;
      if (state is ProfileLoaded) return state.postCount;
      return 0;
    });

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('$postCount', 'POSTS'),
          _buildStatItem('22K', 'FOLLOWERS'),
          _buildStatItem('1250', 'FOLLOWING'),
          _buildStatItem('4', 'WINS'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
