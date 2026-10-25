package net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.control
{
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.constants.JackpotResultWindowConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class JackpotResultWindowLoadUILibraryAsyncCommand extends AsyncCommand
   {
      
      public function JackpotResultWindowLoadUILibraryAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         ResourceManager.lazyGetAsset(JackpotResultWindowConstants.LIBRARY_NAME,this.handleUILibraryLoaded,this.handleUILibraryLoadError);
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

