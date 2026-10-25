package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.itemRenderer
{
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.core.layout.Alignment;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.GridItemListLayout;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.model.vo.RankRewardsVo;
   
   public class Tab3ListItemRenderer extends DefaultItemDataAssigner
   {
      
      private var _item_bg:Coreponent;
      
      private var _rank_label:Label;
      
      private var _item_reward_list:ItemList;
      
      private const ITEM_HEIGHT:Number = 50;
      
      private var _tempHeight:Number;
      
      public function Tab3ListItemRenderer()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._item_bg = FuiComponentSelectorUtil.selectComponent("item_bg",this) as Coreponent;
         this._item_bg.alpha = 0.6;
         this._rank_label = FuiComponentSelectorUtil.selectComponent("rank_label",this) as Label;
         this._item_reward_list = FuiComponentSelectorUtil.selectComponent("item_reward_list",this) as ItemList;
         this._item_reward_list.itemDataAssigner = Tab3ListItemListItenRenderer;
         (this._item_reward_list.layout as GridItemListLayout).alignmentX = Alignment.LEFT;
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         if(!param1)
         {
            return;
         }
         var _loc2_:RankRewardsVo = param1 as RankRewardsVo;
         var _loc3_:Number = Math.ceil(_loc2_.rewardListData.length / 3);
         this.setBgSize(_loc3_);
         this._rank_label.text = _loc2_.rankText;
         this._item_reward_list.height = _loc3_ * (this.ITEM_HEIGHT + this._item_reward_list.itemGap);
         this._item_reward_list.list = new VectorCollection(_loc2_.rewardListData);
      }
      
      private function setBgSize(param1:Number = 0) : void
      {
         var _loc2_:Number = param1 * this.ITEM_HEIGHT + 20;
         this.height = _loc2_;
         this._item_bg.height = _loc2_;
         this._rank_label.y = this._item_bg.height - this._rank_label.height >> 1;
         this._tempHeight = this._item_bg.height;
         this.forceRedraw(InvalidationType.SIZE);
      }
      
      public function get __height() : Number
      {
         return this._tempHeight;
      }
   }
}

