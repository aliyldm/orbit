package net.bigpoint.darkorbit.com.module.porting.voyagers
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class VoyagersUIRequest implements IModule
   {
      
      private static var _instance:VoyagersUIRequest;
      
      public function VoyagersUIRequest()
      {
         super();
      }
      
      public static function get instance() : VoyagersUIRequest
      {
         return _instance || (_instance = new VoyagersUIRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -310;
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
         param1.writeShort(-310);
      }
   }
}

