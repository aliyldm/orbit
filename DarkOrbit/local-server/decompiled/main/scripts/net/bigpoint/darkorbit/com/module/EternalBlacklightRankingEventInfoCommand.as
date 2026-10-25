package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EternalBlacklightRankingEventInfoCommand implements IModule
   {
      
      private static var _instance:EternalBlacklightRankingEventInfoCommand;
      
      public var playerRankRanges:Vector.<RankRewardRangeModule>;
      
      public var rankInfoCommand:EternalBlacklightRankInfoCommand;
      
      public var isEventEnabled:Boolean = false;
      
      public function EternalBlacklightRankingEventInfoCommand(param1:Boolean = false, param2:Vector.<RankRewardRangeModule> = null, param3:EternalBlacklightRankInfoCommand = null)
      {
         super();
         if(param2 == null)
         {
            this.playerRankRanges = new Vector.<RankRewardRangeModule>();
         }
         else
         {
            this.playerRankRanges = param2;
         }
         if(param3 == null)
         {
            this.rankInfoCommand = new EternalBlacklightRankInfoCommand();
         }
         else
         {
            this.rankInfoCommand = param3;
         }
         this.isEventEnabled = param1;
      }
      
      public static function get instance() : EternalBlacklightRankingEventInfoCommand
      {
         return _instance || (_instance = new EternalBlacklightRankingEventInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 10857;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RankRewardRangeModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.playerRankRanges.length > 0)
         {
            this.playerRankRanges.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RankRewardRangeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.playerRankRanges.push(_loc4_);
            _loc2_++;
         }
         this.rankInfoCommand = EternalBlacklightRankInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.rankInfoCommand)
         {
            this.rankInfoCommand.read(param1);
         }
         this.isEventEnabled = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RankRewardRangeModule = null;
         param1.writeShort(10857);
         param1.writeByte(this.playerRankRanges.length);
         for each(_loc2_ in this.playerRankRanges)
         {
            _loc2_.write(param1);
         }
         if(null != this.rankInfoCommand)
         {
            this.rankInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.isEventEnabled);
      }
   }
}

