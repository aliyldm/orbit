package net.bigpoint.darkorbit.mvc.refractionzoneWindow.view.components
{
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo.BaseCrossServerState;
   
   public class RZoneViewStateDecorator
   {
      
      protected var _object:Coreponent;
      
      protected var _state:BaseCrossServerState;
      
      public function RZoneViewStateDecorator(param1:Coreponent, param2:BaseCrossServerState)
      {
         super();
         this._object = param1;
         this._state = param2;
      }
      
      public function dispose() : void
      {
         this._object = null;
         this._state = null;
      }
   }
}

