package net.bigpoint.darkorbit.map.view3D.display3D.decorators
{
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   
   public class TurretDecorator3D implements IMapUberAssetDecorator3D, IUpdatable
   {
      
      private var _trait:UberDisplayTrait;
      
      private var _viewOwner:UberAsset3D;
      
      public function TurretDecorator3D()
      {
         super();
      }
      
      public function initialize(param1:UberDisplayTrait, param2:UberAsset3D, param3:Object) : void
      {
         this._trait = param1;
         this._viewOwner = param2;
      }
      
      public function decorate() : void
      {
         this._viewOwner.disableFloating();
         this._viewOwner.playAnimation("openFlower");
         this._viewOwner.playAnimation("openTurret");
      }
      
      public function updateObj(param1:Number) : void
      {
         this._viewOwner.getViewElement("turret-base").rotationY = -this._viewOwner.rotationY;
         this._viewOwner.getViewElement("turret-base").rotationX = -this._viewOwner.rotationX;
         this._viewOwner.getViewElement("turret-base").rotationZ = -this._viewOwner.rotationZ;
      }
   }
}

