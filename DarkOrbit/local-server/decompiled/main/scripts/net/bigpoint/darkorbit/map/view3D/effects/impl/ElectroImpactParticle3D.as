package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   
   public class ElectroImpactParticle3D extends StandaloneParticle3D
   {
      
      private static const FINISHED_ANIMATION_TIME_MS:int = 1500;
      
      public function ElectroImpactParticle3D(param1:Effect, param2:String, param3:PointLite)
      {
         super(param1,param2,param3,null,true);
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

