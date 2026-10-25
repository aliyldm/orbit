package net.bigpoint.darkorbit.mvc.refractionzoneWindow.view.components
{
   import com.bigpoint.utils.TimeFormatter;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo.ClosingCrossServerState;
   
   public class RZoneViewClosingStateDecorator extends RZoneViewStateDecorator
   {
      
      private var _label:Label;
      
      public function RZoneViewClosingStateDecorator(param1:Coreponent, param2:ClosingCrossServerState)
      {
         super(param1,param2);
         this._label = FuiComponentSelectorUtil.selectComponent("time",param1) as Label;
         this.closingState.timer.changed.add(this.handleTimeChanged);
         this.handleTimeChanged();
      }
      
      private function handleTimeChanged() : void
      {
         this._label.text = TimeFormatter.formatTime(this.closingState.timer.value);
      }
      
      private function get closingState() : ClosingCrossServerState
      {
         return _state as ClosingCrossServerState;
      }
      
      override public function dispose() : void
      {
         this.closingState.timer.changed.remove(this.handleTimeChanged);
         super.dispose();
      }
   }
}

