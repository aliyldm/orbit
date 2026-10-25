package net.bigpoint.darkorbit.mvc.common.controller.assets.init
{
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.as3toolbox.filecollection.event.FileCollectionEvent;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitItemFileCollectionCommand extends InitFileCollectionBaseCommand
   {
      
      public function InitItemFileCollectionCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:String = Settings.staticHost;
         var _loc3_:String = _loc2_ + "do_img/global/";
         var _loc4_:FileCollection = new FileCollection(_loc3_,true);
         _loc4_.addEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handleLoaded);
         _loc4_.loadResourceFile("xml/resource_items.xml?__cv=" + Settings.itemXMLHash);
         assetsProxy.addFileCollection(_loc4_,AssetsProxy.ITEMS);
      }
      
      private function handleLoaded(param1:FileCollectionEvent) : void
      {
         (param1.target as FileCollection).removeEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handleLoaded);
         var _loc2_:FileCollection = assetsProxy.getFileCollectionByInstanceName(AssetsProxy.ITEMS);
         commandComplete();
      }
   }
}

