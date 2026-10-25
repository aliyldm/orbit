package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.Particle3D;
   
   public class StandaloneParticle3D extends Particle3D implements IUpdatable, IDisposable
   {
      
      private var _targetDisplayTrait:UberDisplayTrait;
      
      private var _worldPosition:PointLite;
      
      private var _offset3D:Vector3D;
      
      public var fixedScale:Number = 1;
      
      public function StandaloneParticle3D(param1:Effect, param2:String, param3:PointLite, param4:MapEntity = null, param5:Boolean = false, param6:Number = 0, param7:Boolean = true, param8:Number = 0)
      {
         this._worldPosition = param3;
         if(param4 == null && param1 is MapObjectEffect)
         {
            param4 = MapObjectEffect(param1).source;
         }
         if(param4)
         {
            this._targetDisplayTrait = param4.getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
         }
         super(param2,param5,param6,param7,param8);
      }
      
      override public function updateObj(param1:Number) : void
      {
         this.updateScale();
         this.updatePosition();
         super.updateObj(param1);
      }
      
      private function updatePosition() : void
      {
         if(this._worldPosition)
         {
            if(this._offset3D)
            {
               view.moveTo(this._worldPosition.x + this._offset3D.x,this._worldPosition.z + this._offset3D.y,-this._worldPosition.y + this._offset3D.z);
            }
            else
            {
               view.moveTo(this._worldPosition.x,this._worldPosition.z,-this._worldPosition.y);
            }
         }
      }
      
      protected function updateScale() : void
      {
         if(this._targetDisplayTrait)
         {
            scale = this._targetDisplayTrait.visualSize3D * this.fixedScale;
         }
      }
      
      override protected function initAndPlay() : void
      {
         World3D.instance.mapView.addUpdatable(this);
         World3D.instance.mapView.addRenderable(this);
         World3D.instance.mapView.gameWorld.addChild(view);
         super.initAndPlay();
      }
      
      override protected function cleanUpView() : void
      {
         World3D.instance.mapView.removeUpdatable(this);
         World3D.instance.mapView.removeRenderable(this);
         super.cleanUpView();
      }
      
      public function get offset3D() : Vector3D
      {
         if(this._offset3D == null)
         {
            this._offset3D = new Vector3D(0,0,0);
         }
         return this._offset3D;
      }
      
      public function set offset3D(param1:Vector3D) : void
      {
         this._offset3D = this.offset3D;
      }
   }
}

