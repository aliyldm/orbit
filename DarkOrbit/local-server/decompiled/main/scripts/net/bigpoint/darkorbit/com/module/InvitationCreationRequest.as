package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InvitationCreationRequest implements IModule
   {
      
      private static var _instance:InvitationCreationRequest;
      
      public var name:String = "";
      
      public function InvitationCreationRequest(param1:String = "")
      {
         super();
         this.name = param1;
      }
      
      public static function get instance() : InvitationCreationRequest
      {
         return _instance || (_instance = new InvitationCreationRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 9075;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.name = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(9075);
         param1.writeUTF(this.name);
      }
   }
}

