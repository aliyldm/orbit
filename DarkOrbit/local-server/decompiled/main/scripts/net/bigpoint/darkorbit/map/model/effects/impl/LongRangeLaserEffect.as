package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class LongRangeLaserEffect extends Effect
   {
      
      private var _source:MapEntity;
      
      private var _target:MapEntity;
      
      public function LongRangeLaserEffect(param1:MapEntity, param2:MapEntity)
      {
         super(EffectIDList.LONG_RANGE_LASER,0);
         this._source = param1;
         this._target = param2;
      }
      
      public function get source() : MapEntity
      {
         return this._source;
      }
      
      public function get target() : MapEntity
      {
         return this._target;
      }
      
      public function playSound() : void
      {
         AudioManager.playSoundEffect(135,false,false,this.target.x,this.target.y,true);
      }
   }
}

