package net.bigpoint.darkorbit.mvc.settingsFUI.model
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ActivateLaserCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ActivatePetCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ActivatePremiumSlotCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ActivateRocketCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ActivateSlotCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ChangeConfingCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.FocusChatCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.GuardModeCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.JumpCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.LogoutKeyboardCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.PetRepairShipCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ToggleCategoryBarCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ToggleDebugViewCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ToggleProActionBarCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ToggleWindowsKeybordCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ZoomInCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ZoomOutCommand;
   
   public class SettingsKeyBindingItemVO
   {
      
      public static const NO_ACTION_NUMBER:int = -1;
      
      public static const SETTINGS_KEYBINDING_ID_QUICKSLOT_1:int = 5001;
      
      public static const SETTINGS_KEYBINDING_ID_QUICKSLOT_2:int = 5002;
      
      public static const SETTINGS_KEYBINDING_ID_QUICKSLOT_3:int = 5003;
      
      public static const SETTINGS_KEYBINDING_ID_QUICKSLOT_4:int = 5004;
      
      public static const SETTINGS_KEYBINDING_ID_QUICKSLOT_5:int = 5005;
      
      public static const SETTINGS_KEYBINDING_ID_QUICKSLOT_6:int = 5006;
      
      public static const SETTINGS_KEYBINDING_ID_QUICKSLOT_7:int = 5007;
      
      public static const SETTINGS_KEYBINDING_ID_QUICKSLOT_8:int = 5008;
      
      public static const SETTINGS_KEYBINDING_ID_QUICKSLOT_9:int = 5009;
      
      public static const SETTINGS_KEYBINDING_ID_QUICKSLOT_0:int = 5010;
      
      public static const SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_1:int = 5011;
      
      public static const SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_2:int = 5012;
      
      public static const SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_3:int = 5013;
      
      public static const SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_4:int = 5014;
      
      public static const SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_5:int = 5015;
      
      public static const SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_6:int = 5016;
      
      public static const SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_7:int = 5017;
      
      public static const SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_8:int = 5018;
      
      public static const SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_9:int = 5019;
      
      public static const SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_0:int = 5034;
      
      public static const SETTINGS_KEYBINDING_ID_ACTIVATE_JUMP_GATE:int = 5020;
      
      public static const SETTINGS_KEYBINDING_ID_SWITCH_CONFIG:int = 5021;
      
      public static const SETTINGS_KEYBINDING_ID_LASER_ATTACK:int = 5022;
      
      public static const SETTINGS_KEYBINDING_ID_ROCKET_ATTACK:int = 5023;
      
      public static const SETTINGS_KEYBINDING_ID_PET_ACTIVATE:int = 5024;
      
      public static const SETTINGS_KEYBINDING_ID_PET_GUARD_MODE:int = 5025;
      
      public static const SETTINGS_KEYBINDING_ID_PET_REPAIR_SHIP:int = 5026;
      
      public static const SETTINGS_KEYBINDING_ID_LOGOUT:int = 5027;
      
      public static const SETTINGS_KEYBINDING_ID_MINIMIZE_MAXIMIZE_ALL_WINDOWS:int = 5028;
      
      public static const SETTINGS_KEYBINDING_ID_TOGGLE_DISPLAY_FPS:int = 5029;
      
      public static const SETTINGS_KEYBINDING_ID_ZOOM_IN:int = 5030;
      
      public static const SETTINGS_KEYBINDING_ID_ZOOM_OUT:int = 5031;
      
      public static const SETTINGS_KEYBINDING_ID_FOCUS_CHAT:int = 5032;
      
      public static const SETTINGS_KEYBINDING_ID_CATEGORY_BAR:int = 5033;
      
      public static const SETTINGS_KEYBINDING_ID_SHOW_PRO_ACTION_BAR:int = 5044;
      
      private var _keybindingActionID:int;
      
      private var _actionKey:String;
      
      private var _boundKeyCode:int;
      
      private var _additionalActionNumber:int;
      
      public function SettingsKeyBindingItemVO(param1:int, param2:String, param3:int = -1, param4:int = -1)
      {
         super();
         this._keybindingActionID = param1;
         this._actionKey = param2;
         this._boundKeyCode = param3;
         this._additionalActionNumber = param4;
      }
      
      public static function actionIDToCommandName(param1:int) : String
      {
         var _loc2_:Dictionary = new Dictionary();
         _loc2_[SETTINGS_KEYBINDING_ID_ACTIVATE_JUMP_GATE] = JumpCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_CATEGORY_BAR] = ToggleCategoryBarCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_FOCUS_CHAT] = FocusChatCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_LASER_ATTACK] = ActivateLaserCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_LOGOUT] = LogoutKeyboardCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_MINIMIZE_MAXIMIZE_ALL_WINDOWS] = ToggleWindowsKeybordCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_PET_ACTIVATE] = ActivatePetCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_PET_GUARD_MODE] = GuardModeCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_PET_REPAIR_SHIP] = PetRepairShipCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_QUICKSLOT_0] = ActivateSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_QUICKSLOT_1] = ActivateSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_QUICKSLOT_2] = ActivateSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_QUICKSLOT_3] = ActivateSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_QUICKSLOT_4] = ActivateSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_QUICKSLOT_5] = ActivateSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_QUICKSLOT_6] = ActivateSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_QUICKSLOT_7] = ActivateSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_QUICKSLOT_8] = ActivateSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_QUICKSLOT_9] = ActivateSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_0] = ActivatePremiumSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_1] = ActivatePremiumSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_2] = ActivatePremiumSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_3] = ActivatePremiumSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_4] = ActivatePremiumSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_5] = ActivatePremiumSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_6] = ActivatePremiumSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_7] = ActivatePremiumSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_8] = ActivatePremiumSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_9] = ActivatePremiumSlotCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_ROCKET_ATTACK] = ActivateRocketCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_SWITCH_CONFIG] = ChangeConfingCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_TOGGLE_DISPLAY_FPS] = ToggleDebugViewCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_ZOOM_IN] = ZoomInCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_ZOOM_OUT] = ZoomOutCommand.NAME;
         _loc2_[SETTINGS_KEYBINDING_ID_SHOW_PRO_ACTION_BAR] = ToggleProActionBarCommand.NAME;
         return _loc2_[param1];
      }
      
      public static function commandNameToActionIds(param1:String) : Vector.<int>
      {
         var _loc2_:Dictionary = new Dictionary();
         _loc2_[JumpCommand.NAME] = new <int>[SETTINGS_KEYBINDING_ID_ACTIVATE_JUMP_GATE];
         _loc2_[ToggleCategoryBarCommand.NAME] = new <int>[SETTINGS_KEYBINDING_ID_CATEGORY_BAR];
         _loc2_[FocusChatCommand.NAME] = new <int>[SETTINGS_KEYBINDING_ID_FOCUS_CHAT];
         _loc2_[ActivateLaserCommand.NAME] = new <int>[SETTINGS_KEYBINDING_ID_LASER_ATTACK];
         _loc2_[LogoutKeyboardCommand.NAME] = new <int>[SETTINGS_KEYBINDING_ID_LOGOUT];
         _loc2_[ToggleWindowsKeybordCommand.NAME] = new <int>[SETTINGS_KEYBINDING_ID_MINIMIZE_MAXIMIZE_ALL_WINDOWS];
         _loc2_[ActivatePetCommand.NAME] = new <int>[SETTINGS_KEYBINDING_ID_PET_ACTIVATE];
         _loc2_[GuardModeCommand.NAME] = new <int>[SETTINGS_KEYBINDING_ID_PET_GUARD_MODE];
         _loc2_[PetRepairShipCommand.NAME] = new <int>[SETTINGS_KEYBINDING_ID_PET_REPAIR_SHIP];
         _loc2_[ActivateSlotCommand.NAME] = new <int>[SETTINGS_KEYBINDING_ID_QUICKSLOT_1,SETTINGS_KEYBINDING_ID_QUICKSLOT_2,SETTINGS_KEYBINDING_ID_QUICKSLOT_3,SETTINGS_KEYBINDING_ID_QUICKSLOT_4,SETTINGS_KEYBINDING_ID_QUICKSLOT_5,SETTINGS_KEYBINDING_ID_QUICKSLOT_6,SETTINGS_KEYBINDING_ID_QUICKSLOT_7,SETTINGS_KEYBINDING_ID_QUICKSLOT_8,SETTINGS_KEYBINDING_ID_QUICKSLOT_9,SETTINGS_KEYBINDING_ID_QUICKSLOT_0];
         _loc2_[ActivatePremiumSlotCommand.NAME] = new <int>[SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_1,SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_2,SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_3,SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_4,SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_5,SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_6,SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_7,SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_8,SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_9,SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_0];
         _loc2_[ActivateRocketCommand.NAME] = new <int>[SETTINGS_KEYBINDING_ID_ROCKET_ATTACK];
         _loc2_[ChangeConfingCommand.NAME] = new <int>[SETTINGS_KEYBINDING_ID_SWITCH_CONFIG];
         _loc2_[ToggleDebugViewCommand.NAME] = new <int>[SETTINGS_KEYBINDING_ID_TOGGLE_DISPLAY_FPS];
         _loc2_[ZoomInCommand.NAME] = new <int>[SETTINGS_KEYBINDING_ID_ZOOM_IN];
         _loc2_[ZoomOutCommand.NAME] = new <int>[SETTINGS_KEYBINDING_ID_ZOOM_OUT];
         _loc2_[ToggleProActionBarCommand.NAME] = new <int>[SETTINGS_KEYBINDING_ID_SHOW_PRO_ACTION_BAR];
         return _loc2_[param1];
      }
      
      public function get keybindingActionID() : int
      {
         return this._keybindingActionID;
      }
      
      public function set keybindingActionID(param1:int) : void
      {
         this._keybindingActionID = param1;
      }
      
      public function get actionKey() : String
      {
         return this._actionKey;
      }
      
      public function set actionKey(param1:String) : void
      {
         this._actionKey = param1;
      }
      
      public function get boundKeyCode() : int
      {
         return this._boundKeyCode;
      }
      
      public function set boundKeyCode(param1:int) : void
      {
         this._boundKeyCode = param1;
      }
      
      public function get additionalActionNumber() : int
      {
         return this._additionalActionNumber;
      }
   }
}

