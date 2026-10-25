package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view
{
   import net.bigpoint.darkorbit.fui.components.bars.ProgressBar;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class SingularityDriveRewardView extends SimpleWindow
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      public function SingularityDriveRewardView(param1:SimpleWindow)
      {
         super();
         this._fuiCache = new FuiComponentSelectorCache(param1.getUIContainer());
      }
      
      private function init() : *
      {
         this.progress_bar.maxValue = 100;
         this.progress_bar.minValue = 0;
         this.progress_bar.currentValue = 20;
      }
      
      public function get info_bg() : Coreponent
      {
         return this._fuiCache.selectComponent("root.reward_content.upContainer.info_label_bg") as Coreponent;
      }
      
      public function get list_bg() : Coreponent
      {
         return this._fuiCache.selectComponent("root.reward_content.bottomContainer.list_bg") as Coreponent;
      }
      
      public function get reward_list() : ItemList
      {
         return this._fuiCache.selectComponent("root.reward_content.bottomContainer.reward_list") as ItemList;
      }
      
      public function get header() : Coreponent
      {
         return this._fuiCache.selectComponent("root.reward_content.bottomContainer.header") as Coreponent;
      }
      
      public function get progress_bar() : ProgressBar
      {
         return this._fuiCache.selectComponent("root.reward_content.bottomContainer.progress.progress_bar.bar") as ProgressBar;
      }
      
      public function get progress_bar_label_current() : Label
      {
         return this._fuiCache.selectComponent("root.reward_content.bottomContainer.progress.progress_bar.label_current") as Label;
      }
      
      public function get progress_bar_label_next() : Label
      {
         return this._fuiCache.selectComponent("root.reward_content.bottomContainer.progress.index_group.label_next") as Label;
      }
      
      public function get page_label() : Label
      {
         return this._fuiCache.selectComponent("root.reward_content.bottomContainer.page.page_label") as Label;
      }
      
      public function get first_page() : Button
      {
         return this._fuiCache.selectComponent("root.reward_content.bottomContainer.page.first_page") as Button;
      }
      
      public function get prev_page() : Button
      {
         return this._fuiCache.selectComponent("root.reward_content.bottomContainer.page.prev_page") as Button;
      }
      
      public function get next_page() : Button
      {
         return this._fuiCache.selectComponent("root.reward_content.bottomContainer.page.next_page") as Button;
      }
      
      public function get last_page() : Button
      {
         return this._fuiCache.selectComponent("root.reward_content.bottomContainer.page.last_page") as Button;
      }
      
      public function get level_Max_page() : Button
      {
         return this._fuiCache.selectComponent("root.reward_content.bottomContainer.page.level_Max_page") as Button;
      }
      
      public function get buy_button() : Button
      {
         return this._fuiCache.selectComponent("root.reward_content.upContainer.buy_ext_gold_pass") as Button;
      }
      
      public function get info_label() : Label
      {
         return this._fuiCache.selectComponent("root.reward_content.upContainer.info_label") as Label;
      }
      
      public function get time_label() : Label
      {
         return this._fuiCache.selectComponent("root.reward_content.bottomContainer.time_label") as Label;
      }
   }
}

