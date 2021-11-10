import 'package:flutter/material.dart';
import 'package:ummobile/modules/tabs/modules/conectate/utils/action_post.dart';

class ItemGridPost extends StatelessWidget {
  final String cardTitle;
  final String url;
  final String imagePath;

  const ItemGridPost(
      {Key? key,
      required this.cardTitle,
      required this.imagePath,
      required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 9,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: InkWell(
            onTap: () {
              actionPost(url, imagePath, context);
            },
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: Column(
              children: <Widget>[
                /// * Image post
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10.0)),
                      child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        placeholder: "assets/img/default-img.jpg",
                        image: imagePath,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          "assets/img/default-img.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                /// * Bottom card section
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      children: <Widget>[
                        /// * Blank overlay
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                              ),
                              shape: BoxShape.rectangle,
                              color: Theme.of(context).cardColor),
                        ),

                        /// * Post title
                        Container(
                          width: double.infinity,
                          height: 120,
                          padding: EdgeInsets.only(
                              top: 12.0, left: 10.0, right: 10.0),
                          child: Text(cardTitle,
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )),
              ],
            )));
  }
}
