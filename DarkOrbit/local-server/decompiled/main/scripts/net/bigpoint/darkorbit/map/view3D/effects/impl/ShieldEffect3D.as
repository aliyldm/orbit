package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ShieldEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class ShieldEffect3D extends StandaloneParticle3D
   {
      
      private static const URL:String = "shield_infinity.zip";
      
      protected var _effect:ShieldEffect;
      
      public function ShieldEffect3D(param1:MapView3D, param2:ShieldEffect)
      {
         var _loc3_:String = URL;
         if(param2.pattern.isChargeShotPlus || param2.pattern.isDAEffect)
         {
            _loc3_ = param2.pattern.resKey + ".zip";
         }
         this._effect = param2;
         super(param2,_loc3_,param2.source.position);
         this.fixedScale = param2.pattern.scale;
         if(param2.type == Effect.NOT_PERSISTANT)
         {
            addEvent("cycle",disposeView);
         }
      }
   }
}

