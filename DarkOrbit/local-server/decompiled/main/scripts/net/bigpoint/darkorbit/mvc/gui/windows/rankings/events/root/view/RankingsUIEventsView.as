package net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBox;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.RankingsUIEventsConsts;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.titlefrenzy.RankingsUITitleFrenzyView;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.worldboss.RankingsUIWorldBossView;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.root.AbstractRankingsUIViewItem;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class RankingsUIEventsView implements ITabItem
   {
      
      public const rankTypeChanged:ISignal = new Signal(int);
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      private var _rankingViews:Array;
      
      private var _currView:AbstractRankingsUIViewItem;
      
      public function RankingsUIEventsView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("events") as Coreponent;
         this.filterBox.updateAvailableEntries(RankingsUIEventsConsts.EVENT_FILTERS);
      }
      
      public function get title() : String
      {
         return "rankings_tab_events";
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
      
      public function get filterBox() : DropDownBox
      {
         return this._cache.selectComponent("events.body.share.filterBox") as DropDownBox;
      }
      
      public function get labelTitle() : Label
      {
         return this._cache.selectComponent("events.body.share.title") as Label;
      }
      
      public function get eventsRoot() : Coreponent
      {
         return this._cache.selectComponent("events.body.rankings") as Coreponent;
      }
      
      public function disableInteraction(param1:Boolean) : *
      {
         this.filterBox.enabled = !param1;
         this._currView.disableInteraction(param1);
      }
      
      public function init() : void
      {
         var _loc1_:AbstractRankingsUIViewItem = null;
         this._rankingViews = new Array();
         this._rankingViews[RankingsUIEventsConsts.WORLD_BOSS] = new RankingsUIWorldBossView(this.eventsRoot);
         this._rankingViews[RankingsUIEventsConsts.TITLE_FRENZY] = new RankingsUITitleFrenzyView(this.eventsRoot);
         for each(_loc1_ in this._rankingViews)
         {
            _loc1_.visible = false;
            _loc1_.disableInteraction(true);
            this.eventsRoot.addChild(_loc1_.body);
         }
         this._currView = this._rankingViews[RankingsUIEventsConsts.WORLD_BOSS];
      }
      
      public function get currView() : AbstractRankingsUIViewItem
      {
         return this._currView;
      }
      
      public function setEventView(param1:String) : void
      {
         this.disableInteraction(true);
         this._currView.visible = false;
         this._currView.viewItemRankTypeChanged.remove(this.onViewItemRankTypeChanged);
         this._currView = this._rankingViews[param1];
         this._currView.visible = true;
         this._currView.viewItemRankTypeChanged.add(this.onViewItemRankTypeChanged);
         this._currView.resetView();
      }
      
      private function onViewItemRankTypeChanged(param1:int) : void
      {
         this.rankTypeChanged.dispatch(param1);
      }
   }
}

