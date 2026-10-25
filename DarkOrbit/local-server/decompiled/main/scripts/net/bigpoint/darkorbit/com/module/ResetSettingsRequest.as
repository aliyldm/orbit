package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ResetSettingsRequest implements IModule
   {
      
      private static var _instance:ResetSettingsRequest;
      
      public function ResetSettingsRequest()
      {
         super();
      }
      
      public static function get instance() : ResetSettingsRequest
      {
         return _instance || (_instance = new ResetSettingsRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 343;
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
         param1.writeShort(343);
      }
   }
}

