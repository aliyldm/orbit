package net.bigpoint.darkorbit.com.module.porting.battlestation
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattleStationHistoryListRequest implements IModule
   {
      
      private static var _instance:BattleStationHistoryListRequest;
      
      public var startIndex:int = 0;
      
      public function BattleStationHistoryListRequest(param1:int = 0)
      {
         super();
         this.startIndex = param1;
      }
      
      public static function get instance() : BattleStationHistoryListRequest
      {
         return _instance || (_instance = new BattleStationHistoryListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -611;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.startIndex = param1.readInt();
         this.startIndex = this.startIndex >>> 5 % 32 | this.startIndex << 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-611);
         param1.writeInt(this.startIndex << 5 % 32 | this.startIndex >>> 32 - 5 % 32);
      }
   }
}

