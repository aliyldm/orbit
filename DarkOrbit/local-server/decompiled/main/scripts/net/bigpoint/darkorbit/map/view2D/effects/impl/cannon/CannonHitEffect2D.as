package net.bigpoint.darkorbit.map.view2D.effects.impl.cannon
{
   import net.bigpoint.darkorbit.com.module.porting.cannon.CannonType;
   import net.bigpoint.darkorbit.map.model.effects.impl.cannon.CannonHitEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.StandaloneEffect2D;
   
   public class CannonHitEffect2D extends StandaloneEffect2D
   {
      
      public function CannonHitEffect2D(param1:MapView2D, param2:CannonHitEffect)
      {
         var _loc3_:String = "cannon_hit_electro";
         switch(param2.cannonType)
         {
            case CannonType.CORROSIVE:
               _loc3_ = "cannon_hit_corrosive";
               break;
            case CannonType.THERMAL:
               _loc3_ = "cannon_hit_thermal";
               break;
            case CannonType.ELECTRO:
               _loc3_ = "cannon_hit_electro";
         }
         super(param1,param2,_loc3_,param2.source.position);
      }
   }
}

