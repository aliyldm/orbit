package net.bigpoint.darkorbit.mvc.gui.windows.payloadEscort.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class PayloadEscortOverviewView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function PayloadEscortOverviewView(param1:DisplayObjectContainer)
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
         return this._cache.selectComponent("root.overview.top.payload_escort_status_msg.payload_escort_status_message") as Label;
      }
      
      public function get timer() : Label
      {
         return this._cache.selectComponent("root.overview.top.payload_escort_status_msg.payload_escort_timer") as Label;
      }
      
      public function get runScore() : Label
      {
         return this._cache.selectComponent("root.overview.top.payload_escort_status_msg.payload_escort_run_score") as Label;
      }
      
      public function get scoreToolTip() : Button
      {
         return this._cache.selectComponent("root.overview.top.payload_escort_status_msg.score_info") as Button;
      }
      
      public function get escortScore() : Label
      {
         return this._cache.selectComponent("root.overview.top.payload_escort_score.payload_escort_score_amount") as Label;
      }
      
      public function get keyAmount() : Label
      {
         return this._cache.selectComponent("root.overview.top.payload_escort_key_info.payload_escort_key_amount") as Label;
      }
      
      public function get keyDisplay() : Coreponent
      {
         return this._cache.selectComponent("root.overview.top.payload_escort_key_info.escort_key_img") as Coreponent;
      }
   }
}

