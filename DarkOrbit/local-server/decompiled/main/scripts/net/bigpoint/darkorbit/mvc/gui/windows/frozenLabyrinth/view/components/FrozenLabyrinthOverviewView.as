package net.bigpoint.darkorbit.mvc.gui.windows.frozenLabyrinth.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class FrozenLabyrinthOverviewView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function FrozenLabyrinthOverviewView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
      }
      
      public function get tabRoot() : Coreponent
      {
         return this._cache.selectComponent("root.overview") as Coreponent;
      }
      
      public function get topDescription() : Label
      {
         return this._cache.selectComponent("root.overview.top.frozen_labyrinth_status_msg.frozen_labyrinth_status_message") as Label;
      }
      
      public function get timer() : Label
      {
         return this._cache.selectComponent("root.overview.top.frozen_labyrinth_status_msg.frozen_labyrinth_timer") as Label;
      }
      
      public function get keyAmount() : Label
      {
         return this._cache.selectComponent("root.overview.top.frozen_labyrinth_key_info.frozen_labyrinth_key_amount") as Label;
      }
      
      public function get keyDisplay() : Coreponent
      {
         return this._cache.selectComponent("root.overview.top.frozen_labyrinth_key_info.labyrinth_key_img") as Coreponent;
      }
      
      public function get synkLocationTextLeft() : Label
      {
         return this._cache.selectComponent("root.overview.top.frozen_labyrinth_synk_info.frozen_labyrinth_synk_location_left") as Label;
      }
      
      public function get synkLocationTextRight() : Label
      {
         return this._cache.selectComponent("root.overview.top.frozen_labyrinth_synk_info.frozen_labyrinth_synk_location_right") as Label;
      }
   }
}

