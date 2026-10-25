package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class SpeedBuffEffect extends MapObjectEffect
   {
      
      private var _shake:Boolean;
      
      public function SpeedBuffEffect(param1:Ship, param2:Boolean)
      {
         this._shake = param2;
         super(EffectIDList.SPEED_BUFF_EFFECT,param1,PERSISTANT,new EffectPattern(EffectIDList.SPEED_BUFF_EFFECT,"speed-buff-effect"));
      }
      
      public function get shake() : Boolean
      {
         return this._shake;
      }
   }
}

