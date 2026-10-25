package net.bigpoint.darkorbit.com.module.porting.birthday2025
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.events.*;
   
   public class Birthday2025PointRewardCommand implements IModule
   {
      
      private static var _instance:Birthday2025PointRewardCommand;
      
      public var openWindow:Boolean = false;
      
      public var curRewardLevel:int = 0;
      
      public var lootShowCommandList:Vector.<EventLootShowCommand>;
      
      public var claimedIndexes:Vector.<int>;
      
      public var curLevelPoints:int = 0;
      
      public var curPoints:int = 0;
      
      public function Birthday2025PointRewardCommand(param1:int = 0, param2:int = 0, param3:Vector.<EventLootShowCommand> = null, param4:Vector.<int> = null, param5:int = 0, param6:Boolean = false)
      {
         super();
         this.openWindow = param6;
         this.curRewardLevel = param5;
         if(param3 == null)
         {
            this.lootShowCommandList = new Vector.<EventLootShowCommand>();
         }
         else
         {
            this.lootShowCommandList = param3;
         }
         if(param4 == null)
         {
            this.claimedIndexes = new Vector.<int>();
         }
         else
         {
            this.claimedIndexes = param4;
         }
         this.curLevelPoints = param2;
         this.curPoints = param1;
      }
      
      public static function get instance() : Birthday2025PointRewardCommand
      {
         return _instance || (_instance = new Birthday2025PointRewardCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2833;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 21;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:EventLootShowCommand = null;
         var _loc5_:int = 0;
         this.openWindow = param1.readBoolean();
         this.curRewardLevel = param1.readInt();
         this.curRewardLevel = this.curRewardLevel << 14 % 32 | this.curRewardLevel >>> 32 - 14 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.lootShowCommandList.length > 0)
         {
            this.lootShowCommandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = EventLootShowCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.lootShowCommandList.push(_loc4_);
            _loc2_++;
         }
         while(this.claimedIndexes.length > 0)
         {
            this.claimedIndexes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = param1.readInt();
            _loc5_ = _loc5_ << 14 % 32 | _loc5_ >>> 32 - 14 % 32;
            this.claimedIndexes.push(_loc5_);
            _loc2_++;
         }
         this.curLevelPoints = param1.readInt();
         this.curLevelPoints = this.curLevelPoints >>> 14 % 32 | this.curLevelPoints << 32 - 14 % 32;
         this.curPoints = param1.readInt();
         this.curPoints = this.curPoints >>> 7 % 32 | this.curPoints << 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:EventLootShowCommand = null;
         var _loc3_:int = 0;
         param1.writeShort(2833);
         param1.writeBoolean(this.openWindow);
         param1.writeInt(this.curRewardLevel >>> 14 % 32 | this.curRewardLevel << 32 - 14 % 32);
         param1.writeByte(this.lootShowCommandList.length);
         for each(_loc2_ in this.lootShowCommandList)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.claimedIndexes.length);
         for each(_loc3_ in this.claimedIndexes)
         {
            param1.writeInt(_loc3_ >>> 14 % 32 | _loc3_ << 32 - 14 % 32);
         }
         param1.writeInt(this.curLevelPoints << 14 % 32 | this.curLevelPoints >>> 32 - 14 % 32);
         param1.writeInt(this.curPoints << 7 % 32 | this.curPoints >>> 32 - 7 % 32);
      }
   }
}

