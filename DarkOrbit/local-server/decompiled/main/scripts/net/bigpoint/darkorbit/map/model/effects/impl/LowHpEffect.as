package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class LowHpEffect extends MapObjectEffect
   {
      
      private var _addSignal:ISignal = new Signal(int);
      
      private var _scale:Number;
      
      public function LowHpEffect(param1:MapEntity, param2:Number = 1)
      {
         this._scale = param2;
         super(EffectIDList.LOW_HP_EFFECT,param1,PERSISTANT,null);
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      public function get addPositionSignal() : ISignal
      {
         return this._addSignal;
      }
      
      public function setDamageSpotAmount(param1:int) : void
      {
         this.addPositionSignal.dispatch(param1);
      }
   }
}

