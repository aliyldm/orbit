package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CommandCenterNewsModule implements IModule
   {
      
      private static var _instance:CommandCenterNewsModule;
      
      public var eventId:Number = 0;
      
      public var newsId:String = "";
      
      public var clickCount:int = 0;
      
      public function CommandCenterNewsModule(param1:String = "", param2:Number = 0, param3:int = 0)
      {
         super();
         this.eventId = param2;
         this.newsId = param1;
         this.clickCount = param3;
      }
      
      public static function get instance() : CommandCenterNewsModule
      {
         return _instance || (_instance = new CommandCenterNewsModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3523;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 14;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.eventId = param1.readDouble();
         this.newsId = param1.readUTF();
         this.clickCount = param1.readInt();
         this.clickCount = this.clickCount >>> 9 % 32 | this.clickCount << 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3523);
         param1.writeDouble(this.eventId);
         param1.writeUTF(this.newsId);
         param1.writeInt(this.clickCount << 9 % 32 | this.clickCount >>> 32 - 9 % 32);
      }
   }
}

