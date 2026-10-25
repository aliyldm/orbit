package net.bigpoint.darkorbit.com.module.porting.dailylogin
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DailyLoginRewardDayCommand implements IModule
   {
      
      private static var _instance:DailyLoginRewardDayCommand;
      
      public var claimed:Boolean = false;
      
      public var month:int = 0;
      
      public var end:Boolean = false;
      
      public var nextMonthSeconds:int = 0;
      
      public var day:int = 0;
      
      public function DailyLoginRewardDayCommand(param1:int = 0, param2:int = 0, param3:Boolean = false, param4:int = 0, param5:Boolean = false)
      {
         super();
         this.claimed = param3;
         this.month = param2;
         this.end = param5;
         this.nextMonthSeconds = param4;
         this.day = param1;
      }
      
      public static function get instance() : DailyLoginRewardDayCommand
      {
         return _instance || (_instance = new DailyLoginRewardDayCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2835;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 14;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.claimed = param1.readBoolean();
         this.month = param1.readInt();
         this.month = this.month >>> 3 % 32 | this.month << 32 - 3 % 32;
         this.end = param1.readBoolean();
         this.nextMonthSeconds = param1.readInt();
         this.nextMonthSeconds = this.nextMonthSeconds << 12 % 32 | this.nextMonthSeconds >>> 32 - 12 % 32;
         this.day = param1.readInt();
         this.day = this.day << 15 % 32 | this.day >>> 32 - 15 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2835);
         param1.writeBoolean(this.claimed);
         param1.writeInt(this.month << 3 % 32 | this.month >>> 32 - 3 % 32);
         param1.writeBoolean(this.end);
         param1.writeInt(this.nextMonthSeconds >>> 12 % 32 | this.nextMonthSeconds << 32 - 12 % 32);
         param1.writeInt(this.day >>> 15 % 32 | this.day << 32 - 15 % 32);
      }
   }
}

