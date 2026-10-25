package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class JumpRequest implements IModule
   {
      
      private static var _instance:JumpRequest;
      
      public function JumpRequest()
      {
         super();
      }
      
      public static function get instance() : JumpRequest
      {
         return _instance || (_instance = new JumpRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 10;
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
         param1.writeShort(10);
      }
   }
}

