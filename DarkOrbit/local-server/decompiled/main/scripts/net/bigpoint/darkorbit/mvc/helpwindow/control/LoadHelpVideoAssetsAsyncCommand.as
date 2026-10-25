package net.bigpoint.darkorbit.mvc.helpwindow.control
{
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class LoadHelpVideoAssetsAsyncCommand extends AsyncCommand
   {
      
      public function LoadHelpVideoAssetsAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:AssetsProxy = facade.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         _loc2_.load("disablingPepper",this.handleUILibraryLoaded,this.handleUILibraryLoadError);
      }
      
      protected function handleUILibraryLoaded(param1:FileCollectionFinisher) : void
      {
         commandComplete();
      }
      
      protected function handleUILibraryLoadError(param1:FileCollectionFinisher) : void
      {
         commandComplete();
      }
   }
}

