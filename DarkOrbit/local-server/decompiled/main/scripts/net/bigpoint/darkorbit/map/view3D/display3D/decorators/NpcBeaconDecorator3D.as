package net.bigpoint.darkorbit.map.view3D.display3D.decorators
{
   import away3d.animators.states.ParticleInitialColorState;
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   
   public class NpcBeaconDecorator3D implements IMapUberAssetDecorator3D
   {
      
      private var _hp:HPTrait;
      
      private var _viewOwner:UberAsset3D;
      
      private var _bulbState:ParticleInitialColorState;
      
      public function NpcBeaconDecorator3D()
      {
         super();
      }
      
      public function initialize(param1:UberDisplayTrait, param2:UberAsset3D, param3:Object) : void
      {
         this._hp = param1.owner.getFirstTrait(HPTrait) as HPTrait;
         this._viewOwner = param2;
      }
      
      public function decorate() : void
      {
         this._hp.changed.add(this.update);
      }
      
      private function update() : void
      {
         this._viewOwner.playAnimation("open");
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

