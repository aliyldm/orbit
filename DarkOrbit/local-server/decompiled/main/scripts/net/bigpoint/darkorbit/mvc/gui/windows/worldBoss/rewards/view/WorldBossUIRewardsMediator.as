package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rewards.view
{
   import com.bigpoint.utils.TextFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rewards.model.WorldBossUIRewardsData;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rewards.model.WorldBossUIRewardsVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class WorldBossUIRewardsMediator extends SimpleWindowMediator
   {
      
      public var buildCompleted:ISignal = new Signal();
      
      private var _data:WorldBossUIRewardsData;
      
      private var _view:WorldBossUIRewardsView;
      
      public function WorldBossUIRewardsMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this._data = null;
      }
      
      public function set data(param1:WorldBossUIRewardsData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.tierChanged.remove(this.update);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.tierChanged.add(this.update);
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new WorldBossUIRewardsView(simpleWindow);
         this.data = retrieveWindowProxy().getData() as WorldBossUIRewardsData;
         this.addListeners();
         this.buildCompleted.dispatch(this._view);
      }
      
      private function addListeners() : void
      {
      }
      
      private function removeListeners() : void
      {
      }
      
      public function manualLoad(param1:WorldBossUIRewardsView) : void
      {
         super.handleLoadAndBuildContentCallback(null);
         this._view = param1;
         this.data = retrieveWindowProxy().getData() as WorldBossUIRewardsData;
         this.addListeners();
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady() || this._data.rewardList == null || this._data.rewardList.length == 0)
         {
            return;
         }
         this._view.labelTier.text = TextFormatter.roundInteger(this._data.currTier);
         var _loc1_:Vector.<WorldBossUIRewardsVO> = this._data.rewardList[this._data.currTier];
         if(_loc1_ != null)
         {
            this._view.list = _loc1_;
         }
         this._view.labelDescription.text = BPLocale.getItem("worldboss_tier_info");
      }
   }
}

