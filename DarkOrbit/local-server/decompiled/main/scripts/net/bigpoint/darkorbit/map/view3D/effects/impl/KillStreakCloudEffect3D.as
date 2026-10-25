package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.KillStreakCloudEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class KillStreakCloudEffect3D extends StandaloneParticle3D
   {
      
      private var fileName:String = "killstreak_cloud.zip";
      
      private var _effect:KillStreakCloudEffect;
      
      public function KillStreakCloudEffect3D(param1:MapView3D, param2:KillStreakCloudEffect)
      {
         this._effect = param2;
         this.getFileName();
         super(param2,this.fileName,param2.source.position,param2.source);
         offset3D.setTo(0,-30,0);
      }
      
      override public function updateObj(param1:Number) : void
      {
         super.updateObj(param1);
         view.scaleX = 2.2;
         view.scaleY = 0.5;
         view.scaleZ = 2.2;
      }
      
      private function getFileName() : void
      {
         switch(this._effect.id)
         {
            case EffectIDList.PROMETHEUS_KILL_STREAK_CLOUD_EFFECT:
               this.fileName = "prometheus_killstreak_cloud.zip";
               break;
            default:
               this.fileName = "killstreak_cloud.zip";
         }
      }
   }
}

