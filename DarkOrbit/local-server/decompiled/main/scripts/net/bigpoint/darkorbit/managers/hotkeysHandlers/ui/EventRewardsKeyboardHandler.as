package net.bigpoint.darkorbit.managers.hotkeysHandlers.ui
{
   import flash.ui.Keyboard;
   import net.bigpoint.darkorbit.com.module.EventRewardConfirmationCommand;
   import net.bigpoint.darkorbit.com.module.RewardAchievementModule;
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import net.bigpoint.darkorbit.com.module.RewardModule;
   import net.bigpoint.darkorbit.com.module.RewardTitleModule;
   import net.bigpoint.darkorbit.managers.hotkeysHandlers.general.AbstractKeyboardEventHandler;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.net.netty.HandlerLookup;
   
   public class EventRewardsKeyboardHandler extends AbstractKeyboardEventHandler
   {
      
      private static var _instance:EventRewardsKeyboardHandler;
      
      public function EventRewardsKeyboardHandler()
      {
         super();
      }
      
      public static function get instance() : EventRewardsKeyboardHandler
      {
         if(_instance == null)
         {
            _instance = new EventRewardsKeyboardHandler();
         }
         return _instance;
      }
      
      override protected function handleControlKeyRelated(param1:uint) : void
      {
         switch(param1)
         {
            case Keyboard.NUMBER_1:
               this.openWindow();
               break;
            case Keyboard.NUMBER_2:
               GameFacade.getInstance().sendNotification(GuiNotifications.MINIMIZE_WINDOW_BY_ID,GuiConstants.ALIEN_HUNT_WINDOW);
         }
      }
      
      private function openWindow() : void
      {
         var _loc1_:RewardModule = new RewardModule("ammunition_laser_ucb-100");
         var _loc2_:RewardModule = new RewardModule("ammunition_specialammo_emp-01");
         var _loc3_:RewardAchievementModule = new RewardAchievementModule("achievement_experience_2");
         var _loc4_:RewardAchievementModule = new RewardAchievementModule("achievement_experience_1");
         var _loc5_:RewardTitleModule = new RewardTitleModule("title_achievement_gatejumps");
         var _loc6_:RewardModule = new RewardModule("resource_collectable_indoctrineoil");
         var _loc7_:RewardModule = new RewardModule("resource_premium-weeks-2");
         var _loc8_:RewardModule = new RewardModule("equipment_weapon_laser_lf-4-hp");
         var _loc9_:Vector.<RewardContentModule> = new <RewardContentModule>[_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_];
         var _loc10_:int = Math.random() < 0.5 ? EventRewardConfirmationCommand.REWARDTYPE_HUNT_CLAN : EventRewardConfirmationCommand.REWARDTYPE_HUNT_PLAYER;
         var _loc11_:int = Math.random() * 20;
         var _loc12_:EventRewardConfirmationCommand = new EventRewardConfirmationCommand(_loc9_.slice(0,_loc11_),_loc11_,_loc10_);
         HandlerLookup.execute(_loc12_);
      }
   }
}

