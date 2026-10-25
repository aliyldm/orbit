package away3d.library.naming
{
   import away3d.library.assets.IAsset;
   
   public class ErrorConflictStrategy extends ConflictStrategyBase
   {
      
      public function ErrorConflictStrategy()
      {
         super();
      }
      
      override public function resolveConflict(param1:IAsset, param2:IAsset, param3:Object, param4:String) : void
      {
         throw new Error("Asset name collision while AssetLibrary.namingStrategy set to AssetLibrary.THROW_ERROR. Asset path: " + param1.assetFullPath);
      }
      
      override public function create() : ConflictStrategyBase
      {
         return new ErrorConflictStrategy();
      }
   }
}

