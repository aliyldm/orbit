package net.bigpoint.darkorbit.com.module.porting.pilotsheet
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InternalPilotBioUpdateUserNameRequest implements IModule
   {
      
      private static var _instance:InternalPilotBioUpdateUserNameRequest;
      
      public var userName:String = "";
      
      public function InternalPilotBioUpdateUserNameRequest(param1:String = "")
      {
         super();
         this.userName = param1;
      }
      
      public static function get instance() : InternalPilotBioUpdateUserNameRequest
      {
         return _instance || (_instance = new InternalPilotBioUpdateUserNameRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -10518;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.userName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-10518);
         param1.writeUTF(this.userName);
      }
   }
}

