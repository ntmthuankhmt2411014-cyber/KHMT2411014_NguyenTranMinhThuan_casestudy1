import 'package:flutter/material.dart';

class UserProfile {
  final String name;
  final String email;

  const UserProfile({required this.name, required this.email});
}

class ProfileMenuItem {
  final String title;
  final IconData icon;
  final bool isDanger; // true -> hiển thị màu đỏ (Đăng xuất)

  const ProfileMenuItem({
    required this.title,
    required this.icon,
    this.isDanger = false,
  });
}

const UserProfile defaultProfile = UserProfile(
  name: 'Nguyễn Văn A',
  email: 'nguyenvana@example.com',
);

const List<ProfileMenuItem> profileMenuItems = [
  ProfileMenuItem(title: 'Thông tin cá nhân', icon: Icons.person_outline),
  ProfileMenuItem(title: 'Cài đặt ngân sách', icon: Icons.settings_outlined),
  ProfileMenuItem(title: 'Danh mục chi tiêu', icon: Icons.view_list_outlined),
  ProfileMenuItem(title: 'Sao lưu dữ liệu', icon: Icons.cloud_upload_outlined),
  ProfileMenuItem(title: 'Đổi mật khẩu', icon: Icons.lock_outline),
  ProfileMenuItem(title: 'Đăng xuất', icon: Icons.logout, isDanger: true),
];