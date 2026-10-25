package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class TartarusSpeedBoostEffect extends MapObjectEffect
   {
      
      public var designChanged:ISignal = new Signal();
      
      private var _hasSet:Boolean = false;
      
      private var _ship:Ship;
      
      public function TartarusSpeedBoostEffect(param1:Ship, param2:Boolean = false)
      {
         super(EffectIDList.TARTARUS_SPEEDBUFF_EFFECT,param1,PERSISTANT,new EffectPattern(EffectIDList.TARTARUS_SPEEDBUFF_EFFECT,"speed-buff-effect"));
         this._ship = source as Ship;
         this._hasSet = param2;
      }
      
      override public function reactivate(param1:Effect) : void
      {
         var _loc2_:TartarusSpeedBoostEffect = param1 as TartarusSpeedBoostEffect;
         if(_loc2_.hasSet != this._hasSet)
         {
            this._hasSet = _loc2_.hasSet;
            this.designChanged.dispatch();
         }
      }
      
      public function get hasSet() : Boolean
      {
         return this._hasSet;
      }
   }
}

