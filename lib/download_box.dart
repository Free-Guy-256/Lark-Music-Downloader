import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:audioplayers/audioplayers.dart';

late Function addDownload;
late Function eraseDownloads;
late Function eraseRange;
AudioPlayer player = AudioPlayer();
late double xparent_height=0;
late double xparent_width=0;
int downloads_ct = 0;
List active_downloads = [];

 TextEditingController ctrl = TextEditingController();


class MusicPlayer extends StatefulWidget
{
  MusicState createState()
  {
    return MusicState();
  }
}

class MusicState extends State<MusicPlayer>
{
  bool isplay = false;
  bool isdownloading = false;


  void setIsPlay(bool play_stat)
  {
    setState(()
    {
      isplay = play_stat;
    });
  }


  @override
  Widget build(BuildContext context)
  {
    return /*Row(
              children: [
                */
                 Container(
                  
                  child: IconButton(color: Colors.green,icon:(isplay==false)?Icon(Icons.play_circle):Icon(Icons.pause_circle_filled),
                  onPressed: () async
                  {
                   
                   
                     if(isplay==false)
                     {
                      player.resume();
                      setIsPlay(true);
                     }
                     else
                     {
                      await player.pause();
                      setIsPlay(false);
                     }
                  
                    
                  },),
                );/*,
                 Flexible(
                  child: IconButton(color: Colors.green,icon:Icon(Icons.cancel),
                  onPressed: ()
                  {

                  },),
                )*/
            //  ],
           // );
  }
}


class MusicDl_boxx extends StatefulWidget
{
   late double parent_height=0;
  late double parent_width=0;

  MusicDl_boxx(this.parent_height,this.parent_width)
  {
    xparent_height = parent_height;
    xparent_width = parent_width;
  }

  MusicDl_box createState()
  {
    return MusicDl_box(parent_height, parent_width);
  }
}


class MusicDl_box extends State<MusicDl_boxx>
{
  late double parent_height=0;
  late double parent_width=0;

  bool search_results_ok = true;

  MusicDl_box(this.parent_height,this.parent_width)
  {
    xparent_height = parent_height;
    xparent_width = parent_width;
  }

  void setSearchFin(bool state_bool)
  {
    setState((){
      search_results_ok = state_bool;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    print(parent_height);

   
  
    return Row(
        
        children: [
            Container(height: (parent_height*0.07),width: (parent_width*0.6),margin: EdgeInsets.only(left: (parent_width*0.03))
            ,child:TextField(cursorColor: Colors.black,textAlign: TextAlign.center, decoration: InputDecoration(focusedBorder:OutlineInputBorder( borderSide: BorderSide(
    style: BorderStyle.solid, 
    color: Colors.black
  )),hintText: "write song name and title", 
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
            fillColor: Colors.white70,
          
            filled: true,
            ),
            controller: ctrl,)),
            Container(height: (parent_height*0.07),
              margin: EdgeInsets.only(left:parent_width*0.05),
              child: ElevatedButton(
  onPressed: () async {
    print(xparent_height);
    eraseDownloads();
    setSearchFin(false);
    YoutubeExplode yep = YoutubeExplode();
    VideoSearchList vsl = await yep.search.search(ctrl.text);
    print("search finished");
    vsl.forEach((video)
    {
      String title = video.title;
      String author = video.author;
      print(video);
      addDownload(DownloadItem(video));
    });
     setSearchFin(true);
      
  },
  child: search_results_ok==true?Text('SEARCH SONG'):CircularProgressIndicator(color: Colors.white),
  style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 5, 61, 104),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30), // <-- Radius
    ),
  ),
)),

        ],
      );
  }
}


class Downloads extends StatefulWidget
{
  @override
  DownloadItems createState()
  {
    return DownloadItems();
  }
}

class DownloadItems extends State<Downloads>
{
  List<Widget> downloads = [];
  ScrollController search_scroll_ctrl = ScrollController();

  void putDownload(Widget downloadbox)
  {
   

    setState(() {
       downloads.add(downloadbox);
    });
  }

  void clearDownload()
  {
   

    setState(() {
       
       downloads.clear();
    });
  }

  void clearDownloads(int active_ind)
  {
   

    setState(() {
       int last_ind = downloads.length;
       if(last_ind>0)
       {
       downloads.removeRange((active_ind),(last_ind-1));
       print("all removed");
       }
    });
  }

  @override
  void initState() {

    super.initState();
     addDownload = putDownload;
     eraseDownloads = clearDownload;
     eraseRange = clearDownloads;
  }

  @override
  Widget build(BuildContext context)
  {
   
    return (downloads.length>0)?(
      //Expanded(
      //width: xparent_width,
      //height: (xparent_height*0.7),
      //child: 
      Scrollbar
      (
     // thumbVisibility: true,
      controller: search_scroll_ctrl,
      child:ListView(
        //controller: search_scroll_ctrl,
        children: //[Text("artist: ",style: TextStyle(color: Colors.white)),]
        downloads,
      )
      )
 //     )
    ):Container();
  }
}

