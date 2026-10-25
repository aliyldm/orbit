package net.bigpoint.darkorbit.mvc.gui.windows.curcubitor2019.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.curcubitor2019.model.Curcubitor2019UIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.curcubitor2019.view.components.Curcubitor2019RootView;
   
   public class Curcubitor2019UIWindowMediator extends SimpleWindowMediator
   {
      
      private var _data:Curcubitor2019UIData;
      
      private var _view:Curcubitor2019RootView;
      
      public function Curcubitor2019UIWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         param2.setSize(450,205);
      }
      
      public function set data(param1:Curcubitor2019UIData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.timer.changed.remove(this.updateTimer);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.timer.changed.add(this.updateTimer);
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new Curcubitor2019RootView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as Curcubitor2019UIData;
      }
      
      public function update() : void
      {
         if(Boolean(this._data) && isUIReady())
         {
            this.updateTopDescription();
            this.updateMiddleDescription();
            this.updateCurcubitorProgress();
            this.updateTimer();
         }
      }
      
      private function updateTopDescription() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.topDescription.localizedText = this._data.topDescription;
         }
      }
      
      private function updateTimer() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.timer.value > 0)
            {
               this._view.timer.text = TimeFormatter.getSmartFormatedTime(this._data.timer.value);
            }
            else
            {
               this._view.timer.text = "";
            }
         }
      }
      
      private function updateMiddleDescription() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.middleDescription.localizedText = this._data.middleDescription;
            if(this._data.hasCurcubitors)
            {
               this._view.middleDescription.text = this._view.middleDescription.text.replace("%MAP%",Map.getMapName(ScreenManager.getInstance().map.mapID));
            }
         }
      }
      
      private function updateCurcubitorProgress() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.leftToKill > 0)
            {
               this._view.curcubitorCountdownProgress.text = TextFormatter.roundInteger(this._data.leftToKill);
            }
            else
            {
               this._view.curcubitorCountdownProgress.text = "";
            }
         }
      }
   }
}

