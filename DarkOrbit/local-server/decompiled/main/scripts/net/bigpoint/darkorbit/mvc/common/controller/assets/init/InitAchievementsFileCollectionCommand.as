package net.bigpoint.darkorbit.mvc.common.controller.assets.init
{
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.as3toolbox.filecollection.event.FileCollectionEvent;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitAchievementsFileCollectionCommand extends InitFileCollectionBaseCommand
   {
      
      public function InitAchievementsFileCollectionCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:String = "xml/resource_achievements.xml?_cv=" + Settings.achievementsResourceHash;
         var _loc3_:String = Settings.staticHost + "do_img/global/";
         var _loc4_:FileCollection = new FileCollection(_loc3_,true);
         _loc4_.addEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handleResourceFileLoaded);
         _loc4_.loadResourceFile(_loc2_);
         assetsProxy.addFileCollection(_loc4_,AssetsProxy.ACHIEVEMENTS);
      }
      
      private function handleResourceFileLoaded(param1:FileCollectionEvent) : void
      {
         (param1.target as FileCollection).removeEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handleResourceFileLoaded);
         commandComplete();
      }
   }
}

