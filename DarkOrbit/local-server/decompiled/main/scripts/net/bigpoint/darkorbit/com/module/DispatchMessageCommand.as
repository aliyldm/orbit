package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchMessageCommand implements IModule
   {
      
      private static var _instance:DispatchMessageCommand;
      
      public static const MESSAGETYPE_DISPATCH_SUCCESS_SEND_RETRIEVER:int = 0;
      
      public static const MESSAGETYPE_DISPATCH_SUCCESS_SEND_GATE:int = 1;
      
      public static const MESSAGETYPE_DISPATCH_SUCCESS_ADD_SLOT:int = 2;
      
      public static const MESSAGETYPE_DISPATCH_ERROR_NO_GATE:int = 3;
      
      public static const MESSAGETYPE_DISPATCH_ERROR_NO_SLOT:int = 4;
      
      public static const MESSAGETYPE_DISPATCH_ERROR_NO_RESOURCE:int = 5;
      
      public static const MESSAGETYPE_DISPATCH_ERROR_NOT_READY:int = 6;
      
      public static const MESSAGETYPE_DISPATCH_ERROR_COLLECT:int = 7;
      
      public static const MESSAGETYPE_DISPATCH_ERROR_SEND_RETRIEVER:int = 8;
      
      public static const MESSAGETYPE_DISPATCH_ERROR_SEND_GATE:int = 9;
      
      public static const MESSAGETYPE_DISPATCH_ERROR_INCOMPLETE_GATE:int = 10;
      
      public static const MESSAGETYPE_DISPATCH_ERROR_MAX_SLOT:int = 11;
      
      public static const MESSAGETYPE__MAX:int = 12;
      
      public var messageType:int = 0;
      
      public function DispatchMessageCommand(param1:int = 0)
      {
         super();
         this.messageType = param1;
      }
      
      public static function get instance() : DispatchMessageCommand
      {
         return _instance || (_instance = new DispatchMessageCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 20921;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.messageType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(20921);
         param1.writeShort(this.messageType);
      }
   }
}

