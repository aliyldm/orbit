package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class ShieldEffect extends MapObjectEffect
   {
      
      private var _minSkinShieldTwinkle:int = 0;
      
      private var _maxSkinShieldTwinkle:int = 0;
      
      private var _runScale:Number = 1;
      
      public function ShieldEffect(param1:MapEntity, param2:int, param3:int = 0, param4:int = 0, param5:EffectPattern = null, param6:Number = 1)
      {
         var _loc7_:* = param5 ? param5.id : EffectIDList.SHIELD_EFFECT;
         super(_loc7_,param1,param2,param5 ? param5 : new EffectPattern(EffectIDList.SHIELD_EFFECT,"shield0"));
         this._minSkinShieldTwinkle = param3;
         this._maxSkinShieldTwinkle = param3;
         this._runScale = param6;
      }
      
      public function get minSkinShieldTwinkle() : int
      {
         return this._minSkinShieldTwinkle;
      }
      
      public function get maxSkinShieldTwinkle() : int
      {
         return this._maxSkinShieldTwinkle;
      }
      
      public function get runScale() : Number
      {
         return this._runScale;
      }
      
      override public function reactivate(param1:Effect) : void
      {
         var _loc2_:ShieldEffect = param1 as ShieldEffect;
         this._minSkinShieldTwinkle = _loc2_.minSkinShieldTwinkle;
         this._maxSkinShieldTwinkle = _loc2_.maxSkinShieldTwinkle;
         this._runScale = _loc2_.runScale;
      }
   }
}

