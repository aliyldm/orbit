package net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.titlefrenzy
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.RankingsUIEventsConsts;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.root.AbstractRankingsUIViewItem;
   
   public class RankingsUITitleFrenzyView extends AbstractRankingsUIViewItem
   {
      
      public function RankingsUITitleFrenzyView(param1:Sprite)
      {
         super(param1,"titlefrenzy");
         rankingItemList.itemDataAssigner = RankingsUITitleFrenzyRowAssigner;
      }
      
      override public function disableInteraction(param1:Boolean) : void
      {
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
      }
      
      override public function resetView() : void
      {
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
         var _loc1_:int = RankingsUIEventsConsts.getRankId(RankingsUIEventsConsts.TITLE_FRENZY,0);
         viewItemRankTypeChanged.dispatch(_loc1_);
      }
      
      override protected function setRank(param1:String, param2:Vector.<String>, param3:Boolean = false, param4:String = "") : void
      {
         var _loc5_:Coreponent = cache.selectComponent(param1 + ".bg") as Coreponent;
         if(param4 != "" && _loc5_ != null)
         {
            _loc5_.registeredSkinName = param4;
         }
         var _loc6_:Label = cache.selectComponent(param1 + ".rank") as Label;
         _loc6_.text = param2 == null ? "-" : param2[0];
         var _loc7_:Label = cache.selectComponent(param1 + ".name") as Label;
         _loc7_.text = param3 ? Hero.username : (param2 == null ? "-" : param2[1]);
         var _loc8_:Label = cache.selectComponent(param1 + ".time") as Label;
         _loc8_.text = param2 == null ? "-" : param2[2];
      }
   }
}

