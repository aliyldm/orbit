package net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.EternalGateChooseOptionRequest;
   import net.bigpoint.darkorbit.com.module.HighlightTypeModule;
   import net.bigpoint.darkorbit.com.module.RankRewardRequest;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.global.notifications.GameNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.highlights.HighLightItemNotification;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.ItemLoader;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.model.EternalGateUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.view.components.EternalGateRootView;
   import net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.view.components.event.EternalGateEvent;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class EternalGateUIWindowMediator extends SimpleWindowMediator
   {
      
      public static const RED_DOT_HIGHLIGHTER:HighlightItemVO = new HighlightItemVO(GuiConstants.ETERNAL_GATE,FeaturesMenuConstants.MENU_ID,HighlightTypeModule.HIGHLIGHTTYPE_RED_DOT);
      
      private var _data:EternalGateUIData;
      
      private var _view:EternalGateRootView;
      
      public function EternalGateUIWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         param2.setSize(450,267);
         mapNotificationToMethod(GameNotifications.HERO_INIT,this.refreshProgressBarHighlighter);
      }
      
      override public function onRemove() : void
      {
         this._view.rewards.list.removeEventListener(EternalGateEvent.REQUEST_PLAYER_DATA,this.loadRewards);
         super.onRemove();
         this.data = null;
      }
      
      public function set data(param1:EternalGateUIData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.keyCount.changed.remove(this.updateKeys);
            this._data.boosterPoints.changed.remove(this.updateBoosterTab);
            this._data.boosterPoints.changed.remove(this.updateRedDotHighlighter);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.keyCount.changed.add(this.updateKeys);
            this._data.boosterPoints.changed.add(this.updateBoosterTab);
            this._data.boosterPoints.changed.add(this.updateRedDotHighlighter);
            this.update();
            this.updateKeys();
            this.updateBoosterTab();
            this.updateRedDotHighlighter();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new EternalGateRootView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as EternalGateUIData;
         this.loadKeyImage();
         this._view.rewards.list.addEventListener(EternalGateEvent.REQUEST_PLAYER_DATA,this.loadRewards);
      }
      
      private function loadKeyImage() : void
      {
         var _loc4_:ItemLoader = null;
         var _loc1_:String = "";
         var _loc2_:String = "resource_key_access-eternal";
         var _loc3_:Coreponent = this._view.overView.keyDisplay;
         _loc4_ = new ItemLoader(_loc2_);
         var _loc5_:ItemVO = ItemDataProviderHelper.getItem(_loc2_);
         if(_loc5_.fullname)
         {
            _loc1_ += _loc5_.fullname + "\n";
         }
         if(_loc5_.rawDescription)
         {
            _loc1_ += _loc5_.descriptionName + "\n";
         }
         TooltipControl.getInstance().addToolTip(_loc4_,_loc1_);
         _loc3_.addChild(_loc4_);
      }
      
      private function loadRewards(param1:EternalGateEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new RankRewardRequest(param1.vo.min,RankRewardRequest.RANKTYPE_ETERNAL_GATE));
      }
      
      public function update() : void
      {
         if(Boolean(this._data) && isUIReady())
         {
            this.updateWave();
            this._view.rewards.list.list = new VectorCollection(this._data.rewardItems);
            this._view.rank.list.list = new VectorCollection(this._data.topRankers);
            this.updateOwnRank();
         }
      }
      
      private function updateWave() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.overView.waveCount.text = TextFormatter.roundInteger(this._data.currWave);
            this._view.overView.furthestWaveCount.text = TextFormatter.roundInteger(this._data.furthestWave);
         }
      }
      
      private function updateKeys() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.overView.keyAmount.text = TextFormatter.roundInteger(this._data.keyCount.value);
         }
      }
      
      private function updateBoosterTab() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.boosters.activeBoostersList.list = new VectorCollection(this._data.activeBoosters);
            this._view.boosters.boosterPoints.text = BPLocale.getItem(this._data.BOOSTER_POINTS_TEXTKEY) + " " + this._data.boosterPoints.value;
            if(this._data.boosterPoints.value <= 0)
            {
               this._view.boosters.boosterSelectionList.visible = false;
            }
            else
            {
               this._view.boosters.boosterSelectionList.visible = true;
               this._view.boosters.boosterSelectionList.list = new VectorCollection(this._data.boosterOptions);
               this._view.boosters.boosterSelectionList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.selectBooster);
            }
         }
      }
      
      private function selectBooster(param1:ItemListEvent) : void
      {
         this._view.boosters.boosterSelectionList.removeEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.selectBooster);
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new EternalGateChooseOptionRequest(param1.item.index + 1));
      }
      
      private function updateRedDotHighlighter() : void
      {
         if(this._data)
         {
            if(this._data.boosterPoints.value > 0)
            {
               sendNotification(HighLightItemNotification.ADD_HIGHLIGHT,RED_DOT_HIGHLIGHTER);
            }
            else
            {
               sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,RED_DOT_HIGHLIGHTER);
            }
         }
      }
      
      private function refreshProgressBarHighlighter(param1:INotification) : void
      {
         if(this._data)
         {
            sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,RED_DOT_HIGHLIGHTER);
            this.updateRedDotHighlighter();
         }
      }
      
      private function updateOwnRank() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.ownRank.rank == 0)
            {
               this._view.rank.ownRank.text = "-";
               this._view.rank.ownName.text = this._data.ownRank.name;
               this._view.rank.ownTime.text = "-";
               this._view.rank.ownWaves.text = "-";
            }
            else
            {
               this._view.rank.ownRank.text = TextFormatter.roundInteger(this._data.ownRank.rank);
               this._view.rank.ownName.text = this._data.ownRank.name;
               this._view.rank.ownTime.text = this._data.ownRank.lastUpdateTime;
               this._view.rank.ownWaves.text = TextFormatter.roundInteger(this._data.ownRank.waves);
            }
         }
      }
   }
}

