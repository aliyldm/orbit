package net.bigpoint.darkorbit.com.module.porting.pilotsheet
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InternalPilotBioUpdateStatusRequest implements IModule
   {
      
      private static var _instance:InternalPilotBioUpdateStatusRequest;
      
      public var statusMessage:String = "";
      
      public function InternalPilotBioUpdateStatusRequest(param1:String = "")
      {
         super();
         this.statusMessage = param1;
      }
      
      public static function get instance() : InternalPilotBioUpdateStatusRequest
      {
         return _instance || (_instance = new InternalPilotBioUpdateStatusRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -17772;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.statusMessage = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-17772);
         param1.writeUTF(this.statusMessage);
      }
   }
}

