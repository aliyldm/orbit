package net.bigpoint.darkorbit.map.model.effects.impl.combat
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.GlowingRingEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   import net.bigpoint.darkorbit.pattern.ExplosionPattern;
   
   public class PyroEffect extends Effect
   {
      
      private static const STREUNER_ROCKET_SERVER_EXPLOSION_RANGE:Number = 400;
      
      private var _target:MapEntity;
      
      private var _z:int;
      
      private var _ignoreSettings:Boolean;
      
      private var _x:int;
      
      private var _y:int;
      
      private var _pyroPattern:ExplosionPattern;
      
      public function PyroEffect(param1:int, param2:int, param3:int, param4:ExplosionPattern, param5:MapEntity = null, param6:Boolean = false)
      {
         super(EffectIDList.PYRO,NOT_PERSISTANT,param4 ? new EffectPattern(EffectIDList.PYRO,param4.resKey,50) : null);
         this._x = param1;
         this._y = param2;
         this._z = param3;
         this._ignoreSettings = param6;
         this._pyroPattern = param4;
         this._target = param5;
      }
      
      public function playGlowingRingEffect() : void
      {
         var _loc1_:GlowingRingEffect = new GlowingRingEffect(new PointLite(this.x,this.y),0,STREUNER_ROCKET_SERVER_EXPLOSION_RANGE,9317929,false,1,false,false,0.5);
         ScreenManager.getInstance().map.effects.addEffectOnce(_loc1_);
      }
      
      public function get x() : int
      {
         return this._x;
      }
      
      public function get y() : int
      {
         return this._y;
      }
      
      public function get pyroPattern() : ExplosionPattern
      {
         return this._pyroPattern;
      }
      
      public function set pyroPattern(param1:ExplosionPattern) : void
      {
         this._pyroPattern = param1;
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return true;
      }
      
      public function get target() : MapEntity
      {
         return this._target;
      }
      
      public function get z() : int
      {
         return this._z;
      }
      
      public function get ignoreSettings() : Boolean
      {
         return this._ignoreSettings;
      }
   }
}

