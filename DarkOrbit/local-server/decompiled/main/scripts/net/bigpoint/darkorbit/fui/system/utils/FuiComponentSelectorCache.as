package net.bigpoint.darkorbit.fui.system.utils
{
   import flash.display.DisplayObjectContainer;
   
   public class FuiComponentSelectorCache
   {
      
      private var _view:DisplayObjectContainer;
      
      private var _cache:Object = new Object();
      
      public function FuiComponentSelectorCache(param1:DisplayObjectContainer)
      {
         super();
         this._view = param1;
      }
      
      public function selectComponent(param1:String) : DisplayObjectContainer
      {
         return this._cache[param1] || (this._cache[param1] = FuiComponentSelectorUtil.selectComponent(param1,this._view));
      }
      
      public function get view() : DisplayObjectContainer
      {
         return this._view;
      }
   }
}

