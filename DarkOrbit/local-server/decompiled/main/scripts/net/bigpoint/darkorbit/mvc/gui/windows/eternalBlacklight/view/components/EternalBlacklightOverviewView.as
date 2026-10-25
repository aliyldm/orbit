package net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class EternalBlacklightOverviewView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function EternalBlacklightOverviewView(param1:DisplayObjectContainer)
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
         return this._cache.selectComponent("root.overview.top.eternal_blacklight_status_msg.eternal_blacklight_status_message") as Label;
      }
      
      public function get waveCount() : Label
      {
         return this._cache.selectComponent("root.overview.top.eternal_blacklight_status_msg.eternal_blacklight_wave_count") as Label;
      }
      
      public function get furthestWaveCount() : Label
      {
         return this._cache.selectComponent("root.overview.top.eternal_blacklight_furthest.eternal_blacklight_furthest_wave_count") as Label;
      }
      
      public function get cpuAmount() : Label
      {
         return this._cache.selectComponent("root.overview.top.eternal_blacklight_key_info.eternal_blacklight_key_amount") as Label;
      }
      
      public function get cpuDisplay() : Coreponent
      {
         return this._cache.selectComponent("root.overview.top.eternal_blacklight_key_info.eternal_blacklight_key_img") as Coreponent;
      }
   }
}

