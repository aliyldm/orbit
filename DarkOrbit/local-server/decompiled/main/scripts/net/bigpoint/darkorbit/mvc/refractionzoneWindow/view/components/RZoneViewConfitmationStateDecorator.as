package net.bigpoint.darkorbit.mvc.refractionzoneWindow.view.components
{
   import com.bigpoint.utils.TimeFormatter;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo.ConfirmationCrossServerState;
   
   public class RZoneViewConfitmationStateDecorator extends RZoneViewStateDecorator
   {
      
      private var _label:Label;
      
      public function RZoneViewConfitmationStateDecorator(param1:Coreponent, param2:ConfirmationCrossServerState)
      {
         super(param1,param2);
         this._label = FuiComponentSelectorUtil.selectComponent("time",param1) as Label;
         this.queueingState.timer.changed.add(this.handleTimeChanged);
         this.handleTimeChanged();
      }
      
      private function handleTimeChanged() : void
      {
         this._label.text = TimeFormatter.formatTime(this.queueingState.timer.value);
      }
      
      private function get queueingState() : ConfirmationCrossServerState
      {
         return _state as ConfirmationCrossServerState;
      }
      
      override public function dispose() : void
      {
         this.queueingState.timer.changed.remove(this.handleTimeChanged);
         super.dispose();
      }
   }
}

