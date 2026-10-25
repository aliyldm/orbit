package net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.com.module.HuntRewardRequest;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.model.AlienHuntUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.view.components.AlienHuntRootView;
   import net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.view.components.event.AlienHuntEvent;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   
   public class AlienHuntUIWindowMediator extends SimpleWindowMediator
   {
      
      private var _data:AlienHuntUIData;
      
      private var _view:AlienHuntRootView;
      
      public function AlienHuntUIWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         param2.setSize(360,267);
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this.data = null;
      }
      
      public function set data(param1:AlienHuntUIData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.timer.changed.remove(this.updateTime);
            this._data.overviewData.changed.remove(this.updatePoints);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.timer.changed.add(this.updateTime);
            this._data.overviewData.changed.add(this.updatePoints);
            this.updateEventTypeChanges();
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new AlienHuntRootView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as AlienHuntUIData;
         this.addListeners();
      }
      
      private function addListeners() : void
      {
         this._view.rewards.list.addEventListener(AlienHuntEvent.REQUEST_PLAYER_DATA,this.loadPlayerRewards);
         this._view.rewards.list.addEventListener(AlienHuntEvent.REQUEST_CLAN_DATA,this.loadClanRewards);
         this._view.overView.hallOfFameButton.addEventListener(MouseEvent.CLICK,this.handleOpenHallOfFameButtonClickEvent);
      }
      
      private function removeListeners() : void
      {
         this._view.rewards.list.removeEventListener(AlienHuntEvent.REQUEST_PLAYER_DATA,this.loadPlayerRewards);
         this._view.rewards.list.removeEventListener(AlienHuntEvent.REQUEST_CLAN_DATA,this.loadClanRewards);
         this._view.overView.hallOfFameButton.removeEventListener(MouseEvent.CLICK,this.handleOpenHallOfFameButtonClickEvent);
      }
      
      private function loadClanRewards(param1:AlienHuntEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new HuntRewardRequest(param1.vo.min,HuntRewardRequest.REWARDTYPE_CLAN));
      }
      
      private function loadPlayerRewards(param1:AlienHuntEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new HuntRewardRequest(param1.vo.min,HuntRewardRequest.REWARDTYPE_PLAYER));
      }
      
      public function update() : void
      {
         if(Boolean(this._data) && isUIReady())
         {
            this._view.point.npcList.list = new VectorCollection(this._data.pointItems);
            this._view.rewards.list.list = new VectorCollection(this._data.rewardItems);
            this.updatePoints();
            this.updateTime();
         }
      }
      
      private function updateEventTypeChanges() : void
      {
         if(this._data.windowTitle)
         {
            window.setTitle(this._data.windowTitle);
         }
         this._view.overView.hintButton.visible = this._data.hintButtonVisible;
         if(this._data.hintButtonToolTip)
         {
            this._view.overView.hintButton.tooltipData = this._data.hintButtonToolTip;
         }
      }
      
      private function updatePoints() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.overView.points.text = TextFormatter.roundInteger(this._data.overviewData.playerPoints);
            this._view.overView.clanPoints.text = TextFormatter.roundInteger(this._data.overviewData.totalClanPoints);
         }
      }
      
      private function handleOpenHallOfFameButtonClickEvent(param1:MouseEvent) : void
      {
         if(this._data.internalHallofFameView)
         {
            JavascriptProxy.referToURL("internalHallofFame&view=" + this._data.internalHallofFameView,null);
         }
      }
      
      private function updateTime() : void
      {
         this._view.overView.time.text = TimeFormatter.getSmartFormatedTime(this._data.timer.value);
      }
   }
}

