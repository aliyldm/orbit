package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SectorControlDraftConfirmationRequest implements IModule
   {
      
      private static var _instance:SectorControlDraftConfirmationRequest;
      
      public var accepted:Boolean = false;
      
      public function SectorControlDraftConfirmationRequest(param1:Boolean = false)
      {
         super();
         this.accepted = param1;
      }
      
      public static function get instance() : SectorControlDraftConfirmationRequest
      {
         return _instance || (_instance = new SectorControlDraftConfirmationRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7125;
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
         param1.writeShort(7125);
         param1.writeBoolean(this.accepted);
      }
   }
}

