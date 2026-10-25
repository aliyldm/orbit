package net.bigpoint.darkorbit.com.module.debug
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EchoRequest implements IModule
   {
      
      private static var _instance:EchoRequest;
      
      public var message:String = "";
      
      public function EchoRequest(param1:String = "")
      {
         super();
         this.message = param1;
      }
      
      public static function get instance() : EchoRequest
      {
         return _instance || (_instance = new EchoRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3360;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.message = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3360);
         param1.writeUTF(this.message);
      }
   }
}

