package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class VIPMerchantExchangeModule implements IModule
   {
      
      private static var _instance:VIPMerchantExchangeModule;
      
      public var claimLimit:int = 0;
      
      public var reward:VIPMerchantExchangeItemModule;
      
      public var priority:int = 0;
      
      public var isSpecial:Boolean = false;
      
      public var costs:Vector.<VIPMerchantExchangeItemModule>;
      
      public var claimCount:int = 0;
      
      public function VIPMerchantExchangeModule(param1:VIPMerchantExchangeItemModule = null, param2:Vector.<VIPMerchantExchangeItemModule> = null, param3:int = 0, param4:Boolean = false, param5:int = 0, param6:int = 0)
      {
         super();
         this.claimLimit = param6;
         if(param1 == null)
         {
            this.reward = new VIPMerchantExchangeItemModule();
         }
         else
         {
            this.reward = param1;
         }
         this.priority = param3;
         this.isSpecial = param4;
         if(param2 == null)
         {
            this.costs = new Vector.<VIPMerchantExchangeItemModule>();
         }
         else
         {
            this.costs = param2;
         }
         this.claimCount = param5;
      }
      
      public static function get instance() : VIPMerchantExchangeModule
      {
         return _instance || (_instance = new VIPMerchantExchangeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -27799;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 17;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:VIPMerchantExchangeItemModule = null;
         this.claimLimit = param1.readInt();
         this.claimLimit = this.claimLimit >>> 1 % 32 | this.claimLimit << 32 - 1 % 32;
         this.reward = VIPMerchantExchangeItemModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.reward)
         {
            this.reward.read(param1);
         }
         this.priority = param1.readInt();
         this.priority = this.priority << 9 % 32 | this.priority >>> 32 - 9 % 32;
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
            _loc4_ = VIPMerchantExchangeItemModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.costs.push(_loc4_);
            _loc2_++;
         }
         this.claimCount = param1.readInt();
         this.claimCount = this.claimCount >>> 12 % 32 | this.claimCount << 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:VIPMerchantExchangeItemModule = null;
         param1.writeShort(-27799);
         param1.writeInt(this.claimLimit << 1 % 32 | this.claimLimit >>> 32 - 1 % 32);
         if(null != this.reward)
         {
            this.reward.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.priority >>> 9 % 32 | this.priority << 32 - 9 % 32);
         param1.writeBoolean(this.isSpecial);
         param1.writeByte(this.costs.length);
         for each(_loc2_ in this.costs)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.claimCount << 12 % 32 | this.claimCount >>> 32 - 12 % 32);
      }
   }
}

