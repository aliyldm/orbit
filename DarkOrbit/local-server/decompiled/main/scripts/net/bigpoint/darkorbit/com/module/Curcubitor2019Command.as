package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class Curcubitor2019Command implements IModule
   {
      
      private static var _instance:Curcubitor2019Command;
      
      public var bossCount:int = 0;
      
      public var curcubitorLeftToKill:int = 0;
      
      public var timeToNext:Number = 0;
      
      public function Curcubitor2019Command(param1:int = 0, param2:int = 0, param3:Number = 0)
      {
         super();
         this.bossCount = param2;
         this.curcubitorLeftToKill = param1;
         this.timeToNext = param3;
      }
      
      public static function get instance() : Curcubitor2019Command
      {
         return _instance || (_instance = new Curcubitor2019Command());
      }
      
      public function getLibcomModuleId() : int
      {
         return -17717;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.bossCount = param1.readInt();
         this.bossCount = this.bossCount >>> 9 % 32 | this.bossCount << 32 - 9 % 32;
         this.curcubitorLeftToKill = param1.readInt();
         this.curcubitorLeftToKill = this.curcubitorLeftToKill >>> 12 % 32 | this.curcubitorLeftToKill << 32 - 12 % 32;
         this.timeToNext = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-17717);
         param1.writeInt(this.bossCount << 9 % 32 | this.bossCount >>> 32 - 9 % 32);
         param1.writeInt(this.curcubitorLeftToKill << 12 % 32 | this.curcubitorLeftToKill >>> 32 - 12 % 32);
         param1.writeDouble(this.timeToNext);
      }
   }
}

