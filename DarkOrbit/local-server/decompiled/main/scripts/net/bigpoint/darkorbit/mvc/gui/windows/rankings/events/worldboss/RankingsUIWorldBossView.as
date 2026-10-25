package net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.worldboss
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.RankingsUIEventsConsts;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.model.vo.RankingsUIEventsPageBtnVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.view.components.RankingsUIEventsPageBtnAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.root.AbstractRankingsUIViewItem;
   
   public class RankingsUIWorldBossView extends AbstractRankingsUIViewItem
   {
      
      public function RankingsUIWorldBossView(param1:Sprite)
      {
         super(param1,"worldboss");
         rankingItemList.itemDataAssigner = RankingsUIWorldBossRowAssigner;
         this.pageBtnItemList.itemDataAssigner = RankingsUIEventsPageBtnAssigner;
         var _loc2_:Vector.<RankingsUIEventsPageBtnVO> = new Vector.<RankingsUIEventsPageBtnVO>(0);
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            _loc2_.push(new RankingsUIEventsPageBtnVO(_loc3_));
            _loc3_++;
         }
         this.pageBtnList = _loc2_;
         this.pageBtnItemList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.onPageBtnSelection);
      }
      
      private function get labelSubTitle() : Label
      {
         return cache.selectComponent("worldboss.optional.subTitle") as Label;
      }
      
      private function get pageBtnItemList() : ItemList
      {
         return cache.selectComponent("worldboss.optional.pageBtnList") as ItemList;
      }
      
      public function set pageBtnList(param1:Object) : void
      {
         if(this.pageBtnItemList == null)
         {
            return;
         }
         this.pageBtnItemList.list = new VectorCollection(param1);
         this.pageBtnItemList.selectedIndex = 0;
      }
      
      private function onPageBtnSelection(param1:ItemListEvent) : void
      {
         var _loc3_:RankingsUIEventsPageBtnVO = null;
         this.labelSubTitle.text = (this.pageBtnItemList.selectedItemData as RankingsUIEventsPageBtnVO).title;
         var _loc2_:int = 0;
         while(_loc2_ < this.pageBtnItemList.list.length)
         {
            _loc3_ = this.pageBtnItemList.list.getItemAt(_loc2_) as RankingsUIEventsPageBtnVO;
            if(_loc3_)
            {
               _loc3_.selected.value = param1 == null ? _loc2_ == 0 : _loc3_ == param1.itemVO;
            }
            _loc2_++;
         }
         this.updateRankType();
      }
      
      private function updateRankType() : void
      {
         this.disableInteraction(true);
         updateRanking(null);
         var _loc1_:int = RankingsUIEventsConsts.getRankId(RankingsUIEventsConsts.WORLD_BOSS,this.pageBtnItemList.selectedIndex);
         viewItemRankTypeChanged.dispatch(_loc1_);
      }
      
      override public function disableInteraction(param1:Boolean) : void
      {
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
         this.pageBtnItemList.enabled = !param1;
      }
      
      override public function resetView() : void
      {
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
         if(this.pageBtnItemList.selectedIndex == 0)
         {
            this.onPageBtnSelection(null);
         }
         else
         {
            this.pageBtnItemList.selectedIndex = 0;
         }
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
         var _loc8_:Label = cache.selectComponent(param1 + ".score") as Label;
         _loc8_.text = param2 == null ? "-" : param2[2];
         var _loc9_:Label = cache.selectComponent(param1 + ".time") as Label;
         _loc9_.text = param2 == null ? "-" : param2[3];
      }
   }
}

