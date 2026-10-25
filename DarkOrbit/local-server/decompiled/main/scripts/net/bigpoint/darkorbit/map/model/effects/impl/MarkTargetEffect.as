package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class MarkTargetEffect extends MapObjectEffect
   {
      
      public static const IN_RANGE:String = "inRange";
      
      public static const OUT_OF_RANGE:String = "outOfRange";
      
      private var _targetState:String;
      
      public function MarkTargetEffect(param1:MapEntity, param2:String)
      {
         this._targetState = param2;
         super(EffectIDList.MARK_TARGET_EFFECT,param1);
      }
      
      public function get targetState() : String
      {
         return this._targetState;
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return true;
      }
   }
}

