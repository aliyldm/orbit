package net.bigpoint.darkorbit.net
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.com.module.CombatStateCommand;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.impl.DamageReceivedEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.SpaceBall;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.net.netty.handlers.combat.AttackTypeMap;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class CombatAssembly
   {
      
      private var main:Main;
      
      public function CombatAssembly()
      {
         super();
      }
      
      public static function log(param1:String) : void
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(param1));
      }
      
      public function setMain(param1:Main) : void
      {
         this.main = param1;
      }
      
      public function assembleAttackMissed(param1:int, param2:String, param3:int) : void
      {
         var _loc4_:Map = null;
         var _loc5_:Ship = null;
         if(param2 == AttackTypeMap.ROCKET)
         {
            return;
         }
         if(Settings.displayHitpointBubbles)
         {
            _loc4_ = this.main.screenManager.map;
            if(_loc4_ != null)
            {
               _loc5_ = _loc4_.getEntityById(param1) as Ship;
               if(_loc5_ != null && !(_loc5_ is SpaceBall))
               {
                  _loc4_.effects.addEffect(new DamageReceivedEffect(_loc5_,0,param3));
               }
            }
         }
      }
      
      public function assembleCombatState(param1:uint) : void
      {
         switch(param1)
         {
            case CombatStateCommand.COMBATSTATETYPE_ATTACK_STOPPED:
               this.assembleAttackStopped();
               break;
            case CombatStateCommand.COMBATSTATETYPE_ESCAPED:
               this.assembleCombatEcaped();
               break;
            case CombatStateCommand.COMBATSTATETYPE_FIGHT_IN_DMZ:
               this.assembleFightInDemilitarizedZone();
               break;
            case CombatStateCommand.COMBATSTATETYPE_TARGET_BACK_IN_RANGE:
               this.assembleTargetInRange();
               break;
            case CombatStateCommand.COMBATSTATETYPE_TARGET_OUT_OF_RANGE:
               this.assembleTargetOutOfRange();
               break;
            case CombatStateCommand.COMBATSTATETYPE_TARGET_REGISTERED_FOR_TG:
               this.assembleTargetRegisteredForTG();
               break;
            case CombatStateCommand.COMBATSTATETYPE_YOU_REGISTERED_FOR_TG:
               this.assembleYouRegisteredForTG();
               break;
            case CombatStateCommand.COMBATSTATETYPE_YOU_REGISTERED_FOR_TG_NO_TARGET:
               this.assembleYouRegisteredForTGNoTarget();
         }
      }
      
      private function assembleYouRegisteredForTGNoTarget() : void
      {
         log(BPLocale.getItem("log_msg_traininggrounds_cannot_deploy_mines"));
      }
      
      private function assembleAttackStopped() : void
      {
         log(BPLocale.getItem("fightcanceled"));
      }
      
      private function assembleFightInDemilitarizedZone() : void
      {
         log(BPLocale.getItem("peacearea"));
      }
      
      private function assembleCombatEcaped() : void
      {
         log(BPLocale.getItem("attescape"));
      }
      
      private function assembleTargetInRange() : void
      {
         log(BPLocale.getItem("fightcont"));
         var _loc1_:Map = this.main.screenManager.map;
         if(_loc1_ != null)
         {
         }
      }
      
      private function assembleTargetOutOfRange() : void
      {
         log(BPLocale.getItem("outofrange"));
      }
      
      private function assembleYouRegisteredForTG() : void
      {
         log(BPLocale.getItem("log_msg_traininggrounds_cannot_attack"));
      }
      
      private function assembleTargetRegisteredForTG() : void
      {
         log(BPLocale.getItem("log_msg_traininggrounds_cannot_be_attacked"));
      }
   }
}

