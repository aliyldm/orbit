package away3d.library.utils
{
   import away3d.library.assets.IAsset;
   
   public class AssetLibraryIterator
   {
      
      private var _assets:Vector.<IAsset>;
      
      private var _filtered:Vector.<IAsset>;
      
      private var _idx:uint;
      
      public function AssetLibraryIterator(param1:Vector.<IAsset>, param2:String, param3:String, param4:Function)
      {
         super();
         this._assets = param1;
         this.filter(param2,param3,param4);
      }
      
      public function get currentAsset() : IAsset
      {
         return this._idx < this._filtered.length ? this._filtered[this._idx] : null;
      }
      
      public function get numAssets() : uint
      {
         return this._filtered.length;
      }
      
      public function next() : IAsset
      {
         var _loc1_:IAsset = null;
         if(this._idx < this._filtered.length)
         {
            _loc1_ = this._filtered[this._idx];
         }
         ++this._idx;
         return _loc1_;
      }
      
      public function reset() : void
      {
         this._idx = 0;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._idx = param1;
      }
      
      private function filter(param1:String, param2:String, param3:Function) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:IAsset = null;
         if(Boolean(param1) || Boolean(param2) || param3 != null)
         {
            _loc4_ = 0;
            this._filtered = new Vector.<IAsset>();
            for each(_loc5_ in this._assets)
            {
               if(!(Boolean(param1) && _loc5_.assetType != param1))
               {
                  if(!(Boolean(param2) && _loc5_.assetNamespace != param2))
                  {
                     if(!(param3 != null && !param3(_loc5_)))
                     {
                        var _loc8_:uint;
                        this._filtered[_loc8_ = _loc4_++] = _loc5_;
                     }
                  }
               }
            }
         }
         else
         {
            this._filtered = this._assets;
         }
      }
   }
}

