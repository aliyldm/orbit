package away3d.loaders.misc
{
   import away3d.arcane;
   import away3d.loaders.AssetLoader;
   import flash.events.EventDispatcher;
   
   use namespace arcane;
   
   public class AssetLoaderToken extends EventDispatcher
   {
      
      arcane var _loader:AssetLoader;
      
      public function AssetLoaderToken(param1:AssetLoader)
      {
         super();
         this._loader = param1;
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._loader.addEventListener(param1,param2,param3,param4,param5);
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._loader.removeEventListener(param1,param2,param3);
      }
      
      override public function hasEventListener(param1:String) : Boolean
      {
         return this._loader.hasEventListener(param1);
      }
      
      override public function willTrigger(param1:String) : Boolean
      {
         return this._loader.willTrigger(param1);
      }
   }
}

