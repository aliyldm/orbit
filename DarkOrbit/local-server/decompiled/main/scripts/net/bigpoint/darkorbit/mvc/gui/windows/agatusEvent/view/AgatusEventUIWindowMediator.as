package net.bigpoint.darkorbit.mvc.gui.windows.agatusEvent.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.gui.windows.agatusEvent.model.AgatusEventUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.agatusEvent.view.components.AgatusEventRootView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   
   public class AgatusEventUIWindowMediator extends SimpleWindowMediator
   {
      
      private static const WIN_WIDTH:int = 450;
      
      private static const WIN_HEIGHT:int = 140;
      
      private static const MID_HEIGHT:int = 65;
      
      private var _data:AgatusEventUIData;
      
      private var _view:AgatusEventRootView;
      
      public function AgatusEventUIWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         param2.setSize(WIN_WIDTH,WIN_HEIGHT);
      }
      
      public function set data(param1:AgatusEventUIData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.timer.changed.remove(this.updateTimer);
            ScreenManager.getInstance().mapChanged.remove(this.updateMiddleDescription);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.timer.changed.add(this.updateTimer);
            ScreenManager.getInstance().mapChanged.add(this.updateMiddleDescription);
            this.configureWindow();
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new AgatusEventRootView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as AgatusEventUIData;
      }
      
      public function update() : void
      {
         if(Boolean(this._data) && isUIReady())
         {
            this.updateTopDescription();
            if(this._data.hasBoss)
            {
               this.updateMiddleDescription();
               this.updateNpcProgress();
            }
            this.updateTimer();
         }
      }
      
      private function updateTopDescription() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.topDescription.text = this._data.topDescription;
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
            this._view.npcKillCountdown.text = this._data.middleDescription;
            if(this._data.hasBoss)
            {
               this._view.npcKillCountdown.text = this._view.npcKillCountdown.text.replace("%MAP%",Map.getMapName(ScreenManager.getInstance().map.mapID));
            }
         }
      }
      
      private function updateNpcProgress() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.leftToKill > 0)
            {
               this._view.npcEventCountdownProgress.text = TextFormatter.roundInteger(this._data.leftToKill);
            }
            else
            {
               this._view.npcEventCountdownProgress.text = "";
            }
         }
      }
      
      private function configureWindow() : void
      {
         if(Boolean(this._data) && isUIReady())
         {
            window.setTitle(this._data.windowTitle);
            if(this._data.hasBoss)
            {
               window.setSize(WIN_WIDTH,WIN_HEIGHT + MID_HEIGHT);
               this._view.bottom.marginTop = 130;
               this._view.middle.visible = true;
            }
            else
            {
               window.setSize(WIN_WIDTH,WIN_HEIGHT);
               this._view.middle.visible = false;
               this._view.bottom.marginTop = 65;
            }
            this._view.eventDescription.localizedText = this._data.eventDescriptionTextkey;
         }
      }
   }
}

