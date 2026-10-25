package net.bigpoint.darkorbit.map.model.effects.impl.combat
{
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class ShockwaveEffect extends Effect
   {
      
      private var _shockwaveId:int;
      
      private var _x:int;
      
      private var _y:int;
      
      private var _playSound:Boolean;
      
      private var _radius:int;
      
      public function ShockwaveEffect(param1:int, param2:int, param3:int, param4:Boolean, param5:int = 300)
      {
         super(EffectIDList.SHOCKWAVE,NOT_PERSISTANT);
         this._shockwaveId = param1;
         this._x = param2;
         this._y = param3;
         this._playSound = param4;
         this._radius = param5;
      }
      
      public function get shockwaveId() : int
      {
         return this._shockwaveId;
      }
      
      public function get x() : int
      {
         return this._x;
      }
      
      public function get y() : int
      {
         return this._y;
      }
      
      public function get playSound() : Boolean
      {
         return this._playSound;
      }
      
      public function get radius() : int
      {
         return this._radius;
      }
   }
}

