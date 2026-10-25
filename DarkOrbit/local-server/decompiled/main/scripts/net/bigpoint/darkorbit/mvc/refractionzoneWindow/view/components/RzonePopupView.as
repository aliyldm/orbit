package net.bigpoint.darkorbit.mvc.refractionzoneWindow.view.components
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo.ClosingCrossServerState;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class RzonePopupView
   {
      
      public const closed:ISignal = new Signal();
      
      private var _popup:SimpleWindow;
      
      private var _popupContainer:Sprite;
      
      private var _currentState:ClosingCrossServerState;
      
      private var _label:Label;
      
      public function RzonePopupView(param1:SimpleWindow, param2:Sprite)
      {
         super();
         this._popup = param1;
         this._popupContainer = param2;
         this._label = FuiComponentSelectorUtil.selectComponent("content.time",this._popupContainer) as Label;
         this._popup.addEventListener(SimpleWindowEvent.ON_CLOSE,this.handleClose);
      }
      
      private function handleClose(param1:SimpleWindowEvent) : void
      {
         this.closed.dispatch();
         if(this._currentState)
         {
            this._currentState.timer.changed.remove(this.updateLabel);
         }
         this._popup.removeEventListener(SimpleWindowEvent.ON_CLOSE,this.handleClose);
      }
      
      public function dispose() : void
      {
         this._popup.cleanup();
      }
      
      public function set currentState(param1:ClosingCrossServerState) : void
      {
         if(this._currentState)
         {
            this._currentState.timer.changed.remove(this.updateLabel);
         }
         this._currentState = param1;
         this._currentState.timer.changed.add(this.updateLabel);
         this._popup.maximize();
      }
      
      private function updateLabel() : void
      {
         this._label.text = TimeFormatter.formatTime(this._currentState.timer.value);
      }
   }
}

