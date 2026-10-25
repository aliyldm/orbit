package net.bigpoint.darkorbit.mvc.common.controller.assets.init
{
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.as3toolbox.filecollection.event.FileCollectionEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.application.model.vo.StartupVO;
   import net.bigpoint.darkorbit.mvc.common.controller.finisher.FLVFinisher;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitGameFileCollectionCommand extends InitFileCollectionBaseCommand
   {
      
      public function InitGameFileCollectionCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:String = "xml/resources.xml?__cv=" + Settings.resourceXMLHash;
         var _loc3_:String = Settings.staticHost + Settings.basePath;
         if(StartupVO(param1.getBody()).flashVars.resourcesPath != undefined)
         {
            _loc3_ = StartupVO(param1.getBody()).flashVars.resourcesPath;
            _loc2_ = "xml/resources.xml";
         }
         var _loc4_:FileCollection = new FileCollection(_loc3_,true);
         _loc4_.addFinisherClass("flv",FLVFinisher);
         _loc4_.addFinisherClass("jxr",ImageFinisher);
         _loc4_.addEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handlegameFileCollectionLoaded);
         _loc4_.loadResourceFile(_loc2_);
         ResourceManager.init(_loc4_);
         assetsProxy.addFileCollection(_loc4_);
      }
      
      private function handlegameFileCollectionLoaded(param1:FileCollectionEvent) : void
      {
         (param1.target as FileCollection).removeEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handlegameFileCollectionLoaded);
         commandComplete();
      }
   }
}

