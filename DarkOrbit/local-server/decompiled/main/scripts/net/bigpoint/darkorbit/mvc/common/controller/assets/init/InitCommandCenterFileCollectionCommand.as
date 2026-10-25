package net.bigpoint.darkorbit.mvc.common.controller.assets.init
{
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.as3toolbox.filecollection.event.FileCollectionEvent;
   import net.bigpoint.darkorbit.mvc.commandCenter.view.builder.CommandCenterNewBuilder;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitCommandCenterFileCollectionCommand extends InitFileCollectionBaseCommand
   {
      
      public function InitCommandCenterFileCollectionCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:String = "resources/resource_command_center.xml?_cv=" + Settings.commandCenterHash;
         var _loc3_:String = Settings.staticHost;
         var _loc4_:FileCollection = new FileCollection(_loc3_,true);
         _loc4_.addEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handleResourceFileLoaded);
         _loc4_.loadResourceFile(_loc2_);
         assetsProxy.addFileCollection(_loc4_,AssetsProxy.NEWS);
      }
      
      private function handleResourceFileLoaded(param1:FileCollectionEvent) : void
      {
         var _loc2_:FileCollection = param1.target as FileCollection;
         _loc2_.removeEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handleResourceFileLoaded);
         CommandCenterNewBuilder.instance.load().addOnce(commandComplete);
      }
   }
}

