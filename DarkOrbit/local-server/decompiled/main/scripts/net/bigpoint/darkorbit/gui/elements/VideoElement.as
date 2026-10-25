package net.bigpoint.darkorbit.gui.elements
{
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class VideoElement extends SimpleElement
   {
      
      public static const CLASS_COMMANDER:int = 0;
      
      public static const CLASS_HELPMOVIE:int = 1;
      
      private var videoID:int;
      
      private var classID:int;
      
      private var factionID:int;
      
      private var video:MovieClip;
      
      private var cMask:MovieClip;
      
      public var interference:Interference;
      
      private var border:Bitmap;
      
      public function VideoElement(param1:int, param2:int = 0, param3:int = 0)
      {
         super(TYPE_VIDEO_ELEMENT);
         if(param1 != -1)
         {
            this.videoID = param1;
            this.classID = param2;
            this.factionID = param3;
            this.init();
         }
      }
      
      public static function getContentResKey(param1:int, param2:int) : String
      {
         var _loc3_:String = "";
         if(param1 == CLASS_COMMANDER)
         {
            _loc3_ = "videoPic";
         }
         else if(param1 == CLASS_HELPMOVIE)
         {
            _loc3_ = "helpmovie";
         }
         _loc3_ += "_" + param2;
         if(param1 == CLASS_HELPMOVIE && param2 == 1)
         {
            _loc3_ += "_faction" + Hero.factionID.value;
         }
         return _loc3_;
      }
      
      public function init() : void
      {
         var _loc1_:String = getContentResKey(this.classID,this.videoID);
         this.video = ResourceManager.getMovieClip(_loc1_,"video");
         this.video.mask = this.cMask;
         MovieClipUtils.playAnimation(this.video,20,true);
         this.interference = new Interference(this.video.width,this.video.height);
         this.interference.playSound = false;
         if(this.classID == CLASS_COMMANDER)
         {
            this.interference.fadeOut = false;
            this.interference.start();
            this.video.addChild(this.interference);
         }
         this.addChild(this.video);
         var _loc2_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this.cMask = _loc2_.getEmbeddedMovieClip("cMask");
         this.addChild(this.cMask);
         this.video.mask = this.cMask;
         this.border = _loc2_.getEmbeddedBitmap("border");
         this.addChild(this.border);
      }
      
      override public function get width() : Number
      {
         if(this.border != null)
         {
            return this.border.width;
         }
         return super.width;
      }
      
      override public function get height() : Number
      {
         if(this.border != null)
         {
            return this.border.height;
         }
         return super.height;
      }
      
      public function cleanup() : void
      {
         if(this.interference)
         {
            this.interference.cleanup();
         }
         if(Boolean(this.cMask) && Boolean(this.cMask.parent))
         {
            this.cMask.parent.removeChild(this.cMask);
         }
         if(Boolean(this.border) && Boolean(this.border.parent))
         {
            this.border.parent.removeChild(this.border);
         }
         if(this.video)
         {
            MovieClipUtils.stopAnimation(this.video);
            this.video.mask = null;
            if(this.video.parent)
            {
               this.video.parent.removeChild(this.video);
            }
         }
      }
   }
}

