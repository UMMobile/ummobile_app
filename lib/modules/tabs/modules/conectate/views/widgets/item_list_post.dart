import 'package:flutter/material.dart';
import 'package:ummobile/modules/tabs/modules/conectate/utils/action_post.dart';

/// * Card for the individual post inside the list
class ItemListPost extends StatelessWidget {
  final String cardTitle;
  final String url;
  final String imagePath;

  const ItemListPost(
      {Key? key,
      required this.cardTitle,
      required this.imagePath,
      required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: EdgeInsets.only(right: 20.0),
      child: InkWell(
        onTap: () {
          actionPost(url, imagePath, context);
        },
        //borderRadius: BorderRadius.all(Radius.circular(20.0)),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              FadeInImage.assetNetwork(
                placeholder: 'assets/img/default-img.jpg',
                image: imagePath,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, object, stacktrace) => Image.asset(
                  "assets/img/default-img.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  shape: BoxShape.rectangle,
                  gradient: LinearGradient(
                    end: const Alignment(0.0, -0.8),
                    begin: const Alignment(0.0, 0.8),
                    colors: <Color>[Colors.black, Colors.transparent],
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 12.0, left: 5.0, right: 5.0),
                  child: Text(
                    cardTitle,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Stack(
//           children: <Widget>[
//             /// * Post image
//             Container(
//               foregroundDecoration: BoxDecoration(
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: ((imagePath.isNotEmpty)
//                           ? NetworkImage(imagePath)
//                           : AssetImage('assets/img/default-img.jpg'))
//                       as ImageProvider<Object>,
//                 ),
//                 borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                 shape: BoxShape.rectangle,
//               ),
//             ),

//             /// * Post grey overlay
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: 100,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                   shape: BoxShape.rectangle,
//                   gradient: LinearGradient(
//                     end: const Alignment(0.0, -0.8),
//                     begin: const Alignment(0.0, 0.4),
//                     colors: <Color>[Colors.black, Colors.transparent],
//                   ),
//                 ),
//               ),
//             ),

//             /// * Post title
//             Container(
//               width: double.infinity,
//               alignment: Alignment.bottomLeft,
//               padding: EdgeInsets.only(bottom: 12.0, left: 10.0, right: 10.0),
//               child: Text(cardTitle,
//                   maxLines: 4,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(color: Colors.white)),
//             )
//           ],
//         ),