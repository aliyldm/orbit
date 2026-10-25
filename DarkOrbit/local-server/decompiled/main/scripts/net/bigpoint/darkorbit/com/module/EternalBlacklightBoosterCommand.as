package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EternalBlacklightBoosterCommand implements IModule
   {
      
      private static var _instance:EternalBlacklightBoosterCommand;
      
      public static const BOOSTERTYPE_ABILITY_COOLDOWN_TIME:int = 0;
      
      public static const BOOSTERTYPE_DAMAGE:int = 1;
      
      public static const BOOSTERTYPE_DMG_LASER:int = 2;
      
      public static const BOOSTERTYPE_DMG_ROCKET:int = 3;
      
      public static const BOOSTERTYPE_HITCHANCE_LASER:int = 4;
      
      public static const BOOSTERTYPE_HITPOINTS:int = 5;
      
      public static const BOOSTERTYPE_SHIELD:int = 6;
      
      public static const BOOSTERTYPE_SPEED:int = 7;
      
      public static const BOOSTERTYPE__MAX:int = 8;
      
      public var value:int = 0;
      
      public var boosterType:int = 0;
      
      public function EternalBlacklightBoosterCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.value = param2;
         this.boosterType = param1;
      }
      
      public static function get instance() : EternalBlacklightBoosterCommand
      {
         return _instance || (_instance = new EternalBlacklightBoosterCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 27060;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.value = param1.readInt();
         this.value = this.value >>> 16 % 32 | this.value << 32 - 16 % 32;
         this.boosterType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(27060);
         param1.writeInt(this.value << 16 % 32 | this.value >>> 32 - 16 % 32);
         param1.writeShort(this.boosterType);
      }
   }
}

