package net.bigpoint.darkorbit.map.model.effects.impl.combat
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class AirstrikeEffect extends Effect
   {
      
      private var _attacker:MapEntity;
      
      private var _target:MapEntity;
      
      private var _rocketType:int;
      
      private var _maxRockets:int;
      
      private var _miss:Boolean;
      
      private var _smokeType:int;
      
      private var _showExplosion:Boolean;
      
      public function AirstrikeEffect(param1:MapEntity, param2:MapEntity, param3:int, param4:int = 20, param5:Boolean = false, param6:int = 0, param7:Boolean = true)
      {
         super(EffectIDList.AIRSTRIKE,NOT_PERSISTANT);
         this._attacker = param1;
         this._target = param2;
         this._rocketType = param3;
         this._maxRockets = param4;
         this._miss = param5;
         this._smokeType = param6;
         this._showExplosion = param7;
      }
      
      public function get attacker() : MapEntity
      {
         return this._attacker;
      }
      
      public function get target() : MapEntity
      {
         return this._target;
      }
      
      public function get rocketType() : int
      {
         return this._rocketType;
      }
      
      public function get maxRockets() : int
      {
         return this._maxRockets;
      }
      
      public function get miss() : Boolean
      {
         return this._miss;
      }
      
      public function get smokeType() : int
      {
         return this._smokeType;
      }
      
      override public function isValid() : Boolean
      {
         return Boolean(super.isValid()) && this._attacker != null && this._target != null;
      }
      
      public function get showExplosion() : Boolean
      {
         return this._showExplosion;
      }
   }
}

