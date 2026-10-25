package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserKeyBindingsModule implements IModule
   {
      
      private static var _instance:UserKeyBindingsModule;
      
      public static const ACTIONTYPE_JUMP:int = 0;
      
      public static const ACTIONTYPE_CHANGE_CONFIG:int = 1;
      
      public static const ACTIONTYPE_ACTIVATE_LASER:int = 2;
      
      public static const ACTIONTYPE_LAUNCH_ROCKET:int = 3;
      
      public static const ACTIONTYPE_PET_ACTIVATE:int = 4;
      
      public static const ACTIONTYPE_PET_GUARD_MODE:int = 5;
      
      public static const ACTIONTYPE_LOGOUT:int = 6;
      
      public static const ACTIONTYPE_QUICKSLOT:int = 7;
      
      public static const ACTIONTYPE_QUICKSLOT_PREMIUM:int = 8;
      
      public static const ACTIONTYPE_TOGGLE_WINDOWS:int = 9;
      
      public static const ACTIONTYPE_PERFORMANCE_MONITORING:int = 10;
      
      public static const ACTIONTYPE_ZOOM_IN:int = 11;
      
      public static const ACTIONTYPE_ZOOM_OUT:int = 12;
      
      public static const ACTIONTYPE_PET_REPAIR_SHIP:int = 13;
      
      public static const ACTIONTYPE_FOCUS_CHAT:int = 14;
      
      public static const ACTIONTYPE_TOGGLE_CATEGORY_BAR:int = 15;
      
      public static const ACTIONTYPE_TOGGLE_PRO_ACTION_BAR:int = 16;
      
      public static const ACTIONTYPE_AUTO_ACTION_BAR:int = 17;
      
      public static const ACTIONTYPE__MAX:int = 18;
      
      public var actionType:int = 0;
      
      public var keyCodes:Vector.<int>;
      
      public var parameter:int = 0;
      
      public var charCode:int = 0;
      
      public function UserKeyBindingsModule(param1:int = 0, param2:Vector.<int> = null, param3:int = 0, param4:int = 0)
      {
         super();
         this.actionType = param1;
         if(param2 == null)
         {
            this.keyCodes = new Vector.<int>();
         }
         else
         {
            this.keyCodes = param2;
         }
         this.parameter = param3;
         this.charCode = param4;
      }
      
      public static function get instance() : UserKeyBindingsModule
      {
         return _instance || (_instance = new UserKeyBindingsModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 800;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.actionType = param1.readShort();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.keyCodes.length > 0)
         {
            this.keyCodes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 7 % 32 | _loc4_ >>> 32 - 7 % 32;
            this.keyCodes.push(_loc4_);
            _loc2_++;
         }
         this.parameter = param1.readInt();
         this.parameter = this.parameter << 14 % 32 | this.parameter >>> 32 - 14 % 32;
         this.charCode = param1.readShort();
         this.charCode = 0xFFFF & ((0xFFFF & this.charCode) >>> 14 % 16 | (0xFFFF & this.charCode) << 16 - 14 % 16);
         this.charCode = this.charCode > 32767 ? int(this.charCode - 65536) : this.charCode;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(800);
         param1.writeShort(this.actionType);
         param1.writeByte(this.keyCodes.length);
         for each(_loc2_ in this.keyCodes)
         {
            param1.writeInt(_loc2_ >>> 7 % 32 | _loc2_ << 32 - 7 % 32);
         }
         param1.writeInt(this.parameter >>> 14 % 32 | this.parameter << 32 - 14 % 32);
         param1.writeShort(0xFFFF & ((0xFFFF & this.charCode) << 14 % 16 | (0xFFFF & this.charCode) >>> 16 - 14 % 16));
      }
   }
}

