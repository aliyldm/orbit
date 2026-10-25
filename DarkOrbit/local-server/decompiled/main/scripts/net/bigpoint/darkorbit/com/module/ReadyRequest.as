package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ReadyRequest implements IModule
   {
      
      private static var _instance:ReadyRequest;
      
      public static const READYMESSAGE_MAP_LOADED_2D:int = 0;
      
      public static const READYMESSAGE_MAP_LOADED_3D:int = 1;
      
      public static const READYMESSAGE_UI_READY:int = 2;
      
      public static const READYMESSAGE__MAX:int = 3;
      
      public var readyTypeStr:String = "";
      
      public var readyType:int = 0;
      
      public function ReadyRequest(param1:String = "", param2:int = 0)
      {
         super();
         this.readyTypeStr = param1;
         this.readyType = param2;
      }
      
      public static function get instance() : ReadyRequest
      {
         return _instance || (_instance = new ReadyRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 14;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.readyTypeStr = param1.readUTF();
         this.readyType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(14);
         param1.writeUTF(this.readyTypeStr);
         param1.writeShort(this.readyType);
      }
   }
}

