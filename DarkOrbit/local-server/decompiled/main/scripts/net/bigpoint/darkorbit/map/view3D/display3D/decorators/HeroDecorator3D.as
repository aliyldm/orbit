package net.bigpoint.darkorbit.map.view3D.display3D.decorators
{
   import away3d.lights.LightBase;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberMesh3D;
   
   public class HeroDecorator3D implements IMapUberAssetDecorator3D, IDisposable
   {
      
      private var _viewOwner:UberAsset3D;
      
      private var _hiQ:Boolean = false;
      
      private var _ship:Ship;
      
      public function HeroDecorator3D()
      {
         super();
      }
      
      public function initialize(param1:UberDisplayTrait, param2:UberAsset3D, param3:Object) : void
      {
         this._ship = param1.owner as Ship;
         this._viewOwner = param2;
         if(this._ship.isHeroShip())
         {
            this._viewOwner.addChild(World3D.instance.lights.hero);
         }
      }
      
      public function decorate() : void
      {
         World3D.instance.mapView.cam.animatedZoom.changed.add(this.handleCameraZoomChanged);
         this.handleCameraZoomChanged();
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         var _loc2_:LightBase = null;
         World3D.instance.mapView.cam.animatedZoom.changed.remove(this.handleCameraZoomChanged);
         if(this._ship.isHeroShip())
         {
            _loc2_ = World3D.instance.lights.hero;
            if(_loc2_.parent == this._viewOwner)
            {
               _loc2_.parent.removeChild(_loc2_);
            }
         }
      }
      
      private function handleCameraZoomChanged() : void
      {
         var _loc2_:UberMesh3D = null;
         var _loc1_:Boolean = World3D.instance.mapView.cam.animatedZoom.value > 1.3;
         if(this._hiQ != _loc1_)
         {
            this._hiQ = _loc1_;
            for each(_loc2_ in this._viewOwner.uberMeshes)
            {
               _loc2_.mesh.materials.sizeMultiplier.value = this._hiQ ? 2 : 1;
            }
         }
      }
   }
}

