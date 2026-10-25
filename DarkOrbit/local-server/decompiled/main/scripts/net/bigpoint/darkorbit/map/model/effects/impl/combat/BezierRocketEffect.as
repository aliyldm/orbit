package net.bigpoint.darkorbit.map.model.effects.impl.combat
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   
   public class BezierRocketEffect extends Effect
   {
      
      private var _attacker:MapEntity;
      
      private var _showPyro:Boolean;
      
      private var _index:int;
      
      private var _scale:int;
      
      private var _shakeScreen:Boolean;
      
      private var _delay:Number;
      
      private var _typeID:int;
      
      private var _target:MapEntity;
      
      private var _hit:Boolean;
      
      private var _rocketSmokeID:int = 0;
      
      private var _isHeatSeeking:Boolean = false;
      
      public function BezierRocketEffect(param1:MapEntity, param2:MapEntity, param3:int, param4:Boolean, param5:int = 0, param6:Number = 0, param7:Boolean = false, param8:int = 0, param9:int = 1, param10:Boolean = false)
      {
         super(EffectIDList.BEZIER_ROCKET_EFFECT,NOT_PERSISTANT);
         this._attacker = param1;
         this._target = param2;
         this._typeID = param3;
         this._hit = param4;
         this._rocketSmokeID = param5;
         this._isHeatSeeking = false;
         this._delay = param6;
         this._showPyro = param7;
         this._index = param8;
         this._scale = param9;
         this._shakeScreen = param10;
      }
      
      public function get attacker() : MapEntity
      {
         return this._attacker;
      }
      
      public function get target() : MapEntity
      {
         return this._target;
      }
      
      public function get typeID() : int
      {
         return this._typeID;
      }
      
      public function get hit() : Boolean
      {
         return this._hit;
      }
      
      public function get rocketSmokeID() : int
      {
         return this._rocketSmokeID;
      }
      
      public function get isHeatSeeking() : Boolean
      {
         return this._isHeatSeeking;
      }
      
      public function get delay() : *
      {
         return this._delay;
      }
      
      public function get showPyro() : Boolean
      {
         return this._showPyro;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function get scale() : int
      {
         return this._scale;
      }
      
      public function get shakeScreen() : Boolean
      {
         return this._shakeScreen;
      }
      
      override public function isValid() : Boolean
      {
         return Boolean(super.isValid()) && this._attacker != null && this._target != null;
      }
      
      override public function activate() : Boolean
      {
         (this._attacker.getFirstTrait(AttackerTrait) as AttackerTrait).rocketLauncher.fire.dispatch();
         return super.activate();
      }
   }
}

