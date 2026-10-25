package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SeasonPassRewardClaimAllRequest implements IModule
   {
      
      private static var _instance:SeasonPassRewardClaimAllRequest;
      
      public var spcId:int = 0;
      
      public function SeasonPassRewardClaimAllRequest(param1:int = 0)
      {
         super();
         this.spcId = param1;
      }
      
      public static function get instance() : SeasonPassRewardClaimAllRequest
      {
         return _instance || (_instance = new SeasonPassRewardClaimAllRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 18132;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.spcId = param1.readInt();
         this.spcId = this.spcId >>> 6 % 32 | this.spcId << 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(18132);
         param1.writeInt(this.spcId << 6 % 32 | this.spcId >>> 32 - 6 % 32);
      }
   }
}

