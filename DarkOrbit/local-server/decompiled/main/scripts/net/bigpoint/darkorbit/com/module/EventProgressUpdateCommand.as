package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventProgressUpdateCommand implements IModule
   {
      
      private static var _instance:EventProgressUpdateCommand;
      
      public var id:String = "";
      
      public var progress:int = 0;
      
      public var statusCode:int = 0;
      
      public function EventProgressUpdateCommand(param1:String = "", param2:int = 0, param3:int = 0)
      {
         super();
         this.id = param1;
         this.progress = param2;
         this.statusCode = param3;
      }
      
      public static function get instance() : EventProgressUpdateCommand
      {
         return _instance || (_instance = new EventProgressUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 32320;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.id = param1.readUTF();
         this.progress = param1.readInt();
         this.progress = this.progress << 10 % 32 | this.progress >>> 32 - 10 % 32;
         this.statusCode = param1.readInt();
         this.statusCode = this.statusCode << 1 % 32 | this.statusCode >>> 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(32320);
         param1.writeUTF(this.id);
         param1.writeInt(this.progress >>> 10 % 32 | this.progress << 32 - 10 % 32);
         param1.writeInt(this.statusCode >>> 1 % 32 | this.statusCode << 32 - 1 % 32);
      }
   }
}

