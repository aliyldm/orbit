package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import away3d.containers.ObjectContainer3D;
   import com.greensock.TweenLite;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.impl.PhaseOutEffect;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class PhaseOutEffect3D implements IDisposable
   {
      
      private static const PARTICLES_FILE:String = "phase_out_skill_short.zip";
      
      private var _ship:ObjectContainer3D;
      
      private var _effect:PhaseOutEffect;
      
      public function PhaseOutEffect3D(param1:MapView3D, param2:PhaseOutEffect)
      {
         super();
         var _loc3_:StandaloneParticle3D = new StandaloneParticle3D(param2,PARTICLES_FILE,param2.source.position);
         _loc3_.fixedScale = 0.15;
         this._effect = param2;
         this._ship = param1.mainContainer.getViewByTrait(param2.source.getFirstTrait(UberDisplayTrait));
         this.fadeOutShip();
      }
      
      private function fadeOutShip() : void
      {
         TweenLite.to(this._ship,0.6,{
            "scaleX":0,
            "scaleY":0,
            "scaleZ":0
         });
      }
      
      private function fadeInShip() : void
      {
         TweenLite.to(this._ship,0.6,{
            "scaleX":1,
            "scaleY":1,
            "scaleZ":1
         });
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         var _loc2_:StandaloneParticle3D = new StandaloneParticle3D(this._effect,PARTICLES_FILE,this._effect.source.position);
         _loc2_.fixedScale = 0.15;
         this.fadeInShip();
      }
   }
}

