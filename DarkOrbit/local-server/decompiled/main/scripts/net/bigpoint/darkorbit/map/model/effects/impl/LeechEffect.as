package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class LeechEffect extends Effect
   {
      
      private var _source:MapEntity;
      
      private var _target:MapEntity;
      
      public function LeechEffect(param1:MapEntity, param2:MapEntity)
      {
         this._source = param1;
         this._target = param2;
         super(EffectIDList.LEECH_EFFECT,NOT_PERSISTANT);
      }
      
      public function get source() : MapEntity
      {
         return this._source;
      }
      
      public function get target() : MapEntity
      {
         return this._target;
      }
   }
}

