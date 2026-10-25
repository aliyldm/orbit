package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class StockpileEffect3D extends StandaloneParticle3D
   {
      
      private static const URL:String = "ability_stockpile.zip";
      
      public function StockpileEffect3D(param1:MapView3D, param2:MapObjectEffect)
      {
         super(param2,URL,param2.source.position);
         fixedScale = 1.5;
      }
   }
}

