package net.bigpoint.darkorbit.map.view2D.display
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.view2D.display.ship.ShipClip;
   import net.bigpoint.darkorbit.mvc.traininggrounds.SimpleShipDisplayTrait;
   
   public class SimpleShip2D extends Sprite implements IDisposable
   {
      
      private var _trait:SimpleShipDisplayTrait;
      
      private var _clip:ShipClip;
      
      public function SimpleShip2D(param1:SimpleShipDisplayTrait)
      {
         super();
         this._trait = param1;
         this._trait.position.changed.add(this.updatePosition);
         this.initView();
         this.updatePosition();
      }
      
      private function initView() : void
      {
         this._clip = new ShipClip(null,this._trait.rotation);
         this._clip.load(this._trait.res.srcKey,this._trait.res.resKey,this._trait.rotatable,this._trait.loop);
         addChild(this._clip);
      }
      
      private function updatePosition() : void
      {
         x = this._trait.position.x;
         y = this._trait.position.y;
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this._trait.position.changed.remove(this.updatePosition);
         this._clip.cleanup();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

