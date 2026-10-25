package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SeasonPassRewardUnclaimedInfoCommand implements IModule
   {
      
      private static var _instance:SeasonPassRewardUnclaimedInfoCommand;
      
      public var captainLimit:int = 0;
      
      public var captainWarning:Boolean = false;
      
      public var spcId:int = 0;
      
      public var marketingImage:String = "";
      
      public var captainPending:int = 0;
      
      public var captainOwned:Number = 0;
      
      public var seasonName:String = "";
      
      public function SeasonPassRewardUnclaimedInfoCommand(param1:int = 0, param2:String = "", param3:String = "", param4:Boolean = false, param5:int = 0, param6:Number = 0, param7:int = 0)
      {
         super();
         this.captainLimit = param7;
         this.captainWarning = param4;
         this.spcId = param1;
         this.marketingImage = param3;
         this.captainPending = param5;
         this.captainOwned = param6;
         this.seasonName = param2;
      }
      
      public static function get instance() : SeasonPassRewardUnclaimedInfoCommand
      {
         return _instance || (_instance = new SeasonPassRewardUnclaimedInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -8237;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 25;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.captainLimit = param1.readInt();
         this.captainLimit = this.captainLimit >>> 11 % 32 | this.captainLimit << 32 - 11 % 32;
         this.captainWarning = param1.readBoolean();
         this.spcId = param1.readInt();
         this.spcId = this.spcId >>> 16 % 32 | this.spcId << 32 - 16 % 32;
         this.marketingImage = param1.readUTF();
         this.captainPending = param1.readInt();
         this.captainPending = this.captainPending << 10 % 32 | this.captainPending >>> 32 - 10 % 32;
         this.captainOwned = param1.readDouble();
         this.seasonName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-8237);
         param1.writeInt(this.captainLimit << 11 % 32 | this.captainLimit >>> 32 - 11 % 32);
         param1.writeBoolean(this.captainWarning);
         param1.writeInt(this.spcId << 16 % 32 | this.spcId >>> 32 - 16 % 32);
         param1.writeUTF(this.marketingImage);
         param1.writeInt(this.captainPending >>> 10 % 32 | this.captainPending << 32 - 10 % 32);
         param1.writeDouble(this.captainOwned);
         param1.writeUTF(this.seasonName);
      }
   }
}

