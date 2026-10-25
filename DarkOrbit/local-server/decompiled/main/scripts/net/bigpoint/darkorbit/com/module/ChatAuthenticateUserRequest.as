package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ChatAuthenticateUserRequest implements IModule
   {
      
      private static var _instance:ChatAuthenticateUserRequest;
      
      public var endpointId:String = "";
      
      public var language:String = "";
      
      public function ChatAuthenticateUserRequest(param1:String = "", param2:String = "")
      {
         super();
         this.endpointId = param1;
         this.language = param2;
      }
      
      public static function get instance() : ChatAuthenticateUserRequest
      {
         return _instance || (_instance = new ChatAuthenticateUserRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 18709;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.endpointId = param1.readUTF();
         this.language = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(18709);
         param1.writeUTF(this.endpointId);
         param1.writeUTF(this.language);
      }
   }
}

