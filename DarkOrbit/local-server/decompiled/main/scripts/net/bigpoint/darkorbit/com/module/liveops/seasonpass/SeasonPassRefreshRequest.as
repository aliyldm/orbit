package net.bigpoint.darkorbit.com.module.liveops.seasonpass
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SeasonPassRefreshRequest implements IModule
   {
      
      private static var _instance:SeasonPassRefreshRequest;
      
      public static const COSTTYPE_FREE_CHANCE:int = 0;
      
      public static const COSTTYPE_URIDIUM:int = 1;
      
      public static const COSTTYPE__MAX:int = 2;
      
      public var questId:int = 0;
      
      public var costType:int = 0;
      
      public function SeasonPassRefreshRequest(param1:int = 0, param2:int = 0)
      {
         super();
         this.questId = param2;
         this.costType = param1;
      }
      
      public static function get instance() : SeasonPassRefreshRequest
      {
         return _instance || (_instance = new SeasonPassRefreshRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -12901;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.questId = param1.readInt();
         this.questId = this.questId << 14 % 32 | this.questId >>> 32 - 14 % 32;
         this.costType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-12901);
         param1.writeInt(this.questId >>> 14 % 32 | this.questId << 32 - 14 % 32);
         param1.writeShort(this.costType);
      }
   }
}

