package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LabUpdateRequest implements IModule
   {
      
      private static var _instance:LabUpdateRequest;
      
      public function LabUpdateRequest()
      {
         super();
      }
      
      public static function get instance() : LabUpdateRequest
      {
         return _instance || (_instance = new LabUpdateRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 137;
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
         param1.writeShort(137);
      }
   }
}