class DownloadItem extends StatefulWidget
{
 var dl_query;
  DownloadItem(this.dl_query)
  {

  }

  @override
  DownloadState createState()
  {
    return DownloadState(dl_query);
  }
}


class DownloadState extends State<DownloadItem>
{
  var query_video;
  String query_string = "enemy by imagine dragons";
  String artist = "imagine dragons";
  String song = "enemy";
  String song_url = "https://www.youtube.com/watch?v=";
  String video_id = "";
  String file_gg_url="";
  String this_download="";
 // ScrollController search_scroll_ctrl = ScrollController();
  YoutubeExplode yt_exp = YoutubeExplode();
  late StreamManifest video_manifest;
  late  StreamInfo aud_stream_info;
  double file_size = 0;
  
  bool isplay = false;
  bool isdownloading = false;
  DownloadState (this.query_video)
  {
    query_string = query_video.title;
    artist = query_video.author;
    song = query_video.title;
    video_id =query_video.id.value;
    song_url = song_url+video_id;
  }

  @override
  void initState()
  {
    super.initState();
    fillData();
  }

  void setFileSize(double sz)
  {
    setState((){file_size=sz;});
  }

  void setIsDownloading(bool dl_prog)
  {
    setState(()
    {
      isdownloading = dl_prog;
    });
  }

  void setIsPlay(bool play_stat)
  {
    setState(()
    {
      isplay = play_stat;
    });
  }

  void fillData() async
  {
   
  }

  @override
  Widget build(BuildContext context)
  {
    return //Expanded(
    
     // child:
      /* Container(
      color: Colors.black87,
      
      width: xparent_width,
      //child:Text("artist: ",style: TextStyle(color: Colors.white))
    /*  child:Scrollbar
      (
        thumbVisibility: true,
        controller: search_scroll_ctrl,*/
      child:*/
      Container
      (
      child:Column(
        
       crossAxisAlignment: CrossAxisAlignment.start,
        children:[
            Text("\tDownload "+query_string,style: TextStyle(color: Colors.white),textAlign: TextAlign.center),
            Text("artist: "+artist,style: TextStyle(color: Colors.white)),
            Text("song: "+song,style: TextStyle(color: Colors.white)),
            Text("file size: $file_size",style: TextStyle(color: Colors.white)),
            Row(
              children: [
                Flexible(
                  child: IconButton(color: Colors.green,icon:(isdownloading==false)?Icon(Icons.download_for_offline_rounded):Icon(Icons.access_time_filled_sharp),
                  onPressed: () async
                  {
                    //active_downloads.add(downloads_ct);
                    //eraseRange(downloads_ct+1);
                    setIsDownloading(true);
                    downloads_ct=downloads_ct++;
                    print(video_id);
                   
                   
                    video_manifest = await yt_exp.videos.streamsClient.getManifest(video_id);
                    aud_stream_info = video_manifest.audioOnly.withHighestBitrate();

                    file_size = aud_stream_info.size.totalMegaBytes;

                    setFileSize(file_size);
                    String file_uri = aud_stream_info.url.toString();
                    var frags =  aud_stream_info.fragments;
                    file_gg_url = file_uri;
                    print("file_size: $file_size");
                    print("file_url: $file_uri");
                    
                    FileDownloader.downloadFile
                    (url: file_uri,
                    downloadDestination: DownloadDestinations.publicDownloads,
                    name: "$song.m4a",
                    onProgress: (name,prog_ct)
                                {
                                  print("\nDownloaded $prog_ct");
                                },
                    onDownloadCompleted: (filepath)
                                      {
                                        print("\ndownload completed at: $filepath");
                                        downloads_ct = 0;
                                      });
                    print("download finished");
                    ///storage/emulated/0/Download/Adele%20-%20Hello%20(Official%20Music%20Video).m4a

                    //Stream aud_stream =  yt_exp.videos.streamsClient.get(aud_stream_info);
                    
                  },),
                ),
                 Flexible(
                  child: IconButton(color: Colors.green,icon:(isplay==false)?Icon(Icons.play_circle):Icon(Icons.pause_circle_filled),
                  onPressed: () async
                  {
                    if(this_download.length>0)
                    {
                      
                     if(isplay==false)
                     {
                      player.play(DeviceFileSource(this_download));
                     setIsPlay(true);
                     }
                     else
                     {
                      await player.pause();
                      setIsPlay(false);
                     }
                    }
                    else
                    {
                      print("not yet downloaded");
                      if(isplay==false)
                     {
                      
                      player.play(UrlSource(file_gg_url));
                     setIsPlay(true);
                     }
                     else
                     {
                      await player.pause();
                      setIsPlay(false);
                     }
                    }
                  },),
                ),
                 Flexible(
                  child: IconButton(color: Colors.green,icon:Icon(Icons.cancel),
                  onPressed: ()
                  {

                  },),
                )
              ],
            ),
             Container(width: xparent_width,height: (xparent_height*0.01),color: Color.fromARGB(255, 5, 61, 104)),
        ]
      )
       );
      // )
   // );
  }
}