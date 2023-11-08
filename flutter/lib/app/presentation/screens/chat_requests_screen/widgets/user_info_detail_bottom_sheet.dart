import 'package:flutter/material.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/app/presentation/widgets/profile_detail_column.dart';

class UserInfoDetailBottomSheet extends StatelessWidget {
  final VoidCallback onAcceptButtonTap;
  final User user;

  const UserInfoDetailBottomSheet(
      {Key? key, required this.onAcceptButtonTap, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProfileDetailColumn(user: user),
            MainButton(
              mainButtonType: MainButtonType.key,
              text: '채팅 요청 수락하기',
              onPressed: onAcceptButtonTap,
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom / 2),
          ],
        ),
      ),
    );
  }
}
