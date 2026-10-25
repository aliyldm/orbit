package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.model.vo.OverViewVo;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.itemRenderer.Tab1ItemAssigner;
   
   public class ExpeditionInfoTabView1 implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public var _view:Coreponent;
      
      public function ExpeditionInfoTabView1(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("tab1") as Coreponent;
         this.rewardItemList.itemDataAssigner = Tab1ItemAssigner;
      }
      
      public function get title() : String
      {
         return "label_overview";
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
      
      public function get currentLevelLabel() : Label
      {
         return this._cache.selectComponent("tab1.currentLevelLabel") as Label;
      }
      
      public function get highestLevelLabel() : Label
      {
         return this._cache.selectComponent("tab1.highestLevelLabel") as Label;
      }
      
      public function get timeLimitLabel() : Label
      {
         return this._cache.selectComponent("tab1.timeLimitLabel") as Label;
      }
      
      public function get conditionLabel1() : Label
      {
         return this._cache.selectComponent("tab1.conditionLabel1") as Label;
      }
      
      public function get conditionLabel2() : Label
      {
         return this._cache.selectComponent("tab1.conditionLabel2") as Label;
      }
      
      public function get costIcon() : Coreponent
      {
         return this._cache.selectComponent("tab1.cost_container.cost_item_icon") as Coreponent;
      }
      
      public function get costNameLabel() : Label
      {
         return this._cache.selectComponent("tab1.cost_container.cost_name_label") as Label;
      }
      
      public function get costNumLabel() : Label
      {
         return this._cache.selectComponent("tab1.cost_container.cost_num_label") as Label;
      }
      
      public function get costTip() : Coreponent
      {
         return this._cache.selectComponent("tab1.cost_container.cost_tips") as Coreponent;
      }
      
      public function get infoTip() : Coreponent
      {
         return this._cache.selectComponent("tab1.cost_tips") as Coreponent;
      }
      
      public function get infoLabel() : Label
      {
         return this._cache.selectComponent("tab1.info_label") as Label;
      }
      
      public function get rewardItemList() : ItemList
      {
         return this._cache.selectComponent("tab1.reward_container.list") as ItemList;
      }
      
      public function set rewardList(param1:Vector.<OverViewVo>) : void
      {
         this.rewardItemList.list = new VectorCollection(param1);
      }
   }
}

