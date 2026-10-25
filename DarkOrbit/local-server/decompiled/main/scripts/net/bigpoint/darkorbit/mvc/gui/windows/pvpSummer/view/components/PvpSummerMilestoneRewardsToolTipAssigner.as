package net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.view.components
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.tooltip.DefaultTooltipDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ToolTipListAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.model.vo.PvPSummerMilestoneRewardsToolTipVO;
   
   public class PvpSummerMilestoneRewardsToolTipAssigner extends DefaultTooltipDataAssigner
   {
      
      private var _list:ItemList;
      
      private var _pvpSummerTooltipTitle:Label;
      
      public function PvpSummerMilestoneRewardsToolTipAssigner()
      {
         super();
      }
      
      override public function assign() : void
      {
         this._list = FuiComponentSelectorUtil.selectComponent("wrapper.list",target) as ItemList;
         this._list.itemDataAssigner = ToolTipListAssigner;
         this._list.list = new VectorCollection(this.tooltipVO.rewards);
         this._pvpSummerTooltipTitle = FuiComponentSelectorUtil.selectComponent("wrapper.pvpsummer_overview_ttip_title",target) as Label;
         this._pvpSummerTooltipTitle.text = BPLocale.getItem("galacticStrife_tab_overview_milestoneRewards_title").replace(/%REPUTATION%/,this.tooltipVO.titleReputation.toString());
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
         if(this._pvpSummerTooltipTitle)
         {
            this._pvpSummerTooltipTitle.text = BPLocale.getItem("galacticStrife_tab_overview_milestoneRewards_title").replace(/%REPUTATION%/,this.tooltipVO.titleReputation.toString());
         }
      }
      
      private function get tooltipVO() : PvPSummerMilestoneRewardsToolTipVO
      {
         return data as PvPSummerMilestoneRewardsToolTipVO;
      }
   }
}

