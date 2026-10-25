package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InvitationRemovalCommand implements IModule
   {
      
      private static var _instance:InvitationRemovalCommand;
      
      public static const REASON_NONE:int = 0;
      
      public static const REASON_TIMEOUT:int = 1;
      
      public static const REASON_REVOKE:int = 2;
      
      public static const REASON_REJECT:int = 3;
      
      public static const REASON_ACKNOWLEDGE:int = 4;
      
      public static const REASON__MAX:int = 5;
      
      public var candidateId:int = 0;
      
      public var inviterId:int = 0;
      
      public var reason:int = 0;
      
      public function InvitationRemovalCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.candidateId = param2;
         this.inviterId = param1;
         this.reason = param3;
      }
      
      public static function get instance() : InvitationRemovalCommand
      {
         return _instance || (_instance = new InvitationRemovalCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -27715;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.candidateId = param1.readInt();
         this.candidateId = this.candidateId << 13 % 32 | this.candidateId >>> 32 - 13 % 32;
         this.inviterId = param1.readInt();
         this.inviterId = this.inviterId >>> 12 % 32 | this.inviterId << 32 - 12 % 32;
         this.reason = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-27715);
         param1.writeInt(this.candidateId >>> 13 % 32 | this.candidateId << 32 - 13 % 32);
         param1.writeInt(this.inviterId << 12 % 32 | this.inviterId >>> 32 - 12 % 32);
         param1.writeShort(this.reason);
      }
   }
}

