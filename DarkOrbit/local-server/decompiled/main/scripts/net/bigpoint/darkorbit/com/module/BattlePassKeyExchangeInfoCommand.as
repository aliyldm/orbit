package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattlePassKeyExchangeInfoCommand implements IModule
   {
      
      private static var _instance:BattlePassKeyExchangeInfoCommand;
      
      public static const EXCHANGETYPE_BattlePass:int = 0;
      
      public static const EXCHANGETYPE_ANewHope:int = 1;
      
      public static const EXCHANGETYPE_ReturnOfHero:int = 2;
      
      public static const EXCHANGETYPE__MAX:int = 3;
      
      public var rewardList:Vector.<BattlePassKeyExchangeRewardModule>;
      
      public var numOfKeys:int = 0;
      
      public var exchangeType:int = 0;
      
      public function BattlePassKeyExchangeInfoCommand(param1:Vector.<BattlePassKeyExchangeRewardModule> = null, param2:int = 0, param3:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.rewardList = new Vector.<BattlePassKeyExchangeRewardModule>();
         }
         else
         {
            this.rewardList = param1;
         }
         this.numOfKeys = param2;
         this.exchangeType = param3;
      }
      
      public static function get instance() : BattlePassKeyExchangeInfoCommand
      {
         return _instance || (_instance = new BattlePassKeyExchangeInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -24460;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:BattlePassKeyExchangeRewardModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.rewardList.length > 0)
         {
            this.rewardList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = BattlePassKeyExchangeRewardModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.rewardList.push(_loc4_);
            _loc2_++;
         }
         this.numOfKeys = param1.readInt();
         this.numOfKeys = this.numOfKeys << 5 % 32 | this.numOfKeys >>> 32 - 5 % 32;
         this.exchangeType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:BattlePassKeyExchangeRewardModule = null;
         param1.writeShort(-24460);
         param1.writeByte(this.rewardList.length);
         for each(_loc2_ in this.rewardList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.numOfKeys >>> 5 % 32 | this.numOfKeys << 32 - 5 % 32);
         param1.writeShort(this.exchangeType);
      }
   }
}

