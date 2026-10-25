package net.bigpoint.darkorbit.map.view3D.effects.impl.retiarus
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectPersistantEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   
   public class BuffEffect3D extends StandaloneParticle3D
   {
      
      private var _target:MapEntity;
      
      private var _effect:MapObjectPersistantEffect;
      
      public function BuffEffect3D(param1:MapView3D, param2:MapObjectPersistantEffect)
      {
         this._target = param2.source;
         this._effect = param2;
         super(param2,param2.pattern.resKey + ".zip",param2.source.position,param2.source);
      }
      
      override public function updateObj(param1:Number) : void
      {
         view.rotateTo(0,(this._target as Ship).moveTrait.rotation.degrees + 90,0);
         super.updateObj(param1);
      }
      
      override protected function updateScale() : void
      {
         var _loc1_:UberDisplayTrait = null;
         if(this._target)
         {
            _loc1_ = this._target.getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
            if(_loc1_)
            {
               scale = _loc1_.visualSize3D * this._effect.pattern.scale;
            }
         }
      }
   }
}

