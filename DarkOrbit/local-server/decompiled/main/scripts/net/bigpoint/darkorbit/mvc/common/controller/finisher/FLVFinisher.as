package net.bigpoint.darkorbit.mvc.common.controller.finisher
{
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.darkorbit.mvc.common.view.components.FLVVideoPlayer;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class FLVFinisher extends FileCollectionFinisher
   {
      
      public function FLVFinisher()
      {
         super();
      }
      
      public function getVideo(param1:Boolean = false) : FLVVideoPlayer
      {
         return new FLVVideoPlayer(this.getURL(),param1);
      }
      
      public function getURL() : String
      {
         return Settings.staticHost + Settings.basePath + fileVO.getFileName(true);
      }
   }
}

