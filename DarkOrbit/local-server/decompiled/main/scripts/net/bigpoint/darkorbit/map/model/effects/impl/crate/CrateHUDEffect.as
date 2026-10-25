package net.bigpoint.darkorbit.map.model.effects.impl.crate
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.hud.TimerIconTrait;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class CrateHUDEffect extends MapObjectEffect
   {
      
      private var _icon:TimerIconTrait;
      
      private var _durationSeconds:int;
      
      public function CrateHUDEffect(param1:int, param2:MapEntity, param3:int, param4:int = 1, param5:EffectPattern = null, param6:int = -1)
      {
         super(param1,param2,param4,param5,param6);
         this._durationSeconds = param3;
         this._icon = new TimerIconTrait(this._durationSeconds,this.getIconId(param1));
      }
      
      override public function activate() : Boolean
      {
         Ship(source).addTrait(this._icon);
         this.updateTimerTrait(this._durationSeconds);
         return super.activate();
      }
      
      override public function deactivate() : void
      {
         if(this._icon)
         {
            source.removeTrait(this._icon);
            this._icon = null;
         }
         super.deactivate();
      }
      
      override public function reactivate(param1:Effect) : void
      {
         this.updateTimerTrait((param1 as CrateHUDEffect)._durationSeconds);
         super.reactivate(param1);
      }
      
      private function updateTimerTrait(param1:int) : void
      {
         var _loc3_:TimerIconTrait = null;
         var _loc4_:TimerIconTrait = null;
         var _loc2_:Vector.<TimerIconTrait> = Vector.<TimerIconTrait>(source.getTraits(TimerIconTrait));
         if(_loc2_ == null || _loc2_.length == 0)
         {
            _loc3_ = source.addTrait(this._icon) as TimerIconTrait;
         }
         else
         {
            for each(_loc4_ in _loc2_)
            {
               if(_loc4_.iconId == this._icon.iconId)
               {
                  _loc3_ = _loc4_;
                  break;
               }
            }
         }
         if(_loc3_)
         {
            _loc3_.seconds.value = param1;
         }
      }
      
      private function getIconId(param1:int) : *
      {
         switch(param1)
         {
            case EffectIDList.FLUX_CRATE_HUD_EFFECT:
               return "fluxCrate";
            case EffectIDList.MIRE_CRATE_HUD_EFFECT:
               return "mireCrate";
            case EffectIDList.HEIGHTENED_VALOUR_HUD_EFFECT:
               return "heightenedValour";
            case EffectIDList.HEIGHTENED_VALOUR_PVP_HUD_EFFECT:
               return "heightenedValourPVP";
            default:
               return "";
         }
      }
   }
}

