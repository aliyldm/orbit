package net.bigpoint.darkorbit.com.module.porting.autopilot
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AutopilotInfoSaveRequest implements IModule
   {
      
      private static var _instance:AutopilotInfoSaveRequest;
      
      public var autopilotInfos:String = "";
      
      public function AutopilotInfoSaveRequest(param1:String = "")
      {
         super();
         this.autopilotInfos = param1;
      }
      
      public static function get instance() : AutopilotInfoSaveRequest
      {
         return _instance || (_instance = new AutopilotInfoSaveRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -19755;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.autopilotInfos = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-19755);
         param1.writeUTF(this.autopilotInfos);
      }
   }
}

