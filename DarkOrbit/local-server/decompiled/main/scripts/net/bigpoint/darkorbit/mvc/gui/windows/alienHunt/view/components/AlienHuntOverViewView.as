package net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class AlienHuntOverViewView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function AlienHuntOverViewView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
      }
      
      public function get time() : Label
      {
         return this._cache.selectComponent("root.overview.top.right.time") as Label;
      }
      
      public function get tabRoot() : Coreponent
      {
         return this._cache.selectComponent("root.overview") as Coreponent;
      }
      
      public function get hallOfFameButton() : Button
      {
         return this._cache.selectComponent("root.overview.bottom.HOF_btn") as Button;
      }
      
      public function get points() : Label
      {
         return this._cache.selectComponent("root.overview.top.right.points") as Label;
      }
      
      public function get clanPoints() : Label
      {
         return this._cache.selectComponent("root.overview.top.right.clanpoints") as Label;
      }
      
      public function get hintButton() : Button
      {
         return this._cache.selectComponent("root.points.header.points_info_btn") as Button;
      }
   }
}

