package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GroupInvitationRequest implements IModule
   {
      
      private static var _instance:GroupInvitationRequest;
      
      public var candidateId:int = 0;
      
      public function GroupInvitationRequest(param1:int = 0)
      {
         super();
         this.candidateId = param1;
      }
      
      public static function get instance() : GroupInvitationRequest
      {
         return _instance || (_instance = new GroupInvitationRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3333;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.candidateId = param1.readInt();
         this.candidateId = this.candidateId >>> 10 % 32 | this.candidateId << 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3333);
         param1.writeInt(this.candidateId << 10 % 32 | this.candidateId >>> 32 - 10 % 32);
      }
   }
}

