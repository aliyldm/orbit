package net.bigpoint.darkorbit.mvc.sectorControlWindow.controller
{
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.SectorControlConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class SectorControlLoadUILibraryAsyncCommand extends AsyncCommand
   {
      
      public function SectorControlLoadUILibraryAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         ResourceManager.lazyGetAsset(SectorControlConstants.LIBRARY_NAME,this.handleUILibraryLoaded,this.handleUILibraryLoadError);
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

