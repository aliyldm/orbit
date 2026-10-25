package net.bigpoint.darkorbit.net.netty.handlers.strikeandexit
{
   import net.bigpoint.darkorbit.com.module.porting.strikeandexit.StrikeAndExitMapInfoCommand;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.info.model.StrikeAndExitInfoProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class StrikeAndExitMapInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      private static var count:int = 0;
      
      public function StrikeAndExitMapInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc23_:Ship = null;
         var _loc2_:StrikeAndExitInfoProxy = retrieveProxy(GuiConstants.STRIKE_AND_EXIT_INFO) as StrikeAndExitInfoProxy;
         if(!_loc2_)
         {
            if(StrikeAndExitMapInfoCommandHandler.count == 0)
            {
               ++StrikeAndExitMapInfoCommandHandler.count;
               this.tryCreate();
            }
            return;
         }
         var _loc3_:IWindow = GuiManager.instance.getWindow(GuiConstants.STRIKE_AND_EXIT_INFO);
         if(Boolean(_loc3_) && !_loc3_.maximized)
         {
            _loc3_.maximize();
         }
         var _loc4_:StrikeAndExitMapInfoCommand = param1.getBody() as StrikeAndExitMapInfoCommand;
         var _loc5_:int = _loc4_.nextSpawnSeconds;
         var _loc6_:String = _loc4_.boxType;
         var _loc7_:int = _loc4_.boxRemainingQuantity;
         var _loc8_:int = _loc4_.npcTypes[0];
         var _loc9_:int = _loc4_.npcRemainingQuantity[0];
         var _loc10_:int = _loc4_.npcTypes[1];
         var _loc11_:int = _loc4_.npcRemainingQuantity[1];
         var _loc12_:int = _loc4_.npcTypes[2];
         var _loc13_:int = _loc4_.npcRemainingQuantity[2];
         var _loc14_:int = _loc4_.nextSpawnBossSeconds;
         var _loc15_:int = _loc4_.bossType;
         var _loc16_:Boolean = _loc4_.bossAlive;
         var _loc17_:String = _loc4_.spotLightUserName;
         var _loc18_:int = _loc4_.spotLightUserX;
         var _loc19_:int = _loc4_.spotLightUserY;
         var _loc20_:int = _loc4_.stellarCoinLimit;
         var _loc21_:int = _loc4_.remainingTime;
         var _loc22_:int = 0;
         if(map != null)
         {
            _loc23_ = map.hero;
            if((Boolean(_loc23_)) && Boolean(_loc23_.info) && Boolean(_loc23_.info.saeScore))
            {
               _loc22_ = _loc23_.info.saeScore.value;
            }
         }
         _loc2_.viewData.update(_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,_loc16_,_loc17_,_loc18_,_loc19_,_loc20_,_loc22_,_loc21_);
      }
      
      private function tryCreate() : Boolean
      {
         var windowId:String = null;
         var window:IWindow = null;
         var creationVO:SimpleWindowCreationVO = null;
         try
         {
            windowId = GuiConstants.STRIKE_AND_EXIT_INFO;
            window = GuiManager.instance.getWindow(windowId);
            if(!window)
            {
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

