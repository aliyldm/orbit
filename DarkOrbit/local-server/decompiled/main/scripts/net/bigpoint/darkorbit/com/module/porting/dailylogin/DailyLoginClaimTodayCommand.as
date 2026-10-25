package net.bigpoint.darkorbit.com.module.porting.dailylogin
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DailyLoginClaimTodayCommand implements IModule
   {
      
      private static var _instance:DailyLoginClaimTodayCommand;
      
      public var err:String = "";
      
      public var claimed:Boolean = false;
      
      public var day:int = 0;
      
      public function DailyLoginClaimTodayCommand(param1:int = 0, param2:Boolean = false, param3:String = "")
      {
         super();
         this.err = param3;
         this.claimed = param2;
         this.day = param1;
      }
      
      public static function get instance() : DailyLoginClaimTodayCommand
      {
         return _instance || (_instance = new DailyLoginClaimTodayCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 17403;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 7;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.err = param1.readUTF();
         this.claimed = param1.readBoolean();
         this.day = param1.readInt();
         this.day = this.day << 5 % 32 | this.day >>> 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(17403);
         param1.writeUTF(this.err);
         param1.writeBoolean(this.claimed);
         param1.writeInt(this.day >>> 5 % 32 | this.day << 32 - 5 % 32);
      }
   }
}

