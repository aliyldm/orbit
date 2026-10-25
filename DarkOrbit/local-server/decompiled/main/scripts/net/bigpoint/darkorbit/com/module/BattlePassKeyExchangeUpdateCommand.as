package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattlePassKeyExchangeUpdateCommand implements IModule
   {
      
      private static var _instance:BattlePassKeyExchangeUpdateCommand;
      
      public var spcId:int = 0;
      
      public var numOfKeys:int = 0;
      
      public var claimCount:int = 0;
      
      public var exchangeReward:String = "";
      
      public var lootId:String = "";
      
      public function BattlePassKeyExchangeUpdateCommand(param1:String = "", param2:String = "", param3:int = 0, param4:int = 0, param5:int = 0)
      {
         super();
         this.spcId = param5;
         this.numOfKeys = param4;
         this.claimCount = param3;
         this.exchangeReward = param1;
         this.lootId = param2;
      }
      
      public static function get instance() : BattlePassKeyExchangeUpdateCommand
      {
         return _instance || (_instance = new BattlePassKeyExchangeUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -24325;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.spcId = param1.readInt();
         this.spcId = this.spcId >>> 1 % 32 | this.spcId << 32 - 1 % 32;
         this.numOfKeys = param1.readInt();
         this.numOfKeys = this.numOfKeys >>> 10 % 32 | this.numOfKeys << 32 - 10 % 32;
         this.claimCount = param1.readInt();
         this.claimCount = this.claimCount << 11 % 32 | this.claimCount >>> 32 - 11 % 32;
         this.exchangeReward = param1.readUTF();
         this.lootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-24325);
         param1.writeInt(this.spcId << 1 % 32 | this.spcId >>> 32 - 1 % 32);
         param1.writeInt(this.numOfKeys << 10 % 32 | this.numOfKeys >>> 32 - 10 % 32);
         param1.writeInt(this.claimCount >>> 11 % 32 | this.claimCount << 32 - 11 % 32);
         param1.writeUTF(this.exchangeReward);
         param1.writeUTF(this.lootId);
      }
   }
}

