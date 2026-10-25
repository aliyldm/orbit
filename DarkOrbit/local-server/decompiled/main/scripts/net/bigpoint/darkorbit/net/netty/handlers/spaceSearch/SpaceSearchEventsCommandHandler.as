package net.bigpoint.darkorbit.net.netty.handlers.spaceSearch
{
   import net.bigpoint.darkorbit.com.module.RewardModule;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.EventCommand;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.PlanetCommand;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchEventsCommand;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model.SSEvent;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model.SSPlanet;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model.SSReward;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model.SpaceSearchRewardData;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model.SpaceSearchRewardProxy;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintWindow.uistructures.HintWindowViewSetup;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SpaceSearchEventsCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function SpaceSearchEventsCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:SpaceSearchRewardData = null;
         var _loc8_:EventCommand = null;
         var _loc9_:PlanetCommand = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:RewardModule = null;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc2_:SpaceSearchRewardProxy = SpaceSearchRewardProxy.getOrCreateProxy(this.facade);
         var _loc3_:SpaceSearchEventsCommand = param1.getBody() as SpaceSearchEventsCommand;
         if(_loc3_)
         {
            _loc7_ = _loc2_.viewData;
            _loc7_.events.length = 0;
            _loc7_.planets.length = 0;
            _loc7_.rewards.length = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.eventIds.length)
            {
               _loc8_ = _loc3_.eventIds[_loc4_];
               _loc6_ = _loc8_.eventId;
               _loc5_ = _loc8_.planetId;
               _loc7_.events.push(new SSEvent(_loc6_,_loc5_));
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc3_.planets.length)
            {
               _loc9_ = _loc3_.planets[_loc4_];
               _loc5_ = _loc9_.planetId;
               _loc10_ = _loc9_.planetPct;
               _loc11_ = _loc9_.increase;
               _loc7_.planets.push(new SSPlanet(_loc5_,_loc10_,_loc11_));
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc3_.rewards.length)
            {
               _loc12_ = _loc3_.rewards[_loc4_];
               _loc13_ = _loc12_.lootId;
               _loc14_ = _loc12_.amount;
               _loc7_.rewards.push(new SSReward(_loc13_,_loc14_));
               _loc4_++;
            }
            this.tryCreateAndOpen();
            _loc7_.changed.dispatch();
         }
      }
      
      private function tryCreateAndOpen() : Boolean
      {
         var windowId:String = null;
         var window:IWindow = null;
         var uiSetup:HintWindowViewSetup = null;
         var creationVO:SimpleWindowCreationVO = null;
         try
         {
            windowId = GuiConstants.SPACE_SEARCH_REWARD;
            window = GuiManager.instance.getWindow(windowId);
            if(!window)
            {
               uiSetup = new HintWindowViewSetup();
               uiSetup.setUp();
               creationVO = SimpleWindowCreationMap.getById(windowId);
               if(creationVO)
               {
                  facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,creationVO);
                  window = guiManager.getWindow(windowId);
               }
               else
               {
                  window = guiManager.createWindow(windowId);
               }
            }
            window.maximize();
            return true;
         }
         catch(e:Error)
         {
         }
         return false;
      }
   }
}

