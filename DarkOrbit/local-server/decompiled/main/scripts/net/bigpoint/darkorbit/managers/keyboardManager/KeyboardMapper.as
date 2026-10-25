package net.bigpoint.darkorbit.managers.keyboardManager
{
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ActivateLaserCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ActivatePetCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ActivatePremiumSlotCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ActivateRocketCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ActivateSlotCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ChangeConfingCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.FocusChatCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.GuardModeCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.IKeyboardCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.JumpCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.LogoutKeyboardCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.PetRepairShipCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.PlaySoundEffectCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ToggleCategoryBarCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ToggleDebugViewCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ToggleProActionBarCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ToggleWindowsKeybordCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ZoomInCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.ZoomOutCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.parser.IKeyboardParser;
   import net.bigpoint.darkorbit.managers.keyboardManager.parser.KeyboardXmlParser;
   
   public class KeyboardMapper
   {
      
      private static var _instance:KeyboardMapper;
      
      private static const commandClassLookup:Object = new Object();
      
      commandClassLookup[ActivateSlotCommand.NAME] = ActivateSlotCommand;
      commandClassLookup[PlaySoundEffectCommand.NAME] = PlaySoundEffectCommand;
      commandClassLookup[JumpCommand.NAME] = JumpCommand;
      commandClassLookup[ChangeConfingCommand.NAME] = ChangeConfingCommand;
      commandClassLookup[LogoutKeyboardCommand.NAME] = LogoutKeyboardCommand;
      commandClassLookup[ActivatePetCommand.NAME] = ActivatePetCommand;
      commandClassLookup[GuardModeCommand.NAME] = GuardModeCommand;
      commandClassLookup[ActivateLaserCommand.NAME] = ActivateLaserCommand;
      commandClassLookup[ActivateRocketCommand.NAME] = ActivateRocketCommand;
      commandClassLookup[ToggleDebugViewCommand.NAME] = ToggleDebugViewCommand;
      commandClassLookup[ActivatePremiumSlotCommand.NAME] = ActivatePremiumSlotCommand;
      commandClassLookup[ToggleProActionBarCommand.NAME] = ToggleProActionBarCommand;
      commandClassLookup[ToggleWindowsKeybordCommand.NAME] = ToggleWindowsKeybordCommand;
      commandClassLookup[ZoomInCommand.NAME] = ZoomInCommand;
      commandClassLookup[ZoomOutCommand.NAME] = ZoomOutCommand;
      commandClassLookup[PetRepairShipCommand.NAME] = PetRepairShipCommand;
      commandClassLookup[FocusChatCommand.NAME] = FocusChatCommand;
      commandClassLookup[ToggleCategoryBarCommand.NAME] = ToggleCategoryBarCommand;
      
      private const maxKeyCode:int = 222;
      
      private var _commandMap:Array;
      
      private var _keymap:Object;
      
      public function KeyboardMapper(param1:HiddenClass)
      {
         super();
         if(param1 is HiddenClass)
         {
            this._keymap = new Object();
            this.createCommandLookup();
            return;
         }
         throw new Error("use getInstance. its a singleton");
      }
      
      public static function getInstance() : KeyboardMapper
      {
         if(!_instance)
         {
            _instance = new KeyboardMapper(new HiddenClass());
         }
         return _instance;
      }
      
      public function activateKey(param1:int) : void
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:Vector.<String> = null;
         var _loc6_:Class = null;
         var _loc2_:Vector.<Object> = this._keymap[param1.toString()];
         if(_loc2_ != null)
         {
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = _loc3_[KeyboardXmlParser.NAME];
               _loc5_ = _loc3_[KeyboardXmlParser.PARAMS][_loc4_];
               _loc6_ = commandClassLookup[_loc4_];
               if(_loc6_ != null)
               {
                  (new _loc6_() as IKeyboardCommand).execute(ScreenManager.getInstance().map,_loc5_);
                  return;
               }
            }
         }
      }
      
      public function addKeys(param1:IKeyboardParser) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Object = param1.parse();
         for(_loc3_ in _loc2_)
         {
            if(this._keymap[_loc3_] != undefined || this._keymap[_loc3_] != null)
            {
               this._keymap[_loc3_] = null;
            }
            this._keymap[_loc3_] = _loc2_[_loc3_];
         }
         this.createCommandLookup();
      }
      
      private function deleteKey(param1:int) : void
      {
         delete this._keymap[param1.toString()];
      }
      
      private function createCommandLookup() : void
      {
         var _loc1_:Vector.<Object> = null;
         var _loc2_:String = null;
         var _loc4_:Object = null;
         this.initCommandLookup();
         var _loc3_:int = 0;
         while(_loc3_ <= this.maxKeyCode)
         {
            _loc1_ = this._keymap[_loc3_.toString()];
            if(_loc1_)
            {
               for each(_loc4_ in _loc1_)
               {
                  _loc2_ = _loc4_[KeyboardXmlParser.NAME];
                  if(_loc2_)
                  {
                     Vector.<int>(this._commandMap[_loc2_]).push(_loc3_);
                  }
               }
            }
            _loc3_++;
         }
      }
      
      private function initCommandLookup() : void
      {
         var _loc1_:String = null;
         this._commandMap = [];
         for(_loc1_ in commandClassLookup)
         {
            this._commandMap[_loc1_] = new Vector.<int>();
         }
      }
      
      public function get commandMap() : Array
      {
         return this._commandMap;
      }
      
      public function getKeysOfCommand(param1:String) : Vector.<int>
      {
         return this._commandMap[param1] as Vector.<int>;
      }
      
      public function getKeysOfCommandWithParam(param1:String, param2:Vector.<String>) : Vector.<int>
      {
         var _loc5_:Vector.<String> = null;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc3_:Vector.<int> = this._commandMap[param1] as Vector.<int>;
         var _loc4_:Vector.<int> = new Vector.<int>();
         for each(_loc7_ in _loc3_)
         {
            for each(_loc8_ in this._keymap[_loc7_.toString()])
            {
               _loc5_ = _loc8_[KeyboardXmlParser.PARAMS][param1];
               if((Boolean(_loc5_)) && param2.length == _loc5_.length)
               {
                  _loc6_ = true;
                  _loc9_ = 0;
                  while(_loc9_ < param2.length)
                  {
                     if(param2[_loc9_] != _loc5_[_loc9_])
                     {
                        _loc6_ = false;
                     }
                     _loc9_++;
                  }
                  if(_loc6_)
                  {
                     _loc4_.push(_loc7_);
                  }
                  _loc6_ = false;
               }
            }
         }
         return _loc4_;
      }
      
      public function deleteKeys(param1:Vector.<int>) : void
      {
         var _loc2_:int = 0;
         for each(_loc2_ in param1)
         {
            this.deleteKey(_loc2_);
         }
         this.createCommandLookup();
      }
      
      public function cleanup() : void
      {
         this._keymap = new Object();
      }
   }
}

class HiddenClass
{
   
   public function HiddenClass()
   {
      super();
   }
}
