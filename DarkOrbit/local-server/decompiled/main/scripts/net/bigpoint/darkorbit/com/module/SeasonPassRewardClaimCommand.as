package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SeasonPassRewardClaimCommand implements IModule
   {
      
      private static var _instance:SeasonPassRewardClaimCommand;
      
      public var extGoldPass:Boolean = false;
      
      public var goldPass:Boolean = false;
      
      public var claimed:Boolean = false;
      
      public var level:int = 0;
      
      public function SeasonPassRewardClaimCommand(param1:int = 0, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false)
      {
         super();
         this.extGoldPass = param4;
         this.goldPass = param2;
         this.claimed = param3;
         this.level = param1;
      }
      
      public static function get instance() : SeasonPassRewardClaimCommand
      {
         return _instance || (_instance = new SeasonPassRewardClaimCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -17601;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 7;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.extGoldPass = param1.readBoolean();
         this.goldPass = param1.readBoolean();
         this.claimed = param1.readBoolean();
         this.level = param1.readInt();
         this.level = this.level >>> 12 % 32 | this.level << 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-17601);
         param1.writeBoolean(this.extGoldPass);
         param1.writeBoolean(this.goldPass);
         param1.writeBoolean(this.claimed);
         param1.writeInt(this.level << 12 % 32 | this.level >>> 32 - 12 % 32);
      }
   }
}

