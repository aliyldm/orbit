package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InvitationAcceptRequest implements IModule
   {
      
      private static var _instance:InvitationAcceptRequest;
      
      public var inviterId:int = 0;
      
      public function InvitationAcceptRequest(param1:int = 0)
      {
         super();
         this.inviterId = param1;
      }
      
      public static function get instance() : InvitationAcceptRequest
      {
         return _instance || (_instance = new InvitationAcceptRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -2962;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.inviterId = param1.readInt();
         this.inviterId = this.inviterId << 16 % 32 | this.inviterId >>> 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-2962);
         param1.writeInt(this.inviterId >>> 16 % 32 | this.inviterId << 32 - 16 % 32);
      }
   }
}

