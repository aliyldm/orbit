package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import away3d.entities.ParticleGroup;
   import net.bigpoint.darkorbit.map.model.effects.impl.LowHpEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.AbstractEffect3D;
   
   public class LowHpEffect3D extends AbstractEffect3D
   {
      
      public static const MAX_DAMAGE_PARTICLES:uint = 5;
      
      private var _content:ParticleGroup;
      
      private var particlePositionsInQueue:Array = new Array();
      
      private var particles:Array = new Array();
      
      public function LowHpEffect3D(param1:MapView3D, param2:LowHpEffect)
      {
         super(param1,param2);
         if(associatedShip == null)
         {
            return;
         }
      }
      
      private function particlesReady(param1:ParticleGroup) : void
      {
         this._content = param1;
         associatedShip.view.addChild(this);
         var _loc2_:int = this.particlePositionsInQueue.length - 1;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.createParticleClone();
            _loc3_++;
         }
         this.particlePositionsInQueue.length = 0;
      }
      
      public function addPosition(param1:Number) : void
      {
         param1 = Math.min(MAX_DAMAGE_PARTICLES,param1);
         var _loc2_:int = 0;
         while(_loc2_ < MAX_DAMAGE_PARTICLES)
         {
            if(param1 > _loc2_)
            {
               if(this.particles.length > _loc2_)
               {
                  (this.particles[_loc2_] as ParticleGroup).visible = true;
               }
               else
               {
                  this.createParticleClone();
               }
            }
            else if(this.particles.length > _loc2_)
            {
               (this.particles[_loc2_] as ParticleGroup).visible = false;
            }
            _loc2_++;
         }
      }
      
      private function createParticleClone() : void
      {
      }
      
      override public function cleanup() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.particles.length)
         {
            (this.particles[_loc1_] as ParticleGroup).dispose();
            _loc1_++;
         }
         super.cleanup();
      }
   }
}

