package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import com.greensock.TweenLite;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.ChasingShotEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class ChasingShotEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "chasing_shot.zip";
      
      private var _attacker:MapEntity;
      
      private var _target:MapEntity;
      
      private var _shotPosition:BindablePointLite;
      
      public function ChasingShotEffect3D(param1:MapView3D, param2:ChasingShotEffect)
      {
         this._attacker = param2.attacker;
         this._target = param2.target;
         if(this._attacker)
         {
            this._shotPosition = new BindablePointLite(this._attacker.position.x,this._attacker.position.y,this._attacker.position.z);
         }
         else
         {
            this._shotPosition = new BindablePointLite(0,0,0);
         }
         super(param2,PARTICLES_FILE,this._shotPosition);
         if(this._attacker == null || this._target == null)
         {
            this.disposeView();
         }
      }
      
      override protected function initAndPlay() : void
      {
         super.initAndPlay();
         TweenLite.to(this._shotPosition,1,{
            "dynamicProps":{
               "x":this.getTargetXPos,
               "y":this.getTargetYPos
            },
            "onComplete":this.disposeView
         });
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_PIRATE_CHASING_SHOT,false,false,this._attacker.position.x,this._attacker.position.y,true);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         TweenLite.killTweensOf(view);
         super.disposeView(param1);
      }
      
      private function getTargetXPos() : Number
      {
         return this._target.position.x;
      }
      
      private function getTargetYPos() : Number
      {
         return this._target.position.y;
      }
   }
}

