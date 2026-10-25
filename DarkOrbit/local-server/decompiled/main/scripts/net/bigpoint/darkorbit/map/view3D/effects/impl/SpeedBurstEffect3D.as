package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpeedBurstEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class SpeedBurstEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "tech_speed-burst.zip";
      
      public function SpeedBurstEffect3D(param1:MapView3D, param2:SpeedBurstEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
      }
      
      override public function updateObj(param1:Number) : void
      {
         view.rotateTo(0,this.map.hero.moveTrait.rotation.degrees + 180,0);
         super.updateObj(param1);
      }
      
      private function get map() : Map
      {
         return ScreenManager.getInstance().map;
      }
   }
}

