package net.bigpoint.darkorbit.map.model.effects.impl.combat
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class SnipedLaserEffect extends MapObjectEffect
   {
      
      private var _target:MapEntity;
      
      private var _countDown:int;
      
      public function SnipedLaserEffect(param1:MapEntity, param2:MapEntity, param3:int = 10)
      {
         super(EffectIDList.SNIPED_LASER_EFFECT,param1,NOT_PERSISTANT);
         this._target = param2;
         this._countDown = param3;
         this.timeOutTime = param3;
      }
      
      public function get target() : MapEntity
      {
         return this._target;
      }
      
      public function playSound() : void
      {
      }
      
      public function get countDown() : int
      {
         return this._countDown;
      }
      
      public function set countDown(param1:int) : void
      {
         this._countDown = param1;
      }
   }
}

