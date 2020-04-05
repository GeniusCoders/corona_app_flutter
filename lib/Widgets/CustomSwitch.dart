import 'package:coronaapp/style/colors.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  CustomSwitch({Key key, this.value, this.onChanged}) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation<double> _circleAnimation;
  AnimationController _animationController;
  Animation<Color> _colorAnimation;
  Animation<Color> _shadowColorAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _circleAnimation =
        Tween<double>(begin: widget.value ? 1 : 0, end: widget.value ? 0 : 1)
            .animate(CurvedAnimation(
                parent: _animationController, curve: Curves.easeInCirc));
    _colorAnimation = ColorTween(
            begin: widget.value ? black : white,
            end: widget.value ? white : black)
        .animate(_animationController);
    _shadowColorAnimation = ColorTween(
            begin: widget.value ? white : black.withOpacity(.1),
            end: widget.value ? black.withOpacity(.1) : white)
        .animate(_animationController);
  }

  Widget getSelectedModeIcon() {
    return _circleAnimation.value == 0
        ? Icon(
            Icons.brightness_1,
            color: yellow,
            size: 20,
          )
        : Transform.rotate(
            angle: .3,
            child: Icon(
              Icons.brightness_2,
              color: white,
              size: 20,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.onChanged(!widget.value);
          },
          child: Container(
              width: 45.0,
              height: 28.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        offset: Offset(0, 0),
                        color: _shadowColorAnimation.value,
                        spreadRadius: 1)
                  ],
                  color: _colorAnimation.value),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 2,
                    left: _circleAnimation.value * 22.0,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 2.0, bottom: 2.0, right: 2.0, left: 2.0),
                      child: Container(child: getSelectedModeIcon()),
                    ),
                  )
                ],
              )),
        );
      },
    );
  }
}
