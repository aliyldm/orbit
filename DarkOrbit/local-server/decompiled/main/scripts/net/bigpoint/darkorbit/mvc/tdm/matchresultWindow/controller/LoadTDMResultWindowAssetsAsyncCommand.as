package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.controller
{
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.consts.TDMResultWindowConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class LoadTDMResultWindowAssetsAsyncCommand extends AsyncCommand
   {
      
      public function LoadTDMResultWindowAssetsAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:AssetsProxy = facade.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         _loc2_.lazyLoad(TDMResultWindowConstants.LIBRARY_NAME,this.handleUILibraryLoaded,this.handleUILibraryLoadError);
      }
      
      protected function handleUILibraryLoaded(param1:SWFFinisher) : void
      {
         commandComplete();
      }
      
      protected function handleUILibraryLoadError(param1:SWFFinisher) : void
      {
         commandComplete();
      }
   }
}

