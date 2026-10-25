package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InvitationCancelRequest implements IModule
   {
      
      private static var _instance:InvitationCancelRequest;
      
      public var candidateId:int = 0;
      
      public function InvitationCancelRequest(param1:int = 0)
      {
         super();
         this.candidateId = param1;
      }
      
      public static function get instance() : InvitationCancelRequest
      {
         return _instance || (_instance = new InvitationCancelRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -29222;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.candidateId = param1.readInt();
         this.candidateId = this.candidateId >>> 8 % 32 | this.candidateId << 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-29222);
         param1.writeInt(this.candidateId << 8 % 32 | this.candidateId >>> 32 - 8 % 32);
      }
   }
}

