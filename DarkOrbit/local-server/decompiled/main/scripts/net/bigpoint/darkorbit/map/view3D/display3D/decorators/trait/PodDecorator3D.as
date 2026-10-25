package net.bigpoint.darkorbit.map.view3D.display3D.decorators.trait
{
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.ship.PodCarrierTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.MapUberAsset3D;
   
   public class PodDecorator3D implements IDisposable
   {
      
      private var _owner:MapUberAsset3D;
      
      public function PodDecorator3D(param1:PodCarrierTrait, param2:MapUberAsset3D)
      {
         super();
         this._owner = param2;
         if(Boolean(this._owner) && Boolean(this._owner.getViewElement("main.content.pod")))
         {
            this._owner.getViewElement("main.content.pod").visible = true;
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(Boolean(this._owner) && Boolean(this._owner.getViewElement("main.content.pod")))
         {
            this._owner.getViewElement("main.content.pod").visible = false;
         }
      }
   }
}

