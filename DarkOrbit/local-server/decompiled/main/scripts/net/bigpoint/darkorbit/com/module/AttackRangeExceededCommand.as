package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttackRangeExceededCommand implements IModule
   {
      
      private static var _instance:AttackRangeExceededCommand;
      
      public static const ATTACKTYPE_LASER:int = 0;
      
      public static const ATTACKTYPE_ROCKET:int = 1;
      
      public static const ATTACKTYPE_HELLSTORM:int = 2;
      
      public static const ATTACKTYPE_MISC:int = 3;
      
      public static const ATTACKTYPE_CANNON:int = 4;
      
      public static const ATTACKTYPE__MAX:int = 5;
      
      public var uid:int = 0;
      
      public var maxRange:int = 0;
      
      public var type:int = 0;
      
      public function AttackRangeExceededCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.uid = param3;
         this.maxRange = param2;
         this.type = param1;
      }
      
      public static function get instance() : AttackRangeExceededCommand
      {
         return _instance || (_instance = new AttackRangeExceededCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1059;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.uid = param1.readInt();
         this.uid = this.uid << 8 % 32 | this.uid >>> 32 - 8 % 32;
         this.maxRange = param1.readInt();
         this.maxRange = this.maxRange << 15 % 32 | this.maxRange >>> 32 - 15 % 32;
         this.type = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(1059);
         param1.writeInt(this.uid >>> 8 % 32 | this.uid << 32 - 8 % 32);
         param1.writeInt(this.maxRange >>> 15 % 32 | this.maxRange << 32 - 15 % 32);
         param1.writeShort(this.type);
      }
   }
}

