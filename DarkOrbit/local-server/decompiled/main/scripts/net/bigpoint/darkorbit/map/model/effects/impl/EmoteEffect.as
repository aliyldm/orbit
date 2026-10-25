package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class EmoteEffect extends MapObjectEffect
   {
      
      private var _lootId:String;
      
      private var _duration:int;
      
      public function EmoteEffect(param1:MapEntity, param2:String, param3:int)
      {
         super(EffectIDList.EMOTE_EFFECT,param1,NOT_PERSISTANT);
         this._lootId = param2;
         this._duration = param3;
      }
      
      public function get lootId() : String
      {
         return this._lootId;
      }
      
      public function get duration() : int
      {
         return this._duration;
      }
   }
}

