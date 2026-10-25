package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CommandCenterNewsClickedRequest implements IModule
   {
      
      private static var _instance:CommandCenterNewsClickedRequest;
      
      public var eventId:Number = 0;
      
      public var newsId:String = "";
      
      public function CommandCenterNewsClickedRequest(param1:String = "", param2:Number = 0)
      {
         super();
         this.eventId = param2;
         this.newsId = param1;
      }
      
      public static function get instance() : CommandCenterNewsClickedRequest
      {
         return _instance || (_instance = new CommandCenterNewsClickedRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 30716;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.eventId = param1.readDouble();
         this.newsId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(30716);
         param1.writeDouble(this.eventId);
         param1.writeUTF(this.newsId);
      }
   }
}

