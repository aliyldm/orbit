package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.model.vo.BoxesVo;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.itemRenderer.Tab2ListAssigner;
   
   public class ExpeditionInfoTabView2 implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public var _view:Coreponent;
      
      public function ExpeditionInfoTabView2(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("tab2") as Coreponent;
         this.rewardListItem.itemDataAssigner = Tab2ListAssigner;
      }
      
      public function get title() : String
      {
         return "window_dse_boxes";
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
      
      public function get rewardListItem() : ItemList
      {
         return this._cache.selectComponent("tab2.reward_container.list") as ItemList;
      }
      
      public function set rewardList(param1:Vector.<BoxesVo>) : void
      {
         this.rewardListItem.list = new VectorCollection(param1);
      }
      
      public function get nameLabel() : Label
      {
         return this._cache.selectComponent("tab2.reward_container.list.reward_name_label") as Label;
      }
   }
}

