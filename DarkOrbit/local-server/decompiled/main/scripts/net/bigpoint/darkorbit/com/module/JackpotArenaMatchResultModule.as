package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class JackpotArenaMatchResultModule extends ArenaMatchResultModule
   {
      
      private static var _instance:JackpotArenaMatchResultModule;
      
      public var jackpotLosses:int = 0;
      
      public var jackpotWinRate:Number = 0;
      
      public var jackpotWins:int = 0;
      
      public function JackpotArenaMatchResultModule(param1:String = "", param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:Number = 0)
      {
         super(param1,param2,param3,param4,param5);
         this.jackpotLosses = param7;
         this.jackpotWinRate = param8;
         this.jackpotWins = param6;
      }
      
      public static function get instance() : JackpotArenaMatchResultModule
      {
         return _instance || (_instance = new JackpotArenaMatchResultModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -4321;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.jackpotLosses = param1.readInt();
         this.jackpotLosses = this.jackpotLosses << 11 % 32 | this.jackpotLosses >>> 32 - 11 % 32;
         this.jackpotWinRate = param1.readFloat();
         this.jackpotWins = param1.readInt();
         this.jackpotWins = this.jackpotWins >>> 4 % 32 | this.jackpotWins << 32 - 4 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-4321);
         super.write(param1);
         param1.writeInt(this.jackpotLosses >>> 11 % 32 | this.jackpotLosses << 32 - 11 % 32);
         param1.writeFloat(this.jackpotWinRate);
         param1.writeInt(this.jackpotWins << 4 % 32 | this.jackpotWins >>> 32 - 4 % 32);
      }
   }
}

