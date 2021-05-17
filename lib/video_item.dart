import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

const aspectRatio = 16 / 9;

class VideoItem extends StatefulWidget {
  VideoItem({this.url, this.thumbUrl, this.h});

  final String url;
  final String thumbUrl;
  final double h;

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  VideoPlayerController _videoController;
  ChewieController _chewieController;
  Completer videoPlayerInitialized = Completer();
  UniqueKey stickyKey = UniqueKey();
  bool readycontroller = false;
  bool play = false;

  @override
  void dispose() async {
    // Ensure disposing of the VideoPlayerController to free up resources.

    await _videoController?.dispose()?.then((_) {
      _chewieController?.dispose();

      readycontroller = false;
      _videoController = null;
      _chewieController = null;
      videoPlayerInitialized = Completer(); // resets the Completer
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: VisibilityDetector(
      key: stickyKey,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.50) {
          if (_videoController == null) {
            _videoController = VideoPlayerController.asset(widget.url);
            _videoController.initialize().then((_) {
              _chewieController = ChewieController(
                videoPlayerController: _videoController,
                aspectRatio: aspectRatio,
                autoInitialize: true,
                autoPlay: true,
                looping: true,
                showControls: false,
                errorBuilder: (_, __) {
                  return const SizedBox.shrink();
                },
              );
              videoPlayerInitialized.complete(true);
              setState(() {
                readycontroller = true;
              });
              _videoController.setLooping(true);

              _chewieController.play();
              _videoController.play();
            });
          }
        } else if (info.visibleFraction < 0.30) {
          setState(() {
            readycontroller = false;
          });

          _videoController?.pause();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _videoController?.dispose()?.then((_) {
              _chewieController.dispose();
              setState(() {
                _videoController = null;
                _chewieController = null;
                videoPlayerInitialized = Completer(); // resets the Completer
              });
            });
          });
        }
      },
      child: FutureBuilder(
        future: videoPlayerInitialized.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _videoController != null &&
              readycontroller) {
            return AspectRatio(
              aspectRatio: aspectRatio,
              child: Chewie(
                controller: _chewieController,
              ),
            ); // display the video
          }

          return videoBurrow(context, thumbUrl: widget.thumbUrl, h: widget.h);
        },
      ),
    ));
  }
}

Widget videoBurrow(BuildContext context, {String thumbUrl = "", double h}) {
  return SizedBox(
    child: Container(
      //color: Colors.black,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: thumbUrl != ""
            ? Container(
                child: Image.asset(thumbUrl),
              )
            : Container(
                decoration: const BoxDecoration(color: Colors.black87),
              ),
      ),
    ),
  );
}
