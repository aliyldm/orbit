package net.bigpoint.darkorbit.lazyload
{
   import flash.events.EventDispatcher;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   
   public class AssetLazyLoader extends EventDispatcher
   {
      
      public static const ASSET_LOADED:String = "ASSET_LOADED";
      
      public var resKeyForThisLoader:String;
      
      public function AssetLazyLoader()
      {
         super();
      }
      
      public function loadAsset(param1:String) : void
      {
         this.resKeyForThisLoader = param1;
         ResourceManager.lazyGetAsset(param1,this.handleAssetLoaded,this.handleAssetLoadingError);
      }
      
      private function handleAssetLoaded(param1:SWFFinisher = null) : void
      {
         dispatchEvent(new LazyLoadEvent(ASSET_LOADED,this.resKeyForThisLoader));
      }
      
      private function handleAssetLoadingError() : void
      {
      }
   }
}

