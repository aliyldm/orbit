package net.bigpoint.darkorbit.map.model.traits
{
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.effects.impl.LocatorGearEffect;
   
   public class LocatorGearTrait extends EntityTraitBase
   {
      
      private var _effect:LocatorGearEffect;
      
      public function LocatorGearTrait(param1:LocatorGearEffect)
      {
         this._effect = param1;
         super();
      }
      
      public function get effect() : LocatorGearEffect
      {
         return this._effect;
      }
   }
}

