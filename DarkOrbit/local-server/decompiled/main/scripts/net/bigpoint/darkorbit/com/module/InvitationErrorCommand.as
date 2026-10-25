package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InvitationErrorCommand implements IModule
   {
      
      private static var _instance:InvitationErrorCommand;
      
      public static const ERRORTYPE_GROUP_FULL:int = 0;
      
      public static const ERRORTYPE_CANDIDATE_IN_GROUP:int = 1;
      
      public static const ERRORTYPE_CANDIDATE_NONEXISTENT:int = 2;
      
      public static const ERRORTYPE_INVITER_NONEXISTENT:int = 3;
      
      public static const ERRORTYPE_NO_INVITATION:int = 4;
      
      public static const ERRORTYPE_BOSS_ONLY:int = 5;
      
      public static const ERRORTYPE_MAX_INVITATIONS_INVITER:int = 6;
      
      public static const ERRORTYPE_MAX_INVITATIONS_CANDIDATE:int = 7;
      
      public static const ERRORTYPE_CANDIDATE_BLOCKING:int = 8;
      
      public static const ERRORTYPE_DUPLICATE_INVITATION:int = 9;
      
      public static const ERRORTYPE_INVITER_IN_PAYLOAD:int = 10;
      
      public static const ERRORTYPE__MAX:int = 11;
      
      public var inviterId:int = 0;
      
      public var candidateId:int = 0;
      
      public var error:int = 0;
      
      public function InvitationErrorCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.inviterId = param1;
         this.candidateId = param2;
         this.error = param3;
      }
      
      public static function get instance() : InvitationErrorCommand
      {
         return _instance || (_instance = new InvitationErrorCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4837;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.inviterId = param1.readInt();
         this.inviterId = this.inviterId << 7 % 32 | this.inviterId >>> 32 - 7 % 32;
         this.candidateId = param1.readInt();
         this.candidateId = this.candidateId << 7 % 32 | this.candidateId >>> 32 - 7 % 32;
         this.error = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4837);
         param1.writeInt(this.inviterId >>> 7 % 32 | this.inviterId << 32 - 7 % 32);
         param1.writeInt(this.candidateId >>> 7 % 32 | this.candidateId << 32 - 7 % 32);
         param1.writeShort(this.error);
      }
   }
}

