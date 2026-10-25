package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HealCommand implements IModule
   {
      
      private static var _instance:HealCommand;
      
      public static const HEALTYPE_HITPOINTS:int = 0;
      
      public static const HEALTYPE_SHIELD:int = 1;
      
      public static const HEALTYPE__MAX:int = 2;
      
      public var healType:int = 0;
      
      public var healerId:int = 0;
      
      public var healedId:int = 0;
      
      public var currentHitpoints:int = 0;
      
      public var healAmount:int = 0;
      
      public function HealCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0)
      {
         super();
         this.healType = param1;
         this.healerId = param2;
         this.healedId = param3;
         this.currentHitpoints = param4;
         this.healAmount = param5;
      }
      
      public static function get instance() : HealCommand
      {
         return _instance || (_instance = new HealCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 31;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.healType = param1.readShort();
         this.healerId = param1.readInt();
         this.healerId = this.healerId >>> 13 % 32 | this.healerId << 32 - 13 % 32;
         this.healedId = param1.readInt();
         this.healedId = this.healedId << 3 % 32 | this.healedId >>> 32 - 3 % 32;
         this.currentHitpoints = param1.readInt();
         this.currentHitpoints = this.currentHitpoints << 4 % 32 | this.currentHitpoints >>> 32 - 4 % 32;
         this.healAmount = param1.readInt();
         this.healAmount = this.healAmount << 7 % 32 | this.healAmount >>> 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(31);
         param1.writeShort(this.healType);
         param1.writeInt(this.healerId << 13 % 32 | this.healerId >>> 32 - 13 % 32);
         param1.writeInt(this.healedId >>> 3 % 32 | this.healedId << 32 - 3 % 32);
         param1.writeInt(this.currentHitpoints >>> 4 % 32 | this.currentHitpoints << 32 - 4 % 32);
         param1.writeInt(this.healAmount >>> 7 % 32 | this.healAmount << 32 - 7 % 32);
      }
   }
}

