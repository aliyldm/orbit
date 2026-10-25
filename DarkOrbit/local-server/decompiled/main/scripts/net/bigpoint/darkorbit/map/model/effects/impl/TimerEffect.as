package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.traits.hud.TimerIconTrait;
   
   public class TimerEffect extends MapObjectEffect
   {
      
      private var _iconTrait:EntityTraitBase;
      
      private var _offset:int;
      
      public function TimerEffect(param1:MapEntity, param2:int, param3:int = 0)
      {
         super(EffectIDList.TIMER_EFFECT,param1,TIME_OUT);
         timeOutTime = param2 * 1000;
         this._offset = param3;
      }
      
      public function get offset() : int
      {
         return this._offset;
      }
      
      public function get time() : int
      {
         return timeOutTime * 0.001;
      }
      
      override public function activate() : Boolean
      {
         this._iconTrait = source.addTrait(new TimerIconTrait(this.time));
         return super.activate();
      }
      
      override public function deactivate() : void
      {
         if(this._iconTrait)
         {
            source.removeTrait(this._iconTrait);
            this._iconTrait = null;
         }
         super.deactivate();
      }
   }
}

