package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapAssetActivationRequest implements IModule
   {
      
      private static var _instance:MapAssetActivationRequest;
      
      public var mapAssetId:int = 0;
      
      public function MapAssetActivationRequest(param1:int = 0)
      {
         super();
         this.mapAssetId = param1;
      }
      
      public static function get instance() : MapAssetActivationRequest
      {
         return _instance || (_instance = new MapAssetActivationRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6587;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.mapAssetId = param1.readInt();
         this.mapAssetId = this.mapAssetId >>> 5 % 32 | this.mapAssetId << 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6587);
         param1.writeInt(this.mapAssetId << 5 % 32 | this.mapAssetId >>> 32 - 5 % 32);
      }
   }
}

