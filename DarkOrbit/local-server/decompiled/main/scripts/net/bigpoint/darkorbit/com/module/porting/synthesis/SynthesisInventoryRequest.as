package net.bigpoint.darkorbit.com.module.porting.synthesis
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SynthesisInventoryRequest implements IModule
   {
      
      private static var _instance:SynthesisInventoryRequest;
      
      public function SynthesisInventoryRequest()
      {
         super();
      }
      
      public static function get instance() : SynthesisInventoryRequest
      {
         return _instance || (_instance = new SynthesisInventoryRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 23219;
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
         param1.writeShort(23219);
      }
   }
}

