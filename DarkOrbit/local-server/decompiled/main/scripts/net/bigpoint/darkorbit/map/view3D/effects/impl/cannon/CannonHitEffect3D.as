package net.bigpoint.darkorbit.map.view3D.effects.impl.cannon
{
   import net.bigpoint.darkorbit.com.module.porting.cannon.CannonType;
   import net.bigpoint.darkorbit.map.model.effects.impl.cannon.CannonHitEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   
   public class CannonHitEffect3D extends StandaloneParticle3D
   {
      
      private static const FINISHED_ANIMATION_TIME_MS:int = 1500;
      
      public function CannonHitEffect3D(param1:MapView3D, param2:CannonHitEffect)
      {
         var _loc3_:String = "cannon_hit_electro.zip";
         switch(param2.cannonType)
         {
            case CannonType.CORROSIVE:
               _loc3_ = "cannon_hit_corrosive.zip";
               break;
            case CannonType.THERMAL:
               _loc3_ = "cannon_hit_thermal.zip";
               break;
            case CannonType.ELECTRO:
               _loc3_ = "cannon_hit_electro.zip";
         }
         super(param2,_loc3_,param2.source.position);
      }
      
      override public function updateObj(param1:Number) : void
      {
         if(view == null)
         {
            return;
         }
         super.updateObj(param1);
         if(Boolean(view) && view.animator.time >= FINISHED_ANIMATION_TIME_MS)
         {
            disposeView(true);
         }
      }
   }
}

