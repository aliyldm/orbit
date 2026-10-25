package net.bigpoint.darkorbit.managers.keyboardManager.parser
{
   import net.bigpoint.darkorbit.com.module.UserKeyBindingsModule;
   import net.bigpoint.darkorbit.com.module.UserKeyBindingsUpdate;
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
   
   public class KeyMappingUpdateParser implements IKeyboardParser
   {
      
      private static const _commandNameLookup:Object = new Object();
      
      _commandNameLookup[UserKeyBindingsModule.ACTIONTYPE_ACTIVATE_LASER] = ActivateLaserCommand.NAME;
      _commandNameLookup[UserKeyBindingsModule.ACTIONTYPE_CHANGE_CONFIG] = ChangeConfingCommand.NAME;
      _commandNameLookup[UserKeyBindingsModule.ACTIONTYPE_JUMP] = JumpCommand.NAME;
      _commandNameLookup[UserKeyBindingsModule.ACTIONTYPE_LAUNCH_ROCKET] = ActivateRocketCommand.NAME;
      _commandNameLookup[UserKeyBindingsModule.ACTIONTYPE_PET_ACTIVATE] = ActivatePetCommand.NAME;
      _commandNameLookup[UserKeyBindingsModule.ACTIONTYPE_PET_GUARD_MODE] = GuardModeCommand.NAME;
      _commandNameLookup[UserKeyBindingsModule.ACTIONTYPE_QUICKSLOT] = ActivateSlotCommand.NAME;
      _commandNameLookup[UserKeyBindingsModule.ACTIONTYPE_QUICKSLOT_PREMIUM] = ActivatePremiumSlotCommand.NAME;
      _commandNameLookup[UserKeyBindingsModule.ACTIONTYPE_LOGOUT] = LogoutKeyboardCommand.NAME;
      _commandNameLookup[UserKeyBindingsModule.ACTIONTYPE_PERFORMANCE_MONITORING] = ToggleDebugViewCommand.NAME;
      _commandNameLookup[UserKeyBindingsModule.ACTIONTYPE_TOGGLE_WINDOWS] = ToggleWindowsKeybordCommand.NAME;
      _commandNameLookup[UserKeyBindingsModule.ACTIONTYPE_ZOOM_IN] = ZoomInCommand.NAME;
      _commandNameLookup[UserKeyBindingsModule.ACTIONTYPE_ZOOM_OUT] = ZoomOutCommand.NAME;
      _commandNameLookup[UserKeyBindingsModule.ACTIONTYPE_PET_REPAIR_SHIP] = PetRepairShipCommand.NAME;
      _commandNameLookup[UserKeyBindingsModule.ACTIONTYPE_FOCUS_CHAT] = FocusChatCommand.NAME;
      _commandNameLookup[UserKeyBindingsModule.ACTIONTYPE_TOGGLE_CATEGORY_BAR] = ToggleCategoryBarCommand.NAME;
      _commandNameLookup[UserKeyBindingsModule.ACTIONTYPE_TOGGLE_PRO_ACTION_BAR] = ToggleProActionBarCommand.NAME;
      
      private var _command:UserKeyBindingsUpdate;
      
      public function KeyMappingUpdateParser(param1:UserKeyBindingsUpdate)
      {
         super();
         this._command = param1;
      }
      
      public static function get commandNameLookup() : Object
      {
         return _commandNameLookup;
      }
      
      public function parse() : Object
      {
         var _loc2_:Vector.<String> = null;
         var _loc3_:UserKeyBindingsModule = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Vector.<Object> = null;
         var _loc1_:Object = new Object();
         for each(_loc3_ in this._command.changedKeyBindings)
         {
            for each(_loc4_ in _loc3_.keyCodes)
            {
               _loc5_ = _loc4_.toString();
               _loc1_[_loc5_] = new Vector.<Object>(1);
               _loc6_ = _loc1_[_loc5_] as Vector.<Object>;
               _loc6_[0] = new Object();
               _loc1_[_loc5_][0][KeyboardXmlParser.NAME] = _commandNameLookup[_loc3_.actionType];
               _loc2_ = new <String>[_loc3_.parameter.toString()];
               _loc1_[_loc5_][0][KeyboardXmlParser.PARAMS] = new Object();
               _loc1_[_loc5_][0][KeyboardXmlParser.PARAMS][_loc1_[_loc5_][0][KeyboardXmlParser.NAME]] = _loc2_;
            }
         }
         return _loc1_;
      }
   }
}

