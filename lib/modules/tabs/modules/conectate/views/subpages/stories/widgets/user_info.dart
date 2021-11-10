import 'package:flutter/material.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class UserInfo extends StatelessWidget {
  final Group user;

  const UserInfo({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Hero(
          tag: user.name,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            backgroundImage: ((user.image.isNotEmpty)
                    ? NetworkImage(user.image)
                    : AssetImage('assets/img/default-img.jpg'))
                as ImageProvider<Object>,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            user.name,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
              size: 30,
              color: Colors.white,
            ))
      ],
    );
  }
}
