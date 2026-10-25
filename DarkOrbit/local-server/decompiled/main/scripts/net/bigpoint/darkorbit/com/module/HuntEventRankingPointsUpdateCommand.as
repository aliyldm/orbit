package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HuntEventRankingPointsUpdateCommand implements IModule
   {
      
      private static var _instance:HuntEventRankingPointsUpdateCommand;
      
      public static const UPDATEMODE_PLAYER:int = 0;
      
      public static const UPDATEMODE_CLAN:int = 1;
      
      public static const UPDATEMODE__MAX:int = 2;
      
      public var updateMode:int = 0;
      
      public var score:int = 0;
      
      public function HuntEventRankingPointsUpdateCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.updateMode = param1;
         this.score = param2;
      }
      
      public static function get instance() : HuntEventRankingPointsUpdateCommand
      {
         return _instance || (_instance = new HuntEventRankingPointsUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 194;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.updateMode = param1.readShort();
         this.score = param1.readInt();
         this.score = this.score << 1 % 32 | this.score >>> 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(194);
         param1.writeShort(this.updateMode);
         param1.writeInt(this.score >>> 1 % 32 | this.score << 32 - 1 % 32);
      }
   }
}

