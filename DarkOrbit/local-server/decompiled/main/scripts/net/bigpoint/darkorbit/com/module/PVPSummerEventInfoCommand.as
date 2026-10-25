package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PVPSummerEventInfoCommand implements IModule
   {
      
      private static var _instance:PVPSummerEventInfoCommand;
      
      public var perKillRanges:Vector.<RankRewardRangeModule>;
      
      public var timeToNextFever:Number = 0;
      
      public var shuffleInfoCommand:PVPSummerEventShuffleInfoCommand;
      
      public var reputationRanges:Vector.<RankRewardRangeModule>;
      
      public var timeToEndFever:Number = 0;
      
      public var reputationUpdateCommand:PVPSummerEventSelfReputationUpdateCommand;
      
      public function PVPSummerEventInfoCommand(param1:PVPSummerEventSelfReputationUpdateCommand = null, param2:PVPSummerEventShuffleInfoCommand = null, param3:Vector.<RankRewardRangeModule> = null, param4:Vector.<RankRewardRangeModule> = null, param5:Number = 0, param6:Number = 0)
      {
         super();
         if(param4 == null)
         {
            this.perKillRanges = new Vector.<RankRewardRangeModule>();
         }
         else
         {
            this.perKillRanges = param4;
         }
         this.timeToNextFever = param6;
         if(param2 == null)
         {
            this.shuffleInfoCommand = new PVPSummerEventShuffleInfoCommand();
         }
         else
         {
            this.shuffleInfoCommand = param2;
         }
         if(param3 == null)
         {
            this.reputationRanges = new Vector.<RankRewardRangeModule>();
         }
         else
         {
            this.reputationRanges = param3;
         }
         this.timeToEndFever = param5;
         if(param1 == null)
         {
            this.reputationUpdateCommand = new PVPSummerEventSelfReputationUpdateCommand();
         }
         else
         {
            this.reputationUpdateCommand = param1;
         }
      }
      
      public static function get instance() : PVPSummerEventInfoCommand
      {
         return _instance || (_instance = new PVPSummerEventInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2371;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RankRewardRangeModule = null;
         var _loc5_:RankRewardRangeModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.perKillRanges.length > 0)
         {
            this.perKillRanges.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RankRewardRangeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.perKillRanges.push(_loc4_);
            _loc2_++;
         }
         this.timeToNextFever = param1.readDouble();
         this.shuffleInfoCommand = PVPSummerEventShuffleInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.shuffleInfoCommand)
         {
            this.shuffleInfoCommand.read(param1);
         }
         while(this.reputationRanges.length > 0)
         {
            this.reputationRanges.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = RankRewardRangeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.reputationRanges.push(_loc5_);
            _loc2_++;
         }
         this.timeToEndFever = param1.readDouble();
         this.reputationUpdateCommand = PVPSummerEventSelfReputationUpdateCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.reputationUpdateCommand)
         {
            this.reputationUpdateCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RankRewardRangeModule = null;
         var _loc3_:RankRewardRangeModule = null;
         param1.writeShort(2371);
         param1.writeByte(this.perKillRanges.length);
         for each(_loc2_ in this.perKillRanges)
         {
            _loc2_.write(param1);
         }
         param1.writeDouble(this.timeToNextFever);
         if(null != this.shuffleInfoCommand)
         {
            this.shuffleInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.reputationRanges.length);
         for each(_loc3_ in this.reputationRanges)
         {
            _loc3_.write(param1);
         }
         param1.writeDouble(this.timeToEndFever);
         if(null != this.reputationUpdateCommand)
         {
            this.reputationUpdateCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

