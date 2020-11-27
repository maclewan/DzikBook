import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialIcon extends StatelessWidget {
  const SocialIcon({
    Key key,
    @required this.deviceSize,
    @required this.icon,
    @required this.color,
    @required this.press,
  }) : super(key: key);

  final Size deviceSize;
  final String icon;
  final Color color;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        padding: EdgeInsets.only(top: 5),
        width: deviceSize.width * 0.11,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
        ),
        child: SvgPicture.asset(
          icon,
          color: Colors.white,
          height: deviceSize.height * 0.05,
        ),
      ),
    );
  }
}
