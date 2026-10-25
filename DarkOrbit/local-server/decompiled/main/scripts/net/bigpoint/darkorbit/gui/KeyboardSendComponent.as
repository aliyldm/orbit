package net.bigpoint.darkorbit.gui
{
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.UserKeyBindingsModule;
   import net.bigpoint.darkorbit.com.module.UserKeyBindingsUpdate;
   import net.bigpoint.darkorbit.managers.keyboardManager.KeyValuePair;
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
   import net.bigpoint.darkorbit.net.ConnectionManager;
   
   public class KeyboardSendComponent
   {
      
      private static const NO_KEY:int = -1;
      
      private var _connectionManager:ConnectionManager;
      
      private var _deleteKeys:Vector.<KeyValuePair> = new Vector.<KeyValuePair>();
      
      private var commandNameLookup:Object;
      
      private var _addKeys:Vector.<KeyValuePair> = new Vector.<KeyValuePair>();
      
      public function KeyboardSendComponent(param1:ConnectionManager)
      {
         super();
         this._connectionManager = param1;
         this.commandNameLookup = new Object();
         this.commandNameLookup[ActivateLaserCommand.NAME] = UserKeyBindingsModule.ACTIONTYPE_ACTIVATE_LASER;
         this.commandNameLookup[ChangeConfingCommand.NAME] = UserKeyBindingsModule.ACTIONTYPE_CHANGE_CONFIG;
         this.commandNameLookup[JumpCommand.NAME] = UserKeyBindingsModule.ACTIONTYPE_JUMP;
         this.commandNameLookup[ActivateRocketCommand.NAME] = UserKeyBindingsModule.ACTIONTYPE_LAUNCH_ROCKET;
         this.commandNameLookup[ActivatePetCommand.NAME] = UserKeyBindingsModule.ACTIONTYPE_PET_ACTIVATE;
         this.commandNameLookup[GuardModeCommand.NAME] = UserKeyBindingsModule.ACTIONTYPE_PET_GUARD_MODE;
         this.commandNameLookup[ActivateSlotCommand.NAME] = UserKeyBindingsModule.ACTIONTYPE_QUICKSLOT;
         this.commandNameLookup[ActivatePremiumSlotCommand.NAME] = UserKeyBindingsModule.ACTIONTYPE_QUICKSLOT_PREMIUM;
         this.commandNameLookup[LogoutKeyboardCommand.NAME] = UserKeyBindingsModule.ACTIONTYPE_LOGOUT;
         this.commandNameLookup[ToggleDebugViewCommand.NAME] = UserKeyBindingsModule.ACTIONTYPE_PERFORMANCE_MONITORING;
         this.commandNameLookup[ToggleWindowsKeybordCommand.NAME] = UserKeyBindingsModule.ACTIONTYPE_TOGGLE_WINDOWS;
         this.commandNameLookup[ZoomInCommand.NAME] = UserKeyBindingsModule.ACTIONTYPE_ZOOM_IN;
         this.commandNameLookup[ZoomOutCommand.NAME] = UserKeyBindingsModule.ACTIONTYPE_ZOOM_OUT;
         this.commandNameLookup[PetRepairShipCommand.NAME] = UserKeyBindingsModule.ACTIONTYPE_PET_REPAIR_SHIP;
         this.commandNameLookup[FocusChatCommand.NAME] = UserKeyBindingsModule.ACTIONTYPE_FOCUS_CHAT;
         this.commandNameLookup[ToggleCategoryBarCommand.NAME] = UserKeyBindingsModule.ACTIONTYPE_TOGGLE_CATEGORY_BAR;
         this.commandNameLookup[ToggleProActionBarCommand.NAME] = UserKeyBindingsModule.ACTIONTYPE_TOGGLE_PRO_ACTION_BAR;
      }
      
      public function addDeleteKey(param1:KeyValuePair) : void
      {
         this._deleteKeys.push(param1);
      }
      
      public function addAddKey(param1:KeyValuePair) : void
      {
         this._addKeys.push(param1);
      }
      
      public function addKeys() : void
      {
         var _loc1_:IModule = null;
         if(this._addKeys.length > 0)
         {
            _loc1_ = this.buildAddRequest();
            this._addKeys.length = 0;
            this._connectionManager.sendRequest(_loc1_);
         }
      }
      
      private function buildAddRequest() : IModule
      {
         var _loc1_:Vector.<UserKeyBindingsModule> = new Vector.<UserKeyBindingsModule>();
         var _loc2_:int = 0;
         while(_loc2_ < this._addKeys.length)
         {
            _loc1_.push(new UserKeyBindingsModule(this.commandNameLookup[this._addKeys[_loc2_].name],this._addKeys[_loc2_].keys,int(this._addKeys[_loc2_].args[0])));
            _loc2_++;
         }
         return new UserKeyBindingsUpdate(_loc1_);
      }
      
      public function deleteKeys() : void
      {
         var _loc1_:IModule = null;
         if(this._deleteKeys.length > 0)
         {
            _loc1_ = this.buildDeleteRequest();
            this._deleteKeys.length = 0;
            this._connectionManager.sendRequest(_loc1_);
         }
      }
      
      private function buildDeleteRequest() : IModule
      {
         var _loc1_:Vector.<UserKeyBindingsModule> = new Vector.<UserKeyBindingsModule>();
         var _loc2_:int = 0;
         while(_loc2_ < this._deleteKeys.length)
         {
            _loc1_.push(new UserKeyBindingsModule(this.commandNameLookup[this._deleteKeys[_loc2_].name],new <int>[NO_KEY],int(this._deleteKeys[_loc2_].args[0])));
            _loc2_++;
         }
         return new UserKeyBindingsUpdate(_loc1_);
      }
   }
}

