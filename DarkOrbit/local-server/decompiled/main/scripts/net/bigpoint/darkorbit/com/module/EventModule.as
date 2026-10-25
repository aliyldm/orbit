package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventModule implements IModule
   {
      
      private static var _instance:EventModule;
      
      public var type:String = "";
      
      public var timeLeft:int = 0;
      
      public var id:Number = 0;
      
      public var lang:String = "";
      
      public function EventModule(param1:String = "", param2:String = "", param3:Number = 0, param4:int = 0)
      {
         super();
         this.type = param1;
         this.timeLeft = param4;
         this.id = param3;
         this.lang = param2;
      }
      
      public static function get instance() : EventModule
      {
         return _instance || (_instance = new EventModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -9499;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = param1.readUTF();
         this.timeLeft = param1.readInt();
         this.timeLeft = this.timeLeft << 11 % 32 | this.timeLeft >>> 32 - 11 % 32;
         this.id = param1.readDouble();
         this.lang = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-9499);
         param1.writeUTF(this.type);
         param1.writeInt(this.timeLeft >>> 11 % 32 | this.timeLeft << 32 - 11 % 32);
         param1.writeDouble(this.id);
         param1.writeUTF(this.lang);
      }
   }
}

