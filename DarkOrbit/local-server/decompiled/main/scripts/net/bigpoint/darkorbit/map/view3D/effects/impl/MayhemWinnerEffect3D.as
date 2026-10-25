package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.MayhemWinnerEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class MayhemWinnerEffect3D extends StandaloneParticle3D
   {
      
      private const PARTICLES_FILE:String = "spacecup_winner_effect.zip";
      
      public function MayhemWinnerEffect3D(param1:MapView3D, param2:MayhemWinnerEffect)
      {
         super(param2,this.PARTICLES_FILE,param2.source.position,param2.source);
         fixedScale = 0.5;
         offset3D.setTo(0,100,0);
      }
   }
}

