package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class OutOfBattleStationRangeCommand implements IModule
   {
      
      private static var _instance:OutOfBattleStationRangeCommand;
      
      public var battleStationId:int = 0;
      
      public function OutOfBattleStationRangeCommand(param1:int = 0)
      {
         super();
         this.battleStationId = param1;
      }
      
      public static function get instance() : OutOfBattleStationRangeCommand
      {
         return _instance || (_instance = new OutOfBattleStationRangeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6015;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.battleStationId = param1.readInt();
         this.battleStationId = this.battleStationId >>> 1 % 32 | this.battleStationId << 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6015);
         param1.writeInt(this.battleStationId << 1 % 32 | this.battleStationId >>> 32 - 1 % 32);
      }
   }
}

