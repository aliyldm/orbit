package away3d.library.naming
{
   import away3d.errors.AbstractMethodError;
   import away3d.events.AssetEvent;
   import away3d.library.assets.IAsset;
   
   public class ConflictStrategyBase
   {
      
      public function ConflictStrategyBase()
      {
         super();
      }
      
      public function resolveConflict(param1:IAsset, param2:IAsset, param3:Object, param4:String) : void
      {
         throw new AbstractMethodError();
      }
      
      public function create() : ConflictStrategyBase
      {
         throw new AbstractMethodError();
      }
      
      protected function updateNames(param1:String, param2:String, param3:IAsset, param4:IAsset, param5:Object, param6:String) : void
      {
         var _loc7_:String = null;
         var _loc8_:IAsset = null;
         var _loc9_:IAsset = null;
         _loc8_ = param6 == ConflictPrecedence.FAVOR_NEW ? param4 : param3;
         _loc9_ = param6 == ConflictPrecedence.FAVOR_NEW ? param3 : param4;
         _loc7_ = _loc9_.name;
         param5[_loc8_.name] = _loc8_;
         param5[param2] = _loc9_;
         _loc9_.resetAssetPath(param2,param1,false);
         _loc9_.dispatchEvent(new AssetEvent(AssetEvent.ASSET_CONFLICT_RESOLVED,_loc9_,_loc7_));
      }
   }
}

