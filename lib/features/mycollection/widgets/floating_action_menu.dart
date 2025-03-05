import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matiz/core/data/services/ml_service.dart';
import 'package:matiz/features/authentication/bloc/authentication_bloc.dart';
import 'package:matiz/features/authentication/bloc/authentication_event.dart';
import 'package:matiz/features/authentication/widgets/delete_acc_dialog.dart';

class FloatingActionMenu extends StatefulWidget {
  const FloatingActionMenu({super.key});

  @override
  _FloatingActionMenuState createState() => _FloatingActionMenuState();
}

class _FloatingActionMenuState extends State<FloatingActionMenu>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2), // Slide in from below
      end: Offset(0, -0.30),
    ).animate(_animationController);
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _logout() {
    _toggleMenu();
    context.read<AuthenticationBloc>().add(LogoutRequested());
  }

  void _deleteAccount() {
    _toggleMenu();
    showDeleteConfirmationDialog(
      context: context,
      onConfirm: () {
        context.read<AuthenticationBloc>().add(DeleteAccountRequested());
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Stack(
      alignment: Alignment.bottomRight,
      children: [
        // 🔥 FAB Overlay (Closes menu when tapping outside)
        if (_isExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleMenu,
              behavior: HitTestBehavior.opaque, // Capture outside taps
            ),
          ),

        // ✨ Small Option Buttons (Animated)
        SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildOption(Icons.exit_to_app, "CIERRA SESIÓN", _logout),
                const SizedBox(height: 10),
                _buildOption(Icons.delete, "BORRA CUENTA", _deleteAccount),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // 🎯 Main FAB
        FloatingActionButton(
          onPressed: _toggleMenu,
          backgroundColor: Colors.black,
          child: AnimatedRotation(
            turns: _isExpanded ? 0.125 : 0, // Rotates "+" into "×"
            duration: const Duration(milliseconds: 300),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    ));
  }

  /// 🛠 **Helper to Build Small Action Buttons**
  Widget _buildOption(IconData icon, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed, // ✅ Makes the entire row clickable
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 150, // Fixed width for uniform size
            height: 40, // Fixed height for uniform size
            alignment: Alignment.center, // Centers text inside container
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            heroTag: label, // Prevent duplicate hero tags
            mini: true,
            backgroundColor: Colors.black,
            onPressed: onPressed,
            child: Icon(icon, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
