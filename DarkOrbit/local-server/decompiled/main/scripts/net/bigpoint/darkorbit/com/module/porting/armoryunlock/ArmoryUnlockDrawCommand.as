package net.bigpoint.darkorbit.com.module.porting.armoryunlock
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.*;
   
   public class ArmoryUnlockDrawCommand implements IModule
   {
      
      private static var _instance:ArmoryUnlockDrawCommand;
      
      public var count:int = 0;
      
      public var rewardModuleList:Vector.<RewardModule>;
      
      public var type:int = 0;
      
      public function ArmoryUnlockDrawCommand(param1:int = 0, param2:int = 0, param3:Vector.<RewardModule> = null)
      {
         super();
         this.count = param2;
         if(param3 == null)
         {
            this.rewardModuleList = new Vector.<RewardModule>();
         }
         else
         {
            this.rewardModuleList = param3;
         }
         this.type = param1;
      }
      
      public static function get instance() : ArmoryUnlockDrawCommand
      {
         return _instance || (_instance = new ArmoryUnlockDrawCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4642;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RewardModule = null;
         this.count = param1.readInt();
         this.count = this.count >>> 11 % 32 | this.count << 32 - 11 % 32;
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
         this.type = param1.readInt();
         this.type = this.type << 6 % 32 | this.type >>> 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RewardModule = null;
         param1.writeShort(4642);
         param1.writeInt(this.count << 11 % 32 | this.count >>> 32 - 11 % 32);
         param1.writeByte(this.rewardModuleList.length);
         for each(_loc2_ in this.rewardModuleList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.type >>> 6 % 32 | this.type << 32 - 6 % 32);
      }
   }
}

