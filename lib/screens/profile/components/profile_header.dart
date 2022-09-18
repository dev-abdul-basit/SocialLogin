import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    Key? key,
    required this.isEdit,
    required this.backPress,
    required this.editPress,
    required this.cameraPress,
    required this.icon,
    required this.profileImage,
  }) : super(key: key);
  final bool isEdit;

  final Function backPress;
  final Function editPress;
  final Function cameraPress;
  final Icon icon;
  final String profileImage;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          height: getProportionateScreenHeight(200),
          decoration: const BoxDecoration(color: kPrimaryColor),
        ),
        Positioned(
          top: 120,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 150.0,
                width: 150.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(widget.profileImage),
                    ),
                    border: Border.all(color: Colors.white, width: 6.0)),
              ),
              Positioned(
                bottom: 50,
                right: -10,
                child: Visibility(
                  visible: widget.isEdit == true ? true : false,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: kFormColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      onPressed: () {
                        widget.cameraPress();
                      },
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 70,
          child: InkWell(
            child: Row(
              children: [
                const Text(
                  'Abdul Basit',
                  style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 24,
                    color: Color(0xffffffff),
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(8),
                ),
                Visibility(
                  visible: widget.isEdit == true ? true : false,
                  child: IconButton(
                    onPressed: () {
                      widget.editPress();
                    },
                    icon: widget.icon,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 25,
          left: 10,
          child: Visibility(
            visible: widget.isEdit == true ? true : false,
            child: IconButton(
              onPressed: () {
                widget.backPress();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
