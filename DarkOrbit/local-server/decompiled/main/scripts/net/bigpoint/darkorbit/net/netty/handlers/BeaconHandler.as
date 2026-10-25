package net.bigpoint.darkorbit.net.netty.handlers
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.BeaconCommand;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.AlertEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.RadiationEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.RepairRobotEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.application.model.ProfileProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.settings.Profiler;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class BeaconHandler extends SimpleCommand
   {
      
      private static var screenManager:ScreenManager;
      
      public static var inStation:BindableBoolean = new BindableBoolean(false);
      
      private static var _inRadiationZone:Boolean = false;
      
      private static var _repairBotActive:Boolean = false;
      
      private static var _isAlarmEffectActive:Boolean = false;
      
      public function BeaconHandler()
      {
         super();
      }
      
      public static function updateWarnings() : void
      {
         if(!screenManager || !screenManager.map)
         {
            return;
         }
         var _loc1_:Map = screenManager.map;
         var _loc2_:Ship = _loc1_.hero;
         if(!_loc2_)
         {
            _loc1_.effects.removeEffectById(AlertEffect.ID);
            return;
         }
         if(_inRadiationZone)
         {
            _loc1_.effects.addEffectOnce(new RadiationEffect());
            _loc1_.effects.addEffectOnce(new AlertEffect(BPLocale.getItem("radwarn_mid") + "\n" + BPLocale.getItem("radwarn_bot")));
         }
         else
         {
            _loc1_.effects.removeEffectById(RadiationEffect.ID);
            if(Settings.showLowHpWarnings && _loc2_.hp.hp.value < _loc2_.hp.maxHP.value * 0.2 && !_repairBotActive || _isAlarmEffectActive)
            {
               _loc1_.effects.addEffectOnce(new AlertEffect());
            }
            else
            {
               _loc1_.effects.removeEffectById(AlertEffect.ID);
            }
         }
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         if(!screenManager)
         {
            screenManager = ScreenManager.getInstance();
         }
         this.run(param1.getBody() as BeaconCommand);
      }
      
      private function setDemilitarizedZone(param1:Boolean) : void
      {
         var _loc2_:Profiler = null;
         if(param1)
         {
            GuiManager.instance.displayNAZ(true);
            _loc2_ = ProfileProxy(GameFacade.getInstance().retrieveProxy(ProfileProxy.NAME)).getProfiler();
            if(_loc2_.isNotificationInQueue)
            {
               _loc2_.showNotification();
            }
         }
         else
         {
            GuiManager.instance.displayNAZ(false);
         }
      }
      
      private function run(param1:BeaconCommand) : void
      {
         var _loc6_:SimpleWindow = null;
         var _loc2_:Map = screenManager.map;
         var _loc3_:GuiManager = GuiManager.instance;
         var _loc4_:Boolean = param1.inPeaceArea;
         _inRadiationZone = param1.inRadiationZone;
         _repairBotActive = param1.repairRobotActive;
         _isAlarmEffectActive = param1.isAlarmEffectActive;
         inStation.value = param1.inStation;
         this.setDemilitarizedZone(_loc4_);
         var _loc5_:Ship = _loc2_.hero;
         if(_loc5_ != null)
         {
            if(Boolean(_repairBotActive) && Boolean(param1.repairRobotLootId) && param1.repairRobotLootId.length > 0)
            {
               _loc2_.effects.addMapObjectEffectOnce(new RepairRobotEffect(EffectIDList.REP_BOT_EFFECT,_loc5_,param1.repairRobotLootId,param1.repairBotSkilled ? 1 : 0));
            }
            else
            {
               _loc2_.effects.removeEffectFromMapObject(_loc5_.id,EffectIDList.REP_BOT_EFFECT);
            }
         }
         if(_loc3_ != null)
         {
            _loc6_ = _loc3_.getWindow(GuiConstants.LOGOUT_WINDOW);
            if(_loc6_ != null && _loc6_.isMaximizeClicked())
            {
               return;
            }
         }
         updateWarnings();
      }
   }
}

