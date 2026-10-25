package net.bigpoint.darkorbit.mvc.gui.windows.rankings.root
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.model.vo.RankingsUIEventsVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class AbstractRankingsUIViewItem
   {
      
      public const viewItemRankTypeChanged:ISignal = new Signal(int);
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _body:Coreponent;
      
      private var _rootName:String;
      
      public function AbstractRankingsUIViewItem(param1:Sprite, param2:String)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._body = this.cache.selectComponent(param2) as Coreponent;
         this._rootName = param2;
         this.visible = false;
      }
      
      protected function get cache() : FuiComponentSelectorCache
      {
         return this._cache;
      }
      
      public function get body() : Coreponent
      {
         return this._body;
      }
      
      public function get rankingTable() : Container
      {
         return this.cache.selectComponent(this._rootName + ".rankingTable") as Container;
      }
      
      public function get optional() : Container
      {
         return this.cache.selectComponent(this._rootName + ".optional") as Container;
      }
      
      public function get inactive() : Container
      {
         return this.cache.selectComponent(this._rootName + ".inactive") as Container;
      }
      
      public function get rankingItemList() : ItemList
      {
         return this.cache.selectComponent(this._rootName + ".rankingTable.rankingList.list") as ItemList;
      }
      
      public function set rankingList(param1:Object) : void
      {
         this.rankingItemList.list = new VectorCollection(param1);
      }
      
      private function get nextRankPath() : String
      {
         return this._rootName + ".rankingTable.ranking.next.row";
      }
      
      protected function get nextRank() : Container
      {
         return this.cache.selectComponent(this.nextRankPath) as Container;
      }
      
      private function get myRankPath() : String
      {
         return this._rootName + ".rankingTable.ranking.my.row";
      }
      
      protected function get myRank() : Container
      {
         return this.cache.selectComponent(this.myRankPath) as Container;
      }
      
      private function get prevRankPath() : String
      {
         return this._rootName + ".rankingTable.ranking.prev.row";
      }
      
      private function get prevRank() : Container
      {
         return this.cache.selectComponent(this.prevRankPath) as Container;
      }
      
      public function get active() : Boolean
      {
         return this.rankingTable.visible;
      }
      
      public function set active(param1:Boolean) : void
      {
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
         this.rankingTable.visible = param1;
         this.inactive.visible = !param1;
         if(this.optional)
         {
            this.optional.visible = param1;
         }
      }
      
      public function get visible() : Boolean
      {
         return this.body.visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
         this.body.visible = param1;
      }
      
      public function updateRanking(param1:RankingsUIEventsVO) : void
      {
         this.rankingList = param1 == null ? null : param1.rankings;
         if(this.nextRank)
         {
            this.setRank(this.nextRankPath,param1 == null ? null : param1.nextRank);
         }
         if(this.myRank)
         {
            this.setRank(this.myRankPath,param1 == null ? null : param1.myRank,true,"rankings_events_bg_mine");
         }
         if(this.prevRank)
         {
            this.setRank(this.prevRankPath,param1 == null ? null : param1.prevRank);
         }
      }
      
      public function disableInteraction(param1:Boolean) : void
      {
      }
      
      public function resetView() : void
      {
      }
      
      protected function setRank(param1:String, param2:Vector.<String>, param3:Boolean = false, param4:String = "") : void
      {
      }
   }
}

