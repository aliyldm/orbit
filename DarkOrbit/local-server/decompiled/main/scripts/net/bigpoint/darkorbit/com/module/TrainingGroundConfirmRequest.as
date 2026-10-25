package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrainingGroundConfirmRequest implements IModule
   {
      
      private static var _instance:TrainingGroundConfirmRequest;
      
      public function TrainingGroundConfirmRequest()
      {
         super();
      }
      
      public static function get instance() : TrainingGroundConfirmRequest
      {
         return _instance || (_instance = new TrainingGroundConfirmRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -32337;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-32337);
      }
   }
}

