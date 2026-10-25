package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SeasonPassRewardClaimRequest implements IModule
   {
      
      private static var _instance:SeasonPassRewardClaimRequest;
      
      public var level:int = 0;
      
      public var extGoldPass:Boolean = false;
      
      public var goldPass:Boolean = false;
      
      public function SeasonPassRewardClaimRequest(param1:int = 0, param2:Boolean = false, param3:Boolean = false)
      {
         super();
         this.level = param1;
         this.extGoldPass = param3;
         this.goldPass = param2;
      }
      
      public static function get instance() : SeasonPassRewardClaimRequest
      {
         return _instance || (_instance = new SeasonPassRewardClaimRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 8899;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.level = param1.readInt();
         this.level = this.level >>> 10 % 32 | this.level << 32 - 10 % 32;
         this.extGoldPass = param1.readBoolean();
         this.goldPass = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(8899);
         param1.writeInt(this.level << 10 % 32 | this.level >>> 32 - 10 % 32);
         param1.writeBoolean(this.extGoldPass);
         param1.writeBoolean(this.goldPass);
      }
   }
}

