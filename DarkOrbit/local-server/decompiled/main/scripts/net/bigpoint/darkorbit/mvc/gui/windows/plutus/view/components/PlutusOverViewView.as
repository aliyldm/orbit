package net.bigpoint.darkorbit.mvc.gui.windows.plutus.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class PlutusOverViewView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function PlutusOverViewView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
      }
      
      public function get time() : Label
      {
         return this._cache.selectComponent("root.overview.top.description_container.time") as Label;
      }
      
      public function get lives() : Label
      {
         return this._cache.selectComponent("root.overview.top.lives_container.lives_num") as Label;
      }
      
      public function get tabRoot() : Coreponent
      {
         return this._cache.selectComponent("root.overview") as Coreponent;
      }
      
      public function get points() : Label
      {
         return this._cache.selectComponent("root.overview.top.points_container.points") as Label;
      }
      
      public function get description() : Label
      {
         return this._cache.selectComponent("root.overview.top.description_container.description") as Label;
      }
      
      public function get descriptionContainer() : Container
      {
         return this._cache.selectComponent("root.overview.top.description_container") as Container;
      }
   }
}

