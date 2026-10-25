package net.bigpoint.darkorbit.mvc.refractionzoneWindow.view.components
{
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo.OnRZoneCrossServerState;
   
   public class RZoneViewOnRZoneStateDecorator extends RZoneViewStateDecorator
   {
      
      private var _btn:Button;
      
      public function RZoneViewOnRZoneStateDecorator(param1:Coreponent, param2:OnRZoneCrossServerState)
      {
         super(param1,param2);
         this._btn = FuiComponentSelectorUtil.selectComponent("leave",param1) as Button;
         this.currentState.enabled.changed.add(this.updateBTN);
         this.updateBTN();
      }
      
      private function updateBTN() : void
      {
         this._btn.enabled = this.currentState.enabled.value;
      }
      
      private function get currentState() : OnRZoneCrossServerState
      {
         return _state as OnRZoneCrossServerState;
      }
      
      override public function dispose() : void
      {
         this.currentState.enabled.changed.remove(this.updateBTN);
         super.dispose();
      }
   }
}

