package net.bigpoint.darkorbit.com.module.porting.shop.exchange
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.*;
   
   public class ExchangesShopItem implements IModule
   {
      
      private static var _instance:ExchangesShopItem;
      
      public var isSpecial:Boolean = false;
      
      public var costs:Vector.<RewardModule>;
      
      public var limitType:int = 0;
      
      public var reward:RewardModule;
      
      public var maxLimit:int = 0;
      
      public var limit:int = 0;
      
      public var eid:int = 0;
      
      public function ExchangesShopItem(param1:int = 0, param2:int = 0, param3:int = 0, param4:RewardModule = null, param5:int = 0, param6:Boolean = false, param7:Vector.<RewardModule> = null)
      {
         super();
         this.isSpecial = param6;
         if(param7 == null)
         {
            this.costs = new Vector.<RewardModule>();
         }
         else
         {
            this.costs = param7;
         }
         this.limitType = param5;
         if(param4 == null)
         {
            this.reward = new RewardModule();
         }
         else
         {
            this.reward = param4;
         }
         this.maxLimit = param3;
         this.limit = param2;
         this.eid = param1;
      }
      
      public static function get instance() : ExchangesShopItem
      {
         return _instance || (_instance = new ExchangesShopItem());
      }
      
      public function getLibcomModuleId() : int
      {
         return -15793;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 17;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RewardModule = null;
         this.isSpecial = param1.readBoolean();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.costs.length > 0)
         {
            this.costs.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RewardModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.costs.push(_loc4_);
            _loc2_++;
         }
         this.limitType = param1.readShort();
         this.reward = RewardModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.reward)
         {
            this.reward.read(param1);
         }
         this.maxLimit = param1.readInt();
         this.maxLimit = this.maxLimit >>> 12 % 32 | this.maxLimit << 32 - 12 % 32;
         this.limit = param1.readInt();
         this.limit = this.limit << 6 % 32 | this.limit >>> 32 - 6 % 32;
         this.eid = param1.readInt();
         this.eid = this.eid >>> 9 % 32 | this.eid << 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RewardModule = null;
         param1.writeShort(-15793);
         param1.writeBoolean(this.isSpecial);
         param1.writeByte(this.costs.length);
         for each(_loc2_ in this.costs)
         {
            _loc2_.write(param1);
         }
         param1.writeShort(this.limitType);
         if(null != this.reward)
         {
            this.reward.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.maxLimit << 12 % 32 | this.maxLimit >>> 32 - 12 % 32);
         param1.writeInt(this.limit >>> 6 % 32 | this.limit << 32 - 6 % 32);
         param1.writeInt(this.eid << 9 % 32 | this.eid >>> 32 - 9 % 32);
      }
   }
}

