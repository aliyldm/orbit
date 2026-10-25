package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.KillStreakTrailEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class KillStreakTrailEffect3D extends StandaloneParticle3D
   {
      
      private var fileName:String = "killstreak_trail.zip";
      
      private var _effect:KillStreakTrailEffect;
      
      public function KillStreakTrailEffect3D(param1:MapView3D, param2:KillStreakTrailEffect)
      {
         this._effect = param2;
         this.getFileName();
         super(param2,this.fileName,param2.source.position,param2.source);
         fixedScale = 0.5;
         offset3D.setTo(0,-30,30);
      }
      
      private function getFileName() : void
      {
         switch(this._effect.id)
         {
            case EffectIDList.PROMETHEUS_KILL_STREAK_TRAIL_EFFECT:
               this.fileName = "prometheus_killstreak_trail.zip";
               break;
            default:
               this.fileName = "killstreak_trail.zip";
         }
      }
   }
}

