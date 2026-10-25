package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssetInformationModule implements IModule
   {
      
      private static var _instance:AssetInformationModule;
      
      public function AssetInformationModule()
      {
         super();
      }
      
      public static function get instance() : AssetInformationModule
      {
         return _instance || (_instance = new AssetInformationModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 14266;
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
         param1.writeShort(14266);
      }
   }
}

