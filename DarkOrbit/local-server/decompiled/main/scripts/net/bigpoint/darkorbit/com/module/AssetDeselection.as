package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssetDeselection implements IModule
   {
      
      private static var _instance:AssetDeselection;
      
      public function AssetDeselection()
      {
         super();
      }
      
      public static function get instance() : AssetDeselection
      {
         return _instance || (_instance = new AssetDeselection());
      }
      
      public function getLibcomModuleId() : int
      {
         return 51;
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
         param1.writeShort(51);
      }
   }
}

