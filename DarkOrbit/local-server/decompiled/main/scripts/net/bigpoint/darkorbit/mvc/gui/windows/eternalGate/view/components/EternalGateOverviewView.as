package net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class EternalGateOverviewView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function EternalGateOverviewView(param1:DisplayObjectContainer)
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
         return this._cache.selectComponent("root.overview.top.eternal_gate_status_msg.eternal_gate_status_message") as Label;
      }
      
      public function get waveCount() : Label
      {
         return this._cache.selectComponent("root.overview.top.eternal_gate_status_msg.eternal_gate_wave_count") as Label;
      }
      
      public function get furthestWaveCount() : Label
      {
         return this._cache.selectComponent("root.overview.top.eternal_gate_furthest.eternal_gate_furthest_wave_count") as Label;
      }
      
      public function get keyAmount() : Label
      {
         return this._cache.selectComponent("root.overview.top.eternal_gate_key_info.eternal_gate_key_amount") as Label;
      }
      
      public function get keyDisplay() : Coreponent
      {
         return this._cache.selectComponent("root.overview.top.eternal_gate_key_info.eternal_gate_key_img") as Coreponent;
      }
   }
}

