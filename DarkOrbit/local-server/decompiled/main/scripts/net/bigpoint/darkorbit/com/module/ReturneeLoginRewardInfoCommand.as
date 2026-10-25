package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ReturneeLoginRewardInfoCommand implements IModule
   {
      
      private static var _instance:ReturneeLoginRewardInfoCommand;
      
      public var daysClaimed:int = 0;
      
      public var rewardList:Vector.<ReturneeLoginItemRewardModule>;
      
      public var timeToEndEvent:Number = 0;
      
      public var isClaimable:Boolean = false;
      
      public function ReturneeLoginRewardInfoCommand(param1:Vector.<ReturneeLoginItemRewardModule> = null, param2:int = 0, param3:Number = 0, param4:Boolean = false)
      {
         super();
         this.daysClaimed = param2;
         if(param1 == null)
         {
            this.rewardList = new Vector.<ReturneeLoginItemRewardModule>();
         }
         else
         {
            this.rewardList = param1;
         }
         this.timeToEndEvent = param3;
         this.isClaimable = param4;
      }
      
      public static function get instance() : ReturneeLoginRewardInfoCommand
      {
         return _instance || (_instance = new ReturneeLoginRewardInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 10175;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 15;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ReturneeLoginItemRewardModule = null;
         this.daysClaimed = param1.readShort();
         this.daysClaimed = 0xFFFF & ((0xFFFF & this.daysClaimed) >>> 15 % 16 | (0xFFFF & this.daysClaimed) << 16 - 15 % 16);
         this.daysClaimed = this.daysClaimed > 32767 ? int(this.daysClaimed - 65536) : this.daysClaimed;
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
            _loc4_ = ReturneeLoginItemRewardModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.rewardList.push(_loc4_);
            _loc2_++;
         }
         this.timeToEndEvent = param1.readDouble();
         this.isClaimable = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ReturneeLoginItemRewardModule = null;
         param1.writeShort(10175);
         param1.writeShort(0xFFFF & ((0xFFFF & this.daysClaimed) << 15 % 16 | (0xFFFF & this.daysClaimed) >>> 16 - 15 % 16));
         param1.writeByte(this.rewardList.length);
         for each(_loc2_ in this.rewardList)
         {
            _loc2_.write(param1);
         }
         param1.writeDouble(this.timeToEndEvent);
         param1.writeBoolean(this.isClaimable);
      }
   }
}

