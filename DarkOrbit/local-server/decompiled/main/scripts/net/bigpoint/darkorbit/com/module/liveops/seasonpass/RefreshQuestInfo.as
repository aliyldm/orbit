package net.bigpoint.darkorbit.com.module.liveops.seasonpass
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RefreshQuestInfo implements IModule
   {
      
      private static var _instance:RefreshQuestInfo;
      
      public var nextDailyUridium:int = 0;
      
      public var weeklyCount:int = 0;
      
      public var dailyLeft:int = 0;
      
      public var dailyCount:int = 0;
      
      public var nextWeeklyUridium:int = 0;
      
      public var weeklyLeft:int = 0;
      
      public function RefreshQuestInfo(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0)
      {
         super();
         this.nextDailyUridium = param5;
         this.weeklyCount = param4;
         this.dailyLeft = param1;
         this.dailyCount = param2;
         this.nextWeeklyUridium = param6;
         this.weeklyLeft = param3;
      }
      
      public static function get instance() : RefreshQuestInfo
      {
         return _instance || (_instance = new RefreshQuestInfo());
      }
      
      public function getLibcomModuleId() : int
      {
         return -7148;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.nextDailyUridium = param1.readInt();
         this.nextDailyUridium = this.nextDailyUridium << 10 % 32 | this.nextDailyUridium >>> 32 - 10 % 32;
         this.weeklyCount = param1.readInt();
         this.weeklyCount = this.weeklyCount >>> 15 % 32 | this.weeklyCount << 32 - 15 % 32;
         this.dailyLeft = param1.readInt();
         this.dailyLeft = this.dailyLeft << 15 % 32 | this.dailyLeft >>> 32 - 15 % 32;
         this.dailyCount = param1.readInt();
         this.dailyCount = this.dailyCount << 16 % 32 | this.dailyCount >>> 32 - 16 % 32;
         this.nextWeeklyUridium = param1.readInt();
         this.nextWeeklyUridium = this.nextWeeklyUridium << 11 % 32 | this.nextWeeklyUridium >>> 32 - 11 % 32;
         this.weeklyLeft = param1.readInt();
         this.weeklyLeft = this.weeklyLeft >>> 1 % 32 | this.weeklyLeft << 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-7148);
         param1.writeInt(this.nextDailyUridium >>> 10 % 32 | this.nextDailyUridium << 32 - 10 % 32);
         param1.writeInt(this.weeklyCount << 15 % 32 | this.weeklyCount >>> 32 - 15 % 32);
         param1.writeInt(this.dailyLeft >>> 15 % 32 | this.dailyLeft << 32 - 15 % 32);
         param1.writeInt(this.dailyCount >>> 16 % 32 | this.dailyCount << 32 - 16 % 32);
         param1.writeInt(this.nextWeeklyUridium >>> 11 % 32 | this.nextWeeklyUridium << 32 - 11 % 32);
         param1.writeInt(this.weeklyLeft << 1 % 32 | this.weeklyLeft >>> 32 - 1 % 32);
      }
   }
}

