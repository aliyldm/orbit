package net.bigpoint.darkorbit.com.module.porting.activityevent.anewhope
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventANewHopeActionRequest implements IModule
   {
      
      private static var _instance:EventANewHopeActionRequest;
      
      public static const ANEWHOPEACTIONTYPE_View:int = 0;
      
      public static const ANEWHOPEACTIONTYPE_Invited:int = 1;
      
      public static const ANEWHOPEACTIONTYPE_exchange:int = 2;
      
      public static const ANEWHOPEACTIONTYPE__MAX:int = 3;
      
      public var actionType:int = 0;
      
      public var id:int = 0;
      
      public var exchange:String = "";
      
      public function EventANewHopeActionRequest(param1:int = 0, param2:int = 0, param3:String = "")
      {
         super();
         this.actionType = param1;
         this.id = param2;
         this.exchange = param3;
      }
      
      public static function get instance() : EventANewHopeActionRequest
      {
         return _instance || (_instance = new EventANewHopeActionRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -14707;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.actionType = param1.readShort();
         this.id = param1.readInt();
         this.id = this.id << 6 % 32 | this.id >>> 32 - 6 % 32;
         this.exchange = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-14707);
         param1.writeShort(this.actionType);
         param1.writeInt(this.id >>> 6 % 32 | this.id << 32 - 6 % 32);
         param1.writeUTF(this.exchange);
      }
   }
}

