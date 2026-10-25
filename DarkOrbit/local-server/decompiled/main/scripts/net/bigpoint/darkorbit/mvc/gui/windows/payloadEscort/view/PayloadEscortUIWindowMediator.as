package net.bigpoint.darkorbit.mvc.gui.windows.payloadEscort.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import net.bigpoint.darkorbit.com.module.RankRewardRequest;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.ItemLoader;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.payloadEscort.model.PayloadEscortUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.payloadEscort.view.components.PayloadEscortRootView;
   import net.bigpoint.darkorbit.mvc.gui.windows.payloadEscort.view.components.event.PayloadEscortEvent;
   
   public class PayloadEscortUIWindowMediator extends SimpleWindowMediator
   {
      
      private var _data:PayloadEscortUIData;
      
      private var _view:PayloadEscortRootView;
      
      public function PayloadEscortUIWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         param2.setSize(450,267);
      }
      
      override public function onRemove() : void
      {
         this._view.rewards.list.removeEventListener(PayloadEscortEvent.REQUEST_PLAYER_DATA,this.loadRewards);
         super.onRemove();
         this.data = null;
      }
      
      public function set data(param1:PayloadEscortUIData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.timer.changed.remove(this.updateTimer);
            this._data.escortKeys.changed.remove(this.updateKeys);
            this._data.isInEventMap.changed.remove(this.updateTimer);
            this._data.isInEventMap.changed.remove(this.updateTopDescription);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.timer.changed.add(this.updateTimer);
            this._data.escortKeys.changed.add(this.updateKeys);
            this._data.isInEventMap.changed.add(this.updateTimer);
            this._data.isInEventMap.changed.add(this.updateTopDescription);
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new PayloadEscortRootView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as PayloadEscortUIData;
         this.loadKeyImage();
         this._view.rewards.list.addEventListener(PayloadEscortEvent.REQUEST_PLAYER_DATA,this.loadRewards);
      }
      
      private function loadKeyImage() : void
      {
         var _loc4_:ItemLoader = null;
         var _loc1_:String = "";
         var _loc2_:String = "resource_key_access-escort";
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
      
      private function loadRewards(param1:PayloadEscortEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new RankRewardRequest(param1.vo.permanentPointsMin,RankRewardRequest.RANKTYPE_PAYLOAD_ESCORT));
      }
      
      public function update() : void
      {
         if(Boolean(this._data) && isUIReady())
         {
            this._view.rewards.list.list = new VectorCollection(this._data.rewardItems);
            this.updateTopDescription();
            this.updateTimer();
            this.updateKeys();
            this.updateTotalScore();
         }
      }
      
      private function updateTopDescription() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.inEventMap)
            {
               this._view.overView.topDescription.text = this._data.topDescriptionInEventMap;
               this._view.overView.scoreToolTip.visible = true;
               this._view.overView.runScore.visible = true;
               this._view.overView.timer.visible = false;
            }
            else
            {
               this._view.overView.scoreToolTip.visible = false;
               this._view.overView.runScore.visible = false;
               this._view.overView.timer.visible = true;
               this._view.overView.topDescription.text = this._data.topDescription;
            }
         }
      }
      
      private function updateTimer() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.inEventMap)
            {
               this._view.overView.runScore.text = TextFormatter.roundInteger(this._data.runScore);
            }
            else if(this._data.timer.value > 0)
            {
               this._view.overView.timer.text = TimeFormatter.getSmartFormatedTime(this._data.timer.value);
            }
            else
            {
               this._view.overView.timer.text = "";
            }
         }
      }
      
      private function updateKeys() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.overView.keyAmount.text = TextFormatter.roundInteger(this._data.escortKeys.value);
         }
      }
      
      private function updateTotalScore() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.overView.escortScore.text = TextFormatter.roundInteger(this._data.totalScore);
         }
      }
   }
}

