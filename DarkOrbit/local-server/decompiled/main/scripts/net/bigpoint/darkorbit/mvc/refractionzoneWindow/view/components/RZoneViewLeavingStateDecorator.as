package net.bigpoint.darkorbit.mvc.refractionzoneWindow.view.components
{
   import com.bigpoint.utils.TimeFormatter;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo.LeavingCrossServerState;
   
   public class RZoneViewLeavingStateDecorator extends RZoneViewStateDecorator
   {
      
      private var _time:Label;
      
      public function RZoneViewLeavingStateDecorator(param1:Coreponent, param2:LeavingCrossServerState)
      {
         super(param1,param2);
         this._time = FuiComponentSelectorUtil.selectComponent("time",param1) as Label;
         this.leaveState.countDown.changed.add(this.updateTime);
         this.updateTime();
      }
      
      private function get leaveState() : LeavingCrossServerState
      {
         return _state as LeavingCrossServerState;
      }
      
      private function updateTime() : void
      {
         this._time.text = TimeFormatter.formatTime(this.leaveState.countDown.value);
      }
      
      override public function dispose() : void
      {
         this.leaveState.countDown.changed.remove(this.updateTime);
         super.dispose();
      }
   }
}

