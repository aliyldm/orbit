package net.bigpoint.darkorbit.map.model.traits
{
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.effects.impl.GlowingRingEffect;
   
   public class PulsingRingTrait extends EntityTraitBase
   {
      
      private var _enabled:Boolean;
      
      private var _effect:GlowingRingEffect;
      
      public function PulsingRingTrait(param1:Boolean = false, param2:uint = 0, param3:uint = 0, param4:Boolean = false, param5:Number = 4, param6:uint = 80, param7:Number = 0)
      {
         super();
         this._enabled = param1;
         this._effect = new GlowingRingEffect(null);
         this._effect.endDiameter = param2;
         this._effect.ringColor = param3;
         this._effect.explosionLike = param4;
         this._effect.cycleTime = param5;
         this._effect.startDiameter = param6;
         this._effect.endAlpha = param7;
      }
      
      override public function activateTrait() : void
      {
         this._effect.position = owner.position;
         this._effect.source = owner;
         ScreenManager.getInstance().map.effects.addEffect(this._effect);
      }
      
      override public function deactivateTrait() : void
      {
         this.disable();
      }
      
      public function enable(param1:uint = 0, param2:uint = 0, param3:Boolean = false, param4:Number = 4) : void
      {
         this._effect.endDiameter = param1;
         this._effect.ringColor = param2;
         this._effect.explosionLike = param3;
         this._effect.cycleTime = param4;
         if(Boolean(owner) && this._enabled == false)
         {
            ScreenManager.getInstance().map.effects.addEffect(this._effect);
         }
         this._enabled = true;
      }
      
      public function disable() : void
      {
         ScreenManager.getInstance().map.effects.removeEffect(this._effect);
         this._enabled = false;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
   }
}

