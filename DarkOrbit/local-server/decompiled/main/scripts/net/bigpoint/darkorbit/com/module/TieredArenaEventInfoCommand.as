package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TieredArenaEventInfoCommand implements IModule
   {
      
      private static var _instance:TieredArenaEventInfoCommand;
      
      public var reputationUpdateCommand:TieredArenaEventSelfReputationUpdateCommand;
      
      public var timeToNextArenaOpen:Number = 0;
      
      public var timeToEventEnd:Number = 0;
      
      public var reputationRanges:Vector.<RankRewardRangeModule>;
      
      public var timeToArenaClose:Number = 0;
      
      public var tieredUpdateCommand:TieredArenaEventTierUpdateCommand;
      
      public function TieredArenaEventInfoCommand(param1:TieredArenaEventSelfReputationUpdateCommand = null, param2:TieredArenaEventTierUpdateCommand = null, param3:Vector.<RankRewardRangeModule> = null, param4:Number = 0, param5:Number = 0, param6:Number = 0)
      {
         super();
         if(param1 == null)
         {
            this.reputationUpdateCommand = new TieredArenaEventSelfReputationUpdateCommand();
         }
         else
         {
            this.reputationUpdateCommand = param1;
         }
         this.timeToNextArenaOpen = param5;
         this.timeToEventEnd = param6;
         if(param3 == null)
         {
            this.reputationRanges = new Vector.<RankRewardRangeModule>();
         }
         else
         {
            this.reputationRanges = param3;
         }
         this.timeToArenaClose = param4;
         if(param2 == null)
         {
            this.tieredUpdateCommand = new TieredArenaEventTierUpdateCommand();
         }
         else
         {
            this.tieredUpdateCommand = param2;
         }
      }
      
      public static function get instance() : TieredArenaEventInfoCommand
      {
         return _instance || (_instance = new TieredArenaEventInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 24128;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 28;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RankRewardRangeModule = null;
         this.reputationUpdateCommand = TieredArenaEventSelfReputationUpdateCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.reputationUpdateCommand)
         {
            this.reputationUpdateCommand.read(param1);
         }
         this.timeToNextArenaOpen = param1.readDouble();
         this.timeToEventEnd = param1.readDouble();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.reputationRanges.length > 0)
         {
            this.reputationRanges.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RankRewardRangeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.reputationRanges.push(_loc4_);
            _loc2_++;
         }
         this.timeToArenaClose = param1.readDouble();
         this.tieredUpdateCommand = TieredArenaEventTierUpdateCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.tieredUpdateCommand)
         {
            this.tieredUpdateCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RankRewardRangeModule = null;
         param1.writeShort(24128);
         if(null != this.reputationUpdateCommand)
         {
            this.reputationUpdateCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeDouble(this.timeToNextArenaOpen);
         param1.writeDouble(this.timeToEventEnd);
         param1.writeByte(this.reputationRanges.length);
         for each(_loc2_ in this.reputationRanges)
         {
            _loc2_.write(param1);
         }
         param1.writeDouble(this.timeToArenaClose);
         if(null != this.tieredUpdateCommand)
         {
            this.tieredUpdateCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

