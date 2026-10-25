package net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.view.components
{
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.tooltip.DefaultTooltipDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ToolTipListAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.model.vo.TieredArenaParticipationRewardsToolTipVO;
   
   public class TieredArenaParticipationRewardsToolTipAssigner extends DefaultTooltipDataAssigner
   {
      
      private var _list:ItemList;
      
      private var _tieredArenaTooltipTitle:Label;
      
      public function TieredArenaParticipationRewardsToolTipAssigner()
      {
         super();
      }
      
      override public function assign() : void
      {
         this._list = FuiComponentSelectorUtil.selectComponent("wrapper.list",target) as ItemList;
         this._list.itemDataAssigner = ToolTipListAssigner;
         this._list.list = new VectorCollection(this.tooltipVO.rewards);
         this._tieredArenaTooltipTitle = FuiComponentSelectorUtil.selectComponent("wrapper.tiered_arena_overview_ttip_title",target) as Label;
         super.assign();
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:VectorCollection = null;
         super.data = param1;
         if(this._list)
         {
            _loc2_ = new VectorCollection(this.tooltipVO.rewards);
            if(_loc2_.length > 0)
            {
               this._list.list = _loc2_;
            }
         }
      }
      
      private function get tooltipVO() : TieredArenaParticipationRewardsToolTipVO
      {
         return data as TieredArenaParticipationRewardsToolTipVO;
      }
   }
}

