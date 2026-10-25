package net.bigpoint.darkorbit.map.view3D.utils
{
   import away3d.animators.ParticleAnimator;
   import away3d.entities.Mesh;
   import away3d.entities.ParticleGroup;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   
   public class ParticleLeasePool3D
   {
      
      private static var pools:Dictionary = new Dictionary();
      
      private static var leases:Dictionary = new Dictionary(true);
      
      private static var epoch:uint = 0;
      
      private static var idle:int = 0;
      
      private static const MAX_IDLE:int = 192;
      
      private static const PER_TYPE:int = 12;
      
      private static var listening:Boolean = false;
      
      public function ParticleLeasePool3D()
      {
         super();
      }
      
      public static function acquire(param1:ParticleGroup) : ParticleGroup
      {
         var _loc3_:ParticleGroup = null;
         var _loc4_:Boolean = false;
         var _loc5_:Mesh = null;
         var _loc6_:ParticleAnimator = null;
         if(!listening)
         {
            World3D.instance.resetSignal.add(clear);
            listening = true;
         }
         var _loc2_:Object = pools[param1];
         if(!_loc2_)
         {
            _loc4_ = true;
            for each(_loc5_ in param1.particleMeshes)
            {
               _loc6_ = _loc5_.animator as ParticleAnimator;
               if((Boolean(_loc6_)) && Boolean(_loc6_.animationSet.getAnimation("ParticleFollowLocalDynamic")))
               {
                  _loc4_ = false;
               }
            }
            _loc2_ = pools[param1] = {
               "items":[],
               "safe":_loc4_
            };
         }
         if(_loc2_.items.length)
         {
            _loc3_ = _loc2_.items.pop();
            --idle;
         }
         else
         {
            _loc3_ = param1.clone() as ParticleGroup;
         }
         leases[_loc3_] = {
            "epoch":epoch,
            "entry":_loc2_
         };
         _loc3_.animator.playbackSpeed = param1.animator.playbackSpeed;
         _loc3_.animator.time = 0;
         _loc3_.animator.resetTime();
         return _loc3_;
      }
      
      public static function release(param1:ParticleGroup) : void
      {
         var _loc2_:Object = leases[param1];
         if(!_loc2_)
         {
            return;
         }
         delete leases[param1];
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
         param1.animator.stop();
         if(_loc2_.epoch != epoch)
         {
            param1.dispose();
            return;
         }
         if(!_loc2_.entry.safe || idle >= MAX_IDLE || _loc2_.entry.items.length >= PER_TYPE)
         {
            param1.dispose();
            return;
         }
         _loc2_.entry.items.push(param1);
         ++idle;
      }
      
      public static function clear() : void
      {
         var _loc1_:Object = null;
         ++epoch;
         for each(_loc1_ in pools)
         {
            while(_loc1_.items.length)
            {
               ParticleGroup(_loc1_.items.pop()).dispose();
            }
         }
         pools = new Dictionary();
         idle = 0;
      }
   }
}

