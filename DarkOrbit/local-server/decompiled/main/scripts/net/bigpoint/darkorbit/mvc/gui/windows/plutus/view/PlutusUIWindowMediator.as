package net.bigpoint.darkorbit.mvc.gui.windows.plutus.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import net.bigpoint.darkorbit.com.module.RankRewardRequest;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.plutus.model.PlutusUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.plutus.view.components.PlutusRootView;
   import net.bigpoint.darkorbit.mvc.gui.windows.plutus.view.components.event.PlutusEvent;
   
   public class PlutusUIWindowMediator extends SimpleWindowMediator
   {
      
      private var _data:PlutusUIData;
      
      private var _view:PlutusRootView;
      
      public function PlutusUIWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         param2.setSize(360,285);
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this.data = null;
      }
      
      public function set data(param1:PlutusUIData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.timerDown.changed.remove(this.updateTimeDown);
            this._data.timerUp.changed.remove(this.updateTimeUp);
            this._data.overviewData.changed.remove(this.updatePoints);
            this._data.overviewData.changed.remove(this.updateDescription);
            this._data.overviewData.changed.remove(this.updateLives);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.timerDown.changed.add(this.updateTimeDown);
            this._data.timerUp.changed.add(this.updateTimeUp);
            this._data.overviewData.changed.add(this.updatePoints);
            this._data.overviewData.changed.add(this.updateDescription);
            this._data.overviewData.changed.add(this.updateLives);
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new PlutusRootView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as PlutusUIData;
         this.addListeners();
      }
      
      private function addListeners() : void
      {
         this._view.rewards.list.addEventListener(PlutusEvent.REQUEST_PLAYER_DATA,this.loadRewards);
      }
      
      private function removeListeners() : void
      {
         this._view.rewards.list.removeEventListener(PlutusEvent.REQUEST_PLAYER_DATA,this.loadRewards);
      }
      
      private function loadRewards(param1:PlutusEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new RankRewardRequest(param1.vo.min,RankRewardRequest.RANKTYPE_GAUNTLET_OF_PLUTUS));
      }
      
      public function update() : void
      {
         if(Boolean(this._data) && isUIReady())
         {
            this._view.rewards.list.list = new VectorCollection(this._data.rewardItems);
            this._view.records.list.list = new VectorCollection(this._data.recordItems);
            this.updatePoints();
            this.updateTimeDown();
            this.updateDescription();
            this.updateLives();
         }
      }
      
      private function updatePoints() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.overView.points.text = TextFormatter.roundInteger(this._data.overviewData.playerPoints);
         }
      }
      
      private function updateTimeDown() : void
      {
         this._view.overView.time.text = TimeFormatter.getSmartFormatedTime(this._data.timerDown.value);
      }
      
      private function updateTimeUp() : void
      {
         this._view.overView.time.text = TimeFormatter.getSmartFormatedTime(this._data.timerUp.value);
      }
      
      private function updateDescription() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.overView.description.localizedText = this._data.overviewData.description;
            this._view.overView.descriptionContainer.forceRedraw();
         }
      }
      
      private function updateLives() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.overviewData.playerLives < 0)
            {
               this._view.overView.lives.text = "-";
            }
            else
            {
               this._view.overView.lives.text = TextFormatter.roundInteger(this._data.overviewData.playerLives);
            }
         }
      }
   }
}

