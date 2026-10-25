package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class DamageReceivedEffect extends MapObjectEffect
   {
      
      public var strike:Boolean = false;
      
      private var _hitpointDelta:int;
      
      private var _colorId:int;
      
      private var _useSign:Boolean;
      
      private var _replaceZeroWithMiss:Boolean;
      
      public function DamageReceivedEffect(param1:MapEntity, param2:int, param3:int = 0, param4:Boolean = false, param5:Boolean = true, param6:Boolean = false)
      {
         this._replaceZeroWithMiss = param5;
         this._useSign = param4;
         this._colorId = param3;
         this._hitpointDelta = param2;
         this.strike = param6;
         super(EffectIDList.DAMAGE_RECIEVED_EFFECT,param1,NOT_PERSISTANT);
      }
      
      public function get hitpointDelta() : int
      {
         return this._hitpointDelta;
      }
      
      public function get colorId() : int
      {
         return this._colorId;
      }
      
      public function get useSign() : Boolean
      {
         return this._useSign;
      }
      
      public function get replaceZeroWithMiss() : Boolean
      {
         return this._replaceZeroWithMiss;
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return true;
      }
   }
}

