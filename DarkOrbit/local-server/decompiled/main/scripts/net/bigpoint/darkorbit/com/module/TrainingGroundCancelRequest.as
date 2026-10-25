package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrainingGroundCancelRequest implements IModule
   {
      
      private static var _instance:TrainingGroundCancelRequest;
      
      public function TrainingGroundCancelRequest()
      {
         super();
      }
      
      public static function get instance() : TrainingGroundCancelRequest
      {
         return _instance || (_instance = new TrainingGroundCancelRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3375;
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
         param1.writeShort(3375);
      }
   }
}

