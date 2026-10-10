import 'package:flutter/material.dart';

import '../models/profile_model.dart';

/// Màn hình "Cá nhân": thông tin người dùng và danh sách chức năng.
/// Các chức năng hiện chỉ hiển thị thông báo, chưa có xử lý thật.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cá nhân',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildUserInfo(),
          const SizedBox(height: 24),
          const Divider(height: 1),
          for (final item in profileMenuItems) ...[
            _buildMenuItem(context, item),
            const Divider(height: 1),
          ],
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 42,
          backgroundColor: Color(0xFFBFD4FA),
          child: Icon(Icons.person, size: 52, color: Colors.white),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                defaultProfile.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                defaultProfile.email,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF667085),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, ProfileMenuItem item) {
    final Color color =
    item.isDanger ? const Color(0xFFE53935) : const Color(0xFF1B2B4B);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      leading: Icon(item.icon, color: color),
      title: Text(
        item.title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: color.withOpacity(0.6)),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${item.title}" đang được phát triển')),
        );
      },
    );
  }
}