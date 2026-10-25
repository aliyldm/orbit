package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.KillStreakActivationEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class KillStreakActivationEffect3D extends StandaloneParticle3D
   {
      
      private var fileName:String = "killstreak.zip";
      
      private var _effect:KillStreakActivationEffect;
      
      public function KillStreakActivationEffect3D(param1:MapView3D, param2:KillStreakActivationEffect)
      {
         this._effect = param2;
         this.getFileName();
         super(param2,this.fileName,param2.source.position,param2.source);
      }
      
      override protected function initAndPlay() : void
      {
         super.initAndPlay();
         TweenMax.delayedCall(5,disposeView);
      }
      
      override public function updateObj(param1:Number) : void
      {
         super.updateObj(param1);
         view.rotationY = this.shipRotation + 90;
         view.scaleX = 1.5;
         view.scaleY = 1.5;
         view.scaleZ = 1.5;
      }
      
      private function get shipRotation() : Number
      {
         return (this._effect.source as Ship).rotation.degrees;
      }
      
      private function getFileName() : void
      {
         switch(this._effect.id)
         {
            case EffectIDList.PROMETHEUS_KILL_STREAK_ACTIVATION_EFFECT:
               this.fileName = "prometheus_killstreak.zip";
               break;
            default:
               this.fileName = "killstreak.zip";
         }
      }
   }
}

