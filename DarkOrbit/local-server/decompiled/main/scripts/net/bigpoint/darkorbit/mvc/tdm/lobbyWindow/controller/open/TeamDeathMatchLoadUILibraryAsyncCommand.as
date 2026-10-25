package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.open
{
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.TeamDeathMatchLobbyWindowConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class TeamDeathMatchLoadUILibraryAsyncCommand extends AsyncCommand
   {
      
      public function TeamDeathMatchLoadUILibraryAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:AssetsProxy = facade.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         _loc2_.lazyLoad(TeamDeathMatchLobbyWindowConstants.LIBRARY_NAME,this.handleUILibraryLoaded,this.handleUILibraryLoadError);
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

