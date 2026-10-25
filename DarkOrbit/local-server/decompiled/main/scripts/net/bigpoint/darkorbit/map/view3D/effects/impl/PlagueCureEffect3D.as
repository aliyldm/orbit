package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.impl.PlagueCureEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class PlagueCureEffect3D extends StandaloneParticle3D
   {
      
      private static const URL:String = "plague_cure.zip";
      
      public function PlagueCureEffect3D(param1:MapView3D, param2:PlagueCureEffect)
      {
         super(param2,URL,param2.source.position);
         if(param2.type == Effect.NOT_PERSISTANT)
         {
            addEvent("cycle",disposeView);
         }
      }
   }
}

