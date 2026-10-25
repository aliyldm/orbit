package net.bigpoint.darkorbit.mvc.sectorControlWindow.controller
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.SectorControlLobbyWindow;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.SectorControlLobbyWindowMediator;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class SectorControlOpenLobbyWindowAsyncCommand extends AsyncCommand
   {
      
      public function SectorControlOpenLobbyWindowAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:SectorControlLobbyWindow = null;
         var _loc3_:IMediator = null;
         var _loc4_:SectorControlLobbyWindowMediator = null;
         if(this.isRequiredLevel())
         {
            _loc2_ = FlexWindowManager.getInstance().createWindow(FlexWindowManager.SECTORCONTROL_LOBBY_WINDOW,FlexWindowManager.WINDOW_RIGHT_ALIGNED) as SectorControlLobbyWindow;
            if(!facade.hasMediator(SectorControlLobbyWindowMediator.NAME))
            {
               _loc3_ = new SectorControlLobbyWindowMediator(_loc2_);
               facade.registerMediator(_loc3_);
            }
            else
            {
               _loc4_ = facade.retrieveMediator(SectorControlLobbyWindowMediator.NAME) as SectorControlLobbyWindowMediator;
               _loc4_.setViewComponent(_loc2_);
            }
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_QUEST_WINDOW_OPEN_SOUND);
         }
         commandComplete();
      }
      
      protected function isRequiredLevel() : Boolean
      {
         var _loc1_:SectorControlProxy = facade.retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy;
         var _loc2_:uint = _loc1_.minLevel;
         var _loc3_:uint = _loc1_.maxLevel;
         var _loc4_:uint = uint(Hero.level);
         return _loc4_ >= _loc2_ && _loc4_ <= _loc3_ ? true : false;
      }
   }
}

