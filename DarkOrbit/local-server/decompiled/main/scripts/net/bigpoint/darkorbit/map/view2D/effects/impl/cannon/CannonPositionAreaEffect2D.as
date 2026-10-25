package net.bigpoint.darkorbit.map.view2D.effects.impl.cannon
{
   import net.bigpoint.darkorbit.map.model.effects.impl.cannon.CannonPositionAreaEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.PersistentEffect2D;
   
   public class CannonPositionAreaEffect2D extends PersistentEffect2D
   {
      
      public function CannonPositionAreaEffect2D(param1:MapView2D, param2:CannonPositionAreaEffect)
      {
         super(param1,param2,"cannon_position_area",param2.source.position);
      }
   }
}

