package net.bigpoint.darkorbit.mvc.gui.windows.monthlyDeluxe.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class MonthlyDeluxeView
   {
      
      private var _uiContainer:Sprite;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      public function MonthlyDeluxeView(param1:Sprite)
      {
         super();
         this._uiContainer = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this.rewardList.itemDataAssigner = MonthlyDeluxeItemAssigner;
      }
      
      public function get rewardList() : ItemList
      {
         return this._fuiCache.selectComponent("root.rewards.body.reward_list") as ItemList;
      }
      
      public function get overlayBg() : Coreponent
      {
         return this._fuiCache.selectComponent("root.rewards.body.overlay.overlay_bg") as Coreponent;
      }
      
      public function get overlayText() : Label
      {
         return this._fuiCache.selectComponent("root.rewards.body.overlay.overlay_text") as Label;
      }
      
      public function get claimBtn() : Button
      {
         return this._fuiCache.selectComponent("root.rewards.bottom.claim_btn") as Button;
      }
      
      public function get buyBtn() : Button
      {
         return this._fuiCache.selectComponent("root.rewards.bottom.buy_btn") as Button;
      }
      
      public function get timer() : Label
      {
         return this._fuiCache.selectComponent("root.rewards.bottom.countdown_timer") as Label;
      }
      
      public function get timerText() : Label
      {
         return this._fuiCache.selectComponent("root.rewards.bottom.countdown_text") as Label;
      }
   }
}

