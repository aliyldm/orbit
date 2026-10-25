package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MiniClientRewardInfoCommand implements IModule
   {
      
      private static var _instance:MiniClientRewardInfoCommand;
      
      public var rewardList:Vector.<MiniClientItemRewardModule>;
      
      public var isClaimable:Boolean = false;
      
      public var timeToEndEvent:Number = 0;
      
      public var daysClaimed:int = 0;
      
      public function MiniClientRewardInfoCommand(param1:Vector.<MiniClientItemRewardModule> = null, param2:int = 0, param3:Number = 0, param4:Boolean = false)
      {
         super();
         if(param1 == null)
         {
            this.rewardList = new Vector.<MiniClientItemRewardModule>();
         }
         else
         {
            this.rewardList = param1;
         }
         this.isClaimable = param4;
         this.timeToEndEvent = param3;
         this.daysClaimed = param2;
      }
      
      public static function get instance() : MiniClientRewardInfoCommand
      {
         return _instance || (_instance = new MiniClientRewardInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3292;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 15;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:MiniClientItemRewardModule = null;
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
            _loc4_ = MiniClientItemRewardModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.rewardList.push(_loc4_);
            _loc2_++;
         }
         this.isClaimable = param1.readBoolean();
         this.timeToEndEvent = param1.readDouble();
         this.daysClaimed = param1.readShort();
         this.daysClaimed = 0xFFFF & ((0xFFFF & this.daysClaimed) >>> 13 % 16 | (0xFFFF & this.daysClaimed) << 16 - 13 % 16);
         this.daysClaimed = this.daysClaimed > 32767 ? int(this.daysClaimed - 65536) : this.daysClaimed;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:MiniClientItemRewardModule = null;
         param1.writeShort(3292);
         param1.writeByte(this.rewardList.length);
         for each(_loc2_ in this.rewardList)
         {
            _loc2_.write(param1);
         }
         param1.writeBoolean(this.isClaimable);
         param1.writeDouble(this.timeToEndEvent);
         param1.writeShort(0xFFFF & ((0xFFFF & this.daysClaimed) << 13 % 16 | (0xFFFF & this.daysClaimed) >>> 16 - 13 % 16));
      }
   }
}

