package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.view.component.SeasonPassLevelItemAssigner;
   
   public class SeasonPassUIRewardsView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      private var _btnClaimAll:Button;
      
      private var _btnBuyGoldPass:Button;
      
      private var _btnBuyExtGoldPass:Button;
      
      public function SeasonPassUIRewardsView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("rewards") as Coreponent;
         this._btnClaimAll = this._cache.selectComponent("rewards.content.claim_all") as Button;
         this._btnBuyGoldPass = this._cache.selectComponent("rewards.content.list.header.buy_gold_pass") as Button;
         this._btnBuyExtGoldPass = this._cache.selectComponent("rewards.content.list.header.buy_ext_gold_pass") as Button;
         this.itemList.itemDataAssigner = SeasonPassLevelItemAssigner;
      }
      
      public function get title() : String
      {
         return "window_mission_sp_tab_rewards";
      }
      
      public function get view() : Coreponent
      {
         return this._view;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._view.visible = param1;
      }
      
      public function get visible() : Boolean
      {
         return this._view.visible;
      }
      
      public function set active(param1:Boolean) : void
      {
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      public function set list(param1:Object) : void
      {
         this.itemList.list = new VectorCollection(param1);
      }
      
      public function get claimAllButton() : Button
      {
         return this._btnClaimAll;
      }
      
      public function get buyGoldPassButton() : Button
      {
         return this._btnBuyGoldPass;
      }
      
      public function get buyExtGoldPassButton() : Button
      {
         return this._btnBuyExtGoldPass;
      }
      
      public function get itemList() : ItemList
      {
         return this._cache.selectComponent("rewards.content.list.body") as ItemList;
      }
      
      public function get itemHighlight() : Coreponent
      {
         return this._cache.selectComponent("rewards.content.list.item_highlight") as Coreponent;
      }
      
      public function get pageLabel() : Label
      {
         return this._cache.selectComponent("rewards.content.page.page_label") as Label;
      }
      
      public function get firstPageButton() : Button
      {
         return this._cache.selectComponent("rewards.content.page.first_page") as Button;
      }
      
      public function get lastPageButton() : Button
      {
         return this._cache.selectComponent("rewards.content.page.last_page") as Button;
      }
      
      public function get prevPageButton() : Button
      {
         return this._cache.selectComponent("rewards.content.page.prev_page") as Button;
      }
      
      public function get nextPageButton() : Button
      {
         return this._cache.selectComponent("rewards.content.page.next_page") as Button;
      }
      
      public function get level50Button() : Button
      {
         return this._cache.selectComponent("rewards.content.page.level_50_page") as Button;
      }
   }
}

