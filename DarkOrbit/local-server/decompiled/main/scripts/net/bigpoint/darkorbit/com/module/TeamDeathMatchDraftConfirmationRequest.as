package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TeamDeathMatchDraftConfirmationRequest implements IModule
   {
      
      private static var _instance:TeamDeathMatchDraftConfirmationRequest;
      
      public var accepted:Boolean = false;
      
      public function TeamDeathMatchDraftConfirmationRequest(param1:Boolean = false)
      {
         super();
         this.accepted = param1;
      }
      
      public static function get instance() : TeamDeathMatchDraftConfirmationRequest
      {
         return _instance || (_instance = new TeamDeathMatchDraftConfirmationRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7199;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.accepted = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7199);
         param1.writeBoolean(this.accepted);
      }
   }
}

