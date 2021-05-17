import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'video_item.dart';

const aspectRatio = 16 / 9;

class NewestAnimationCarousel extends StatefulWidget {
  const NewestAnimationCarousel({
    Key key,
    this.currentPage,
    this.pageController,
    this.padding,
  }) : super(key: key);

  final ValueNotifier<int> currentPage;
  final PageController pageController;
  final double padding;

  @override
  _NewestAnimationCarouselState createState() =>
      _NewestAnimationCarouselState();
}

class _NewestAnimationCarouselState extends State<NewestAnimationCarousel> {
  final List<String> textList = [
    'A mobile application that allows users (employees and guests) to reserve office space for different'
        ' clients - in different locations. It shows the available offices and'
        ' their exact location, equipment, and even the temperature in individual rooms.',
    'A web application that allows users (employees and guests) to reserve office space for different'
        ' clients - in different locations. It shows the available offices and'
        ' their exact location, equipment, and even the temperature in individual rooms.',
    'You can plan your holidays carefully and inform the necessary people about it. Organizing work and joint meetings is now much easier!'
  ];

  final List<String> _clips = [
    'assets/videos/Spicatech-Mobile-Final.mp4',
    'assets/videos/Spicatech-Desktop-Final.mp4',
    'assets/videos/HolidayApp_3.mp4'
  ];

  final List<String> _thumbs = [
    'assets/Spicatech_Mobile.png',
    'assets/Spicatech_Desktop.png',
    'assets/HolidayApp.png'
  ];

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return;
      },
      child: PageView.builder(
        itemCount: 3,
        controller: widget.pageController,
        physics: const ClampingScrollPhysics(),
        onPageChanged: (index) {
          widget.currentPage.value = index;
        },
        itemBuilder: (_, index) {
          return _buildPage(textList[index], _clips[index], _thumbs[index]);
        },
      ),
    );
  }

  Widget _buildPage(String text, String clip, String thumb) {
    return Column(
      children: [
        SizedBox(
          height: widget.padding,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              letterSpacing: 0.0,
              height: 1.25,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: VideoItem(
              url: clip,
              thumbUrl: thumb,
            ),
          ),
        ),
      ],
    );
  }
}
