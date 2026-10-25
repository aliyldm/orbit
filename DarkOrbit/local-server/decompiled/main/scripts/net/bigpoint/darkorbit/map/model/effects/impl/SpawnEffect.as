package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class SpawnEffect extends Effect
   {
      
      private var _playSound:Boolean = true;
      
      private var _x:int;
      
      private var _y:int;
      
      public function SpawnEffect(param1:int, param2:int, param3:Boolean = true)
      {
         super(EffectIDList.SPAWN,NOT_PERSISTANT);
         this._x = param1;
         this._y = param2;
         this._playSound = param3;
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
   }
}

