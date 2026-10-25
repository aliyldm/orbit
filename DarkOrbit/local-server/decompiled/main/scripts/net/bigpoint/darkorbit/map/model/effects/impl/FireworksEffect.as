package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class FireworksEffect extends Effect
   {
      
      private var _x:int;
      
      private var _y:int;
      
      private var _patterns:Vector.<String>;
      
      public function FireworksEffect(param1:int, param2:int, param3:Vector.<String>)
      {
         super(EffectIDList.FIREWORKS,NOT_PERSISTANT,null);
         this._x = param1;
         this._y = param2;
         this._patterns = param3;
      }
      
      public function get x() : int
      {
         return this._x;
      }
      
      public function get y() : int
      {
         return this._y;
      }
      
      public function get patterns() : Vector.<String>
      {
         return this._patterns;
      }
   }
}

