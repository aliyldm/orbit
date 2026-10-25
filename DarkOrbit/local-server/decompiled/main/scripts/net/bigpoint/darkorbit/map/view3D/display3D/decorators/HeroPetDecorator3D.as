package net.bigpoint.darkorbit.map.view3D.display3D.decorators
{
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberMesh3D;
   
   public class HeroPetDecorator3D implements IMapUberAssetDecorator3D, IDisposable
   {
      
      private var _viewOwner:UberAsset3D;
      
      private var _hiQ:Boolean = false;
      
      public function HeroPetDecorator3D()
      {
         super();
      }
      
      public function initialize(param1:UberDisplayTrait, param2:UberAsset3D, param3:Object) : void
      {
         this._viewOwner = param2;
      }
      
      public function decorate() : void
      {
         World3D.instance.mapView.cam.animatedZoom.changed.add(this.handleCameraZoomChanged);
         this.handleCameraZoomChanged();
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         World3D.instance.mapView.cam.animatedZoom.changed.remove(this.handleCameraZoomChanged);
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

