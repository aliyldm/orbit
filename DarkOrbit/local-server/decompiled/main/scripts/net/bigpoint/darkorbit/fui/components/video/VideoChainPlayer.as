package net.bigpoint.darkorbit.fui.components.video
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   
   public class VideoChainPlayer extends Coreponent
   {
      
      private var _video1:VideoPlayer;
      
      private var _video2:VideoPlayer;
      
      private var _currentVideo:VideoPlayer;
      
      private var _urlList:Array;
      
      private var _currentVideoNr:int;
      
      private var _definition:XML;
      
      public function VideoChainPlayer(param1:XML)
      {
         this._definition = param1;
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this._currentVideo = this._video1 = new VideoPlayer();
         this._video2 = new VideoPlayer();
         this._video1.x = this._video2.x = this._video1.y = this._video2.y = 0;
         addChild(this._video1);
         addChild(this._video2);
      }
      
      override protected function drawSize() : void
      {
         super.drawSize();
         this._video1.width = this._video2.width = width;
         this._video1.height = this._video2.height = height;
      }
      
      public function play(param1:Array) : void
      {
         this.stop();
         this._currentVideoNr = 0;
         this._urlList = param1;
         this.playNextVideo();
      }
      
      private function playVideo(param1:String) : void
      {
         if(param1)
         {
            this._currentVideo.playURL(param1);
            this._currentVideo.addEventListener(Event.ENTER_FRAME,this.handleVideoUpdate);
            this._currentVideo.addEventListener(VideoPlayer.STREAM_RESTARTED,this.handleVideoRestarted);
         }
         else
         {
            this.stop();
         }
      }
      
      private function handleVideoRestarted(param1:Event) : void
      {
         this._currentVideo.removeEventListener(Event.ENTER_FRAME,this.handleVideoUpdate);
         this._currentVideo.removeEventListener(VideoPlayer.STREAM_RESTARTED,this.handleVideoRestarted);
         this._currentVideo.stop();
         this._currentVideo.alpha = 0;
         this._currentVideo = this._currentVideo == this._video1 ? this._video2 : this._video1;
         this.playNextVideo();
      }
      
      private function playNextVideo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(this._urlList)
         {
            _loc1_ = this.nextVideoNr;
            _loc2_ = this._urlList[_loc1_];
            this.playVideo(_loc2_);
         }
      }
      
      private function get nextVideoNr() : int
      {
         var _loc1_:int = this._currentVideoNr;
         ++this._currentVideoNr;
         if(this._currentVideoNr > this._urlList.length - 1)
         {
            this._currentVideoNr = 0;
         }
         return _loc1_;
      }
      
      private function handleVideoUpdate(param1:Event) : void
      {
         this._currentVideo.alpha = 1 - Math.pow(this._currentVideo.playbackProgressPercentage - 0.5,2) * 5;
      }
      
      public function stop() : void
      {
         this._currentVideo.stop();
      }
      
      public function restart() : void
      {
         this.playNextVideo();
      }
   }
}

