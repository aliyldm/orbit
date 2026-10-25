package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.greensock.easing.Quad;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.effects.impl.IcyCubeEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class IcyCubeEffect3D implements IUpdatable, IDisposable
   {
      
      private var _uber:UberAsset3D;
      
      private var _effect:IcyCubeEffect;
      
      private var _internalScale:Number = 1;
      
      private var _scaleTimer:Number = 0;
      
      private var _mapView:MapView3D;
      
      public function IcyCubeEffect3D(param1:MapView3D, param2:IcyCubeEffect)
      {
         super();
         this._effect = param2;
         this._mapView = param1;
         this._uber = new UberAsset3D(UberAssetsLib.instance.getDescriptor("icy-cube-effect",UberAssetsLib.LIB_DEFAULT).display3D[0]);
         this._uber.rotationY = Ship(this._effect.source).rotation.degrees;
         this._mapView.addUpdatable(this);
         this._mapView.gameWorld.addChild(this._uber);
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:UberDisplayTrait = null;
         if(this._uber)
         {
            this._uber.moveTo(this._effect.source.x3D,this._effect.source.y3D,this._effect.source.z3D);
            _loc2_ = Number.NaN;
            _loc3_ = this._effect.source.getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
            if(_loc3_)
            {
               _loc2_ = _loc3_.visualSize3D;
            }
            if(this._internalScale != _loc2_ && !isNaN(_loc2_))
            {
               this._internalScale = _loc2_;
               this._scaleTimer = 0;
            }
            this._scaleTimer += param1;
            this._uber.scaleX = this._uber.scaleY = this._uber.scaleZ = Quad.easeInOut(Math.min(this._scaleTimer,0.5),this._uber.scaleX,this._internalScale - this._uber.scaleX,0.5);
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._uber)
         {
            this._uber.disposeView(true);
            this._uber = null;
            this._mapView.removeUpdatable(this);
         }
      }
   }
}

