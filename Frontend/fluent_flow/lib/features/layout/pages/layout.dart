import 'package:fluent_flow/features/layout/widgets/sidebar.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class HomeLayout extends StatefulWidget {
  HomeLayout({Key? key, required this.body, required this.index}) : super(key: key);

  late double height;
  late double width;
  final Widget body;
  final int index;

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: LayoutBuilder(
          builder: (context, BoxConstraints constraints) {
            widget.height = constraints.maxHeight;
            widget.width = constraints.maxWidth;
            return Scaffold(
              body: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SideBar(widget: widget),
                  SizedBox(
                    height: widget.height,
                    width: 0.8 * widget.width,
                    child: widget.body, 
                  ),
                ],
              ),    
            );
          }
        ),
      );
  }
}
