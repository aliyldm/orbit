package net.bigpoint.darkorbit.com.module.porting.publicWorldBoss
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.*;
   
   public class PublicWorldBossTier implements IModule
   {
      
      private static var _instance:PublicWorldBossTier;
      
      public var rewardModuleList:Vector.<RewardModule>;
      
      public var tierName:String = "";
      
      public var to:int = 0;
      
      public var rewardTitleModule:RewardTitleModule;
      
      public var from:int = 0;
      
      public function PublicWorldBossTier(param1:String = "", param2:int = 0, param3:int = 0, param4:Vector.<RewardModule> = null, param5:RewardTitleModule = null)
      {
         super();
         if(param4 == null)
         {
            this.rewardModuleList = new Vector.<RewardModule>();
         }
         else
         {
            this.rewardModuleList = param4;
         }
         this.tierName = param1;
         this.to = param3;
         if(param5 == null)
         {
            this.rewardTitleModule = new RewardTitleModule();
         }
         else
         {
            this.rewardTitleModule = param5;
         }
         this.from = param2;
      }
      
      public static function get instance() : PublicWorldBossTier
      {
         return _instance || (_instance = new PublicWorldBossTier());
      }
      
      public function getLibcomModuleId() : int
      {
         return -30908;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 14;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RewardModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.rewardModuleList.length > 0)
         {
            this.rewardModuleList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RewardModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.rewardModuleList.push(_loc4_);
            _loc2_++;
         }
         this.tierName = param1.readUTF();
         this.to = param1.readInt();
         this.to = this.to << 15 % 32 | this.to >>> 32 - 15 % 32;
         this.rewardTitleModule = RewardTitleModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.rewardTitleModule)
         {
            this.rewardTitleModule.read(param1);
         }
         this.from = param1.readInt();
         this.from = this.from << 15 % 32 | this.from >>> 32 - 15 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RewardModule = null;
         param1.writeShort(-30908);
         param1.writeByte(this.rewardModuleList.length);
         for each(_loc2_ in this.rewardModuleList)
         {
            _loc2_.write(param1);
         }
         param1.writeUTF(this.tierName);
         param1.writeInt(this.to >>> 15 % 32 | this.to << 32 - 15 % 32);
         if(null != this.rewardTitleModule)
         {
            this.rewardTitleModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.from >>> 15 % 32 | this.from << 32 - 15 % 32);
      }
   }
}

