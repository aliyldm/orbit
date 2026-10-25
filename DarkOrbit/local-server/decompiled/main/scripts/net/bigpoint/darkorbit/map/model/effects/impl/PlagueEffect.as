package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.traits.hud.TimerIconTrait;
   
   public class PlagueEffect extends MapObjectEffect
   {
      
      private var _durationSeconds:int;
      
      public function PlagueEffect(param1:MapEntity, param2:int)
      {
         super(EffectIDList.PLAGUE_EFFECT,param1,Effect.PERSISTANT);
         this._durationSeconds = param2;
      }
      
      override public function activate() : Boolean
      {
         var _loc1_:Boolean = super.activate();
         if(_loc1_ && source.id == Hero.userID)
         {
            InGameCatalog.getInstance().setQuestgiverPortraits("plague");
            this.updateTimerTrait(this._durationSeconds);
         }
         return _loc1_;
      }
      
      override public function deactivate() : void
      {
         if(source.id == Hero.userID)
         {
            InGameCatalog.getInstance().setQuestgiverPortraits();
            source.removeTraitByType(TimerIconTrait);
         }
         super.deactivate();
      }
      
      private function updateTimerTrait(param1:int) : void
      {
         var _loc2_:TimerIconTrait = source.getFirstTrait(TimerIconTrait) as TimerIconTrait || source.addTrait(new TimerIconTrait()) as TimerIconTrait;
         if(_loc2_)
         {
            _loc2_.seconds.value = param1;
         }
      }
      
      override public function reactivate(param1:Effect) : void
      {
         this.updateTimerTrait((param1 as PlagueEffect)._durationSeconds);
         super.reactivate(param1);
      }
   }
}

