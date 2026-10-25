package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.progress.view
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.progress.model.WorldBossUIProgressData;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.progress.model.WorldBossUIProgressVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class WorldBossUIProgressMediator extends SimpleWindowMediator
   {
      
      public var buildCompleted:ISignal = new Signal();
      
      private var _data:WorldBossUIProgressData;
      
      private var _view:WorldBossUIProgressView;
      
      public function WorldBossUIProgressMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this._data = null;
      }
      
      public function set data(param1:WorldBossUIProgressData) : void
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
         this._view = new WorldBossUIProgressView(simpleWindow);
         this.data = retrieveWindowProxy().getData() as WorldBossUIProgressData;
         this.addListeners();
         this.buildCompleted.dispatch(this._view);
      }
      
      private function addListeners() : void
      {
      }
      
      private function removeListeners() : void
      {
      }
      
      public function manualLoad(param1:WorldBossUIProgressView) : void
      {
         super.handleLoadAndBuildContentCallback(null);
         this._view = param1;
         this.data = retrieveWindowProxy().getData() as WorldBossUIProgressData;
         this.addListeners();
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady() || this._data.raidList == null || this._data.raidList.length == 0)
         {
            return;
         }
         var _loc1_:Vector.<WorldBossUIProgressVO> = this._data.raidList;
         if(_loc1_ != null)
         {
            this._view.list = _loc1_;
         }
         this._view.labelDescription.text = BPLocale.getItem("worldboss_progress_info");
      }
   }
}

