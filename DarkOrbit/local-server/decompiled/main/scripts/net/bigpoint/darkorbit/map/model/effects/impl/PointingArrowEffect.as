package net.bigpoint.darkorbit.map.model.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class PointingArrowEffect extends Effect
   {
      
      private var _sourcePosition:PointLite;
      
      private var _targetPosition:PointLite;
      
      public function PointingArrowEffect(param1:PointLite, param2:PointLite)
      {
         this._targetPosition = param2;
         this._sourcePosition = param1;
         super(EffectIDList.POINTING_ARROW,PERSISTANT,null);
      }
      
      public function get sourcePosition() : PointLite
      {
         return this._sourcePosition;
      }
      
      public function get targetPosition() : PointLite
      {
         return this._targetPosition;
      }
      
      override public function reactivate(param1:Effect) : void
      {
         var _loc2_:PointingArrowEffect = param1 as PointingArrowEffect;
         this._targetPosition = _loc2_.targetPosition;
         this._sourcePosition = _loc2_.sourcePosition;
      }
   }
}

