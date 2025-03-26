import 'package:fluent_flow/core/const/api.dart';
import 'package:fluent_flow/core/const/styles.dart';
import 'package:fluent_flow/core/models/video_model.dart';
import 'package:fluent_flow/core/widgets/loading_widget.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_states.dart';
import 'package:fluent_flow/features/layout/pages/layout.dart';
import 'package:fluent_flow/features/library/widgets/see_more_button.dart';
import 'package:fluent_flow/features/library/widgets/video_widget.dart';
import 'package:fluent_flow/features/video_score/pages/video_score_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LibraryPage extends StatefulWidget {
  static const String routeName = 'Library_page';

  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // double height = constraints.maxHeight;
      // double width = constraints.maxWidth;
      return HomeLayout(
        index: 3,
        body: BlocConsumer<FluentCubit, FluentState>(
          listener: (context, state) {
            if(state is GetVideoScoresSuccessState){
              Video videoX = FluentCubit.get(context).videoScore!;
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoScorePage(video: videoX)));
            }
          },
          builder: (context, state) => state is GetVideosLoadingState ? const Center(child: LoadingWidget(size: 20, stroke: 20)) : VideoGrid(videos: FluentCubit.get(context).videos),
        ),
      );
    });
  }
}

class VideoGrid extends StatelessWidget {

  const VideoGrid({super.key, required this.videos});

  final List<Video> videos;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: GridView.builder(
          gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return Column(
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).height*0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: fluentNavy,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Expanded(
                      child: InkWell(
                        child: VideoPlayerWidget(videoUrl: IP_PORT + video.videoUrl!)),
                    ),
                  ),
                ),
                SeeDetailsButton(onTap: (){
                  FluentCubit.get(context).getVideoScores(video);
                },),
              ],
            );
          },
        ),
      );
  }
}
