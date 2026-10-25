package net.bigpoint.darkorbit.map.view3D.display3D.ship.drones
{
   import away3d.containers.ObjectContainer3D;
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.bindables.BindableRotation;
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.drones.Drone;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.ship.Slot3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.ship.engine.EngineTrails;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   import net.bigpoint.darkorbit.settings.CrowdedCombatPreset;
   
   public class Drone3D extends ObjectContainer3D implements IUpdatable, IDisposable
   {
      
      public const targetPosition:Vector3D = new Vector3D();
      
      public var rotationParent:ObjectContainer3D;
      
      public var groupRotation:Vector3D;
      
      private var _drone:Drone;
      
      private var _rotationSource:BindableRotation;
      
      private var _view:UberAsset3D;
      
      private var _owner:Ship;
      
      private var _formationPosition:PointLite;
      
      private var _delay:Number = 0.3;
      
      private var _trail:EngineTrails = null;
      
      public function Drone3D(param1:Drone, param2:Ship)
      {
         super();
         this._drone = param1;
         this._owner = param2;
         this._formationPosition = new PointLite();
         this.targetPosition.setTo(param2.x3D,param2.y3D,param2.z3D);
         this.rotationSource = param2.rotation;
         this.update();
         this._owner.cloaked.changed.add(this.updateAlpha);
         this.updateAlpha();
         this.updateTrail();
      }
      
      private function updateTrail() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this._trail)
         {
            if(!Settings3D.effects.medium.value)
            {
               World3D.instance.mapView.gameWorld.removeChild(this._trail);
               this._trail.dispose();
               this._trail = null;
            }
            return;
         }
         var _loc1_:uint = uint(this._drone.uberAssetDescriptor.trail.@color);
         if(Boolean(Settings3D.effects.medium.value) && Boolean(_loc1_) && (!CrowdedCombatPreset.enabled || this._owner.isHeroShip()))
         {
            _loc2_ = Number(Number(this._drone.uberAssetDescriptor.trail.@length) || 1);
            _loc3_ = Number(Number(this._drone.uberAssetDescriptor.trail.@thickness) || 1);
            this._trail = new EngineTrails(this,Vector.<Slot3D>([new Slot3D(0,0,0,1)]),this._owner.rotation,_loc1_,_loc2_,_loc3_);
            World3D.instance.mapView.gameWorld.addChild(this._trail);
         }
      }
      
      private function updateAlpha() : void
      {
         if(this._view)
         {
            TweenLite.to(this._view,0.2,{"alpha":(this._owner.cloaked.value ? 0.5 : 1)});
         }
      }
      
      private function update() : void
      {
         if(this._view)
         {
            removeChild(this._view);
            this._view = null;
         }
         addChild(this._view = new UberAsset3D(this._drone.uberAssetDescriptor.display3D[0],null,null,false));
         this.updateAlpha();
      }
      
      private function set rotationSource(param1:BindableRotation) : void
      {
         this._rotationSource = param1;
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._trail)
         {
            this._trail.parent.removeChild(this._trail);
            this._trail.dispose();
            this._trail = null;
         }
         this.rotationSource = null;
         this._owner.cloaked.changed.remove(this.updateAlpha);
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this._view)
         {
            this._view.disposeView();
            this._view = null;
         }
      }
      
      public function updateObj(param1:Number) : void
      {
         x = this._delay > 0 ? Quad.easeOut(param1,x,this.targetPosition.x - x,this._delay) : this.targetPosition.x;
         y = this._delay > 0 ? Quad.easeOut(param1,y,this.targetPosition.y - y,this._delay) : this.targetPosition.y;
         z = this._delay > 0 ? Quad.easeOut(param1,z,this.targetPosition.z - z,this._delay) : this.targetPosition.z;
         this.updateTrail();
         if(this._trail)
         {
            this._trail.updateObj(param1);
         }
      }
      
      public function get drone() : Drone
      {
         return this._drone;
      }
      
      public function get view() : UberAsset3D
      {
         return this._view;
      }
   }
}

