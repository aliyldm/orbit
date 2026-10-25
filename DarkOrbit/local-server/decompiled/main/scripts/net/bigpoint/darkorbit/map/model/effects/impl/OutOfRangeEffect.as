package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class OutOfRangeEffect extends MapObjectEffect
   {
      
      private var _type:uint = 0;
      
      private var _target:MapEntity;
      
      private var _maxRange:int = 0;
      
      public function OutOfRangeEffect(param1:MapEntity, param2:MapEntity, param3:uint, param4:int)
      {
         super(EffectIDList.OUT_OF_RANGE_EFFECT,param1,NOT_PERSISTANT,null);
         this._target = param2;
         this._maxRange = param4;
         this._type = param3;
      }
      
      public function get target() : MapEntity
      {
         return this._target;
      }
      
      public function get maxRange() : int
      {
         return this._maxRange;
      }
      
      public function get rangeType() : uint
      {
         return this._type;
      }
      
      override public function isValid() : Boolean
      {
         return Boolean(super.isValid()) && this._target != null;
      }
   }
}

