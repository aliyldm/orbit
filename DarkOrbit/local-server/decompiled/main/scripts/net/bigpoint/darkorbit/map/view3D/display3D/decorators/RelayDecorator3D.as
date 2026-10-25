package net.bigpoint.darkorbit.map.view3D.display3D.decorators
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.nodes.ParticleInitialColorNode;
   import away3d.animators.states.ParticleInitialColorState;
   import away3d.entities.Mesh;
   import com.greensock.TweenLite;
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberParticles3D;
   
   public class RelayDecorator3D implements IMapUberAssetDecorator3D
   {
      
      private var _hp:HPTrait;
      
      private var _viewOwner:UberAsset3D;
      
      private var _bulbState:ParticleInitialColorState;
      
      public function RelayDecorator3D()
      {
         super();
      }
      
      public function initialize(param1:UberDisplayTrait, param2:UberAsset3D, param3:Object) : void
      {
         this._hp = param1.owner.getFirstTrait(HPTrait) as HPTrait;
         this._hp.changed.add(this.update);
         this._viewOwner = param2;
      }
      
      public function decorate() : void
      {
         var _loc2_:Mesh = null;
         var _loc3_:ParticleAnimator = null;
         var _loc4_:ParticleInitialColorNode = null;
         var _loc1_:UberParticles3D = this._viewOwner.getViewElement("bulb") as UberParticles3D;
         if(_loc1_)
         {
            for each(_loc2_ in _loc1_.particles.particleMeshes)
            {
               if(_loc2_.name == "glow")
               {
                  _loc3_ = ParticleAnimator(_loc2_.animator);
                  _loc4_ = _loc3_.animationSet.getAnimation("ParticleInitialColorGlobal") as ParticleInitialColorNode;
                  this._bulbState = _loc3_.getAnimationState(_loc4_) as ParticleInitialColorState;
                  this.update();
                  break;
               }
            }
         }
      }
      
      private function update() : void
      {
         TweenLite.to(this,0.25,{"alpha":this._hp.hp.value / this._hp.maxHP.value});
      }
      
      public function get alpha() : Number
      {
         if(this._bulbState)
         {
            return this._bulbState.initialColor.alphaMultiplier || 0;
         }
         return 0;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(this._bulbState)
         {
            this._bulbState.initialColor.alphaMultiplier = param1 || 0;
            this._bulbState.initialColor = this._bulbState.initialColor;
         }
      }
   }
}

