package net.bigpoint.darkorbit.com.module.porting.pilotsheet
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InternalPilotBioRequest implements IModule
   {
      
      private static var _instance:InternalPilotBioRequest;
      
      public var userId:Number = 0;
      
      public function InternalPilotBioRequest(param1:Number = 0)
      {
         super();
         this.userId = param1;
      }
      
      public static function get instance() : InternalPilotBioRequest
      {
         return _instance || (_instance = new InternalPilotBioRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 14848;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.userId = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(14848);
         param1.writeDouble(this.userId);
      }
   }
}

