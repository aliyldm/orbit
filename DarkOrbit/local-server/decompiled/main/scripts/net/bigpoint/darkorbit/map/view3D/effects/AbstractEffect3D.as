package net.bigpoint.darkorbit.map.view3D.effects
{
   import away3d.containers.ObjectContainer3D;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.traits.ShipDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.ship.Ship3D;
   
   public class AbstractEffect3D extends ObjectContainer3D implements IDisposable
   {
      
      private var _mapView:MapView3D;
      
      private var _effect:Effect;
      
      private var _associatedShip:Ship3D;
      
      public function AbstractEffect3D(param1:MapView3D, param2:Effect)
      {
         super();
         this._effect = param2;
         this._mapView = param1;
         var _loc3_:MapObjectEffect = this._effect as MapObjectEffect;
         if(_loc3_)
         {
            this._associatedShip = param1.mainContainer.getViewByTrait(_loc3_.source.getFirstTrait(ShipDisplayTrait)) as Ship3D;
         }
      }
      
      public function cleanup() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this.cleanup();
      }
      
      protected function get effect() : Effect
      {
         return this._effect;
      }
      
      protected function get associatedShip() : Ship3D
      {
         return this._associatedShip;
      }
      
      public function get mapView() : MapView3D
      {
         return this._mapView;
      }
   }
}

