import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final String? videoPath; // Local file path
  final String? videoUrl; // Network URL
  final bool isNetworkVideo; // Flag to determine if it's a network video

  VideoView({
    super.key,
    this.videoPath,
    this.videoUrl,
    this.isNetworkVideo = false,
  }) : assert(
  (videoPath != null && videoUrl == null) ||
      (videoPath == null && videoUrl != null),
  'Either videoPath or videoUrl must be provided, but not both',
  );

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController? controller;
  ChewieController? chewieController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    startVideo();
  }

  Future<void> startVideo() async {
    try {
      if (widget.isNetworkVideo && widget.videoUrl != null) {
        // For network URL with additional headers for ngrok
        controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl!),
          httpHeaders: {
            'ngrok-skip-browser-warning': 'true',
            'User-Agent': 'Mozilla/5.0',
          },
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true,
            allowBackgroundPlayback: false,
          ),
        );
      } else if (widget.videoPath != null) {
        // For local file
        controller = VideoPlayerController.file(File(widget.videoPath!));
      } else {
        throw Exception('No video source provided');
      }

      // Add listener for errors
      controller!.addListener(() {
        if (controller!.value.hasError) {
          setState(() {
            _errorMessage = controller!.value.errorDescription ?? 'Unknown error';
            _isLoading = false;
          });
        }
      });

      await controller!.initialize();

      if (mounted) {
        chewieController = ChewieController(
          videoPlayerController: controller!,
          autoPlay: true,
          looping: false,
          allowFullScreen: true,
          allowPlaybackSpeedChanging: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: Colors.blue,
            handleColor: Colors.blueAccent,
            backgroundColor: Colors.grey,
            bufferedColor: Colors.lightBlue,
          ),
          placeholder: Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading video',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _errorMessage = null;
                      });
                      controller?.dispose();
                      chewieController?.dispose();
                      startVideo();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          },
        );

        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
      debugPrint('Error loading video: $e');
    }
  }

  @override
  void dispose() {
    controller?.pause();
    controller?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to load video',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  startVideo();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (chewieController != null &&
        chewieController!.videoPlayerController.value.isInitialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: chewieController!.videoPlayerController.value.aspectRatio,
          child: Chewie(
            controller: chewieController!,
          ),
        ),
      );
    }

    return const Center(
      child: Text(
        'Video not initialized',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}