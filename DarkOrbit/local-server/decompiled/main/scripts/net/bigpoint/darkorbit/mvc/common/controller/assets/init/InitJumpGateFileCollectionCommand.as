package net.bigpoint.darkorbit.mvc.common.controller.assets.init
{
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.as3toolbox.filecollection.event.FileCollectionEvent;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitJumpGateFileCollectionCommand extends InitFileCollectionBaseCommand
   {
      
      public function InitJumpGateFileCollectionCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:String = Settings.staticHost + "do_img/global/";
         var _loc3_:FileCollection = new FileCollection(_loc2_,true);
         _loc3_.addEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handleResourceFileLoaded);
         _loc3_.loadResourceFile("xml/resource_jumpgate.xml?_cv=" + Settings.eventsResourceHash);
         assetsProxy.addFileCollection(_loc3_,AssetsProxy.JUMPGATE);
      }
      
      private function handleResourceFileLoaded(param1:FileCollectionEvent) : void
      {
         (param1.target as FileCollection).removeEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handleResourceFileLoaded);
         commandComplete();
      }
   }
}

