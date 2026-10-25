package net.bigpoint.darkorbit.map.view3D.effects.combat.laser
{
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.ScatterLaserEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.MapUberAsset3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.prefab.ShipView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.ship.Slot3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.Particle3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberMesh3D;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   
   public class ScatterLaserEffect3D implements IUpdatable, IDisposable
   {
      
      private var _particles:Array = [];
      
      private var _ship3D:MapUberAsset3D;
      
      private var _numLasers:int = 0;
      
      private var _numReadyParticles:int = 0;
      
      private var _allLaserPositions:Vector.<Slot3D> = new Vector.<Slot3D>();
      
      private var mesh3D:UberMesh3D;
      
      public function ScatterLaserEffect3D(param1:MapView3D, param2:ScatterLaserEffect)
      {
         super();
         if(Settings3D.effects.max.value == false)
         {
            return;
         }
         Settings3D.effects.max.changed.add(this.handleQualityChanged);
         var _loc3_:Ship = param2.source as Ship;
         this._ship3D = param1.mainContainer.getViewByTrait(_loc3_.getFirstTrait(UberDisplayTrait)) as MapUberAsset3D;
         this._ship3D.ready.add(this.playEffect);
         this.playEffect();
      }
      
      private function handleQualityChanged() : void
      {
         if(Settings3D.effects.max.value == false)
         {
            this.disposeView();
         }
      }
      
      private function playEffect() : void
      {
         var _loc2_:String = null;
         var _loc3_:Slot3D = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Particle3D = null;
         this.cleanupParticles();
         this._allLaserPositions.length = 0;
         this.mesh3D = this._ship3D.uberMeshes[0];
         var _loc1_:ShipView3D = ShipView3D(this.mesh3D.mesh);
         for(_loc2_ in _loc1_.lasersSlots)
         {
            _loc3_ = _loc1_.lasersSlots[_loc2_];
            this._allLaserPositions.push(_loc3_);
         }
         this._numLasers = this._allLaserPositions.length;
         _loc4_ = int(this._allLaserPositions.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new Particle3D("glow_scatter_laser.zip",true);
            _loc6_.ready.add(this.handleGlowReady);
            this._particles.push(_loc6_);
            _loc5_++;
         }
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc4_:Particle3D = null;
         var _loc2_:int = int(this._particles.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._particles[_loc3_];
            _loc4_.updateObj(param1);
            _loc3_++;
         }
      }
      
      private function handleGlowReady() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Particle3D = null;
         var _loc4_:Slot3D = null;
         ++this._numReadyParticles;
         if(this._numReadyParticles == this._numLasers)
         {
            _loc1_ = int(this._particles.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._particles[_loc2_];
               _loc4_ = this._allLaserPositions[_loc2_];
               this.mesh3D.addChild(_loc3_.view);
               _loc3_.view.moveTo(_loc4_.x,_loc4_.y,_loc4_.z);
               World3D.instance.mapView.addRenderable(_loc3_);
               _loc2_++;
            }
            World3D.instance.mapView.addUpdatable(this);
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._ship3D)
         {
            this._ship3D.ready.remove(this.playEffect);
         }
         this.cleanupParticles();
      }
      
      private function cleanupParticles() : void
      {
         var _loc3_:Particle3D = null;
         World3D.instance.mapView.removeUpdatable(this);
         var _loc1_:int = int(this._particles.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._particles[_loc2_];
            _loc3_.ready.remove(this.handleGlowReady);
            World3D.instance.mapView.removeRenderable(_loc3_);
            _loc3_.disposeView(true);
            _loc3_ = null;
            _loc2_++;
         }
         this._particles.length = 0;
      }
   }
}

