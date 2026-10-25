package net.bigpoint.darkorbit.com.module.porting.activityevent.anewhope
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventANewHopeContributorCommand implements IModule
   {
      
      private static var _instance:EventANewHopeContributorCommand;
      
      public var name:String = "";
      
      public var count:int = 0;
      
      public function EventANewHopeContributorCommand(param1:String = "", param2:int = 0)
      {
         super();
         this.name = param1;
         this.count = param2;
      }
      
      public static function get instance() : EventANewHopeContributorCommand
      {
         return _instance || (_instance = new EventANewHopeContributorCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31448;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.name = param1.readUTF();
         this.count = param1.readInt();
         this.count = this.count >>> 9 % 32 | this.count << 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-31448);
         param1.writeUTF(this.name);
         param1.writeInt(this.count << 9 % 32 | this.count >>> 32 - 9 % 32);
      }
   }
}

