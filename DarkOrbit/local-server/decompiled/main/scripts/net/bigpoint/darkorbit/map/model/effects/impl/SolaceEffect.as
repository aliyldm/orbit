package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class SolaceEffect extends MapObjectEffect
   {
      
      private var _sourceId:int;
      
      public function SolaceEffect(param1:MapEntity, param2:int = 1, param3:EffectPattern = null, param4:int = -1)
      {
         super(EffectIDList.SOLACE_EFFECT,param1,param2,param3,param4);
         if(param1)
         {
            this._sourceId = param1.id;
         }
         if(param2 == TIME_OUT)
         {
            this.timeOutTime = 1500;
         }
      }
      
      public function get sourceId() : int
      {
         return this._sourceId;
      }
   }
}

