package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattlePassKeyExchangeRewardModule implements IModule
   {
      
      private static var _instance:BattlePassKeyExchangeRewardModule;
      
      public var cost:int = 0;
      
      public var limit:int = 0;
      
      public var exchangeReward:String = "";
      
      public var listOfloot:Vector.<BattlePassKeyExchangeLootModule>;
      
      public var priority:int = 0;
      
      public var isSpecial:Boolean = false;
      
      public var claimCount:int = 0;
      
      public function BattlePassKeyExchangeRewardModule(param1:String = "", param2:Vector.<BattlePassKeyExchangeLootModule> = null, param3:int = 0, param4:int = 0, param5:int = 0, param6:Boolean = false, param7:int = 0)
      {
         super();
         this.cost = param3;
         this.limit = param4;
         this.exchangeReward = param1;
         if(param2 == null)
         {
            this.listOfloot = new Vector.<BattlePassKeyExchangeLootModule>();
         }
         else
         {
            this.listOfloot = param2;
         }
         this.priority = param5;
         this.isSpecial = param6;
         this.claimCount = param7;
      }
      
      public static function get instance() : BattlePassKeyExchangeRewardModule
      {
         return _instance || (_instance = new BattlePassKeyExchangeRewardModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2237;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 23;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:BattlePassKeyExchangeLootModule = null;
         this.cost = param1.readInt();
         this.cost = this.cost >>> 8 % 32 | this.cost << 32 - 8 % 32;
         this.limit = param1.readInt();
         this.limit = this.limit >>> 6 % 32 | this.limit << 32 - 6 % 32;
         this.exchangeReward = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.listOfloot.length > 0)
         {
            this.listOfloot.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = BattlePassKeyExchangeLootModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.listOfloot.push(_loc4_);
            _loc2_++;
         }
         this.priority = param1.readInt();
         this.priority = this.priority << 13 % 32 | this.priority >>> 32 - 13 % 32;
         this.isSpecial = param1.readBoolean();
         this.claimCount = param1.readInt();
         this.claimCount = this.claimCount << 6 % 32 | this.claimCount >>> 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:BattlePassKeyExchangeLootModule = null;
         param1.writeShort(2237);
         param1.writeInt(this.cost << 8 % 32 | this.cost >>> 32 - 8 % 32);
         param1.writeInt(this.limit << 6 % 32 | this.limit >>> 32 - 6 % 32);
         param1.writeUTF(this.exchangeReward);
         param1.writeByte(this.listOfloot.length);
         for each(_loc2_ in this.listOfloot)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.priority >>> 13 % 32 | this.priority << 32 - 13 % 32);
         param1.writeBoolean(this.isSpecial);
         param1.writeInt(this.claimCount >>> 6 % 32 | this.claimCount << 32 - 6 % 32);
      }
   }
}

