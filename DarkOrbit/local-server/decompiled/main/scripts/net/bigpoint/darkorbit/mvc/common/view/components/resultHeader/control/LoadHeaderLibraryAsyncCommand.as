package net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.control
{
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.model.ResultHeaderConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class LoadHeaderLibraryAsyncCommand extends AsyncCommand
   {
      
      public function LoadHeaderLibraryAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         ResourceManager.lazyGetAsset(ResultHeaderConstants.HEADER_LABLELIBRARY_NAME,this.handleLibraryLoaded,this.handleLibraryLoadError);
      }
      
      protected function handleLibraryLoaded(param1:SWFFinisher) : void
      {
         commandComplete();
      }
      
      protected function handleLibraryLoadError(param1:SWFFinisher) : void
      {
         commandComplete();
      }
   }
}

