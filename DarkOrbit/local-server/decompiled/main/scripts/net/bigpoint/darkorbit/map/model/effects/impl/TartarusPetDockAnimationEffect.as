package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class TartarusPetDockAnimationEffect extends MapObjectEffect
   {
      
      public var petDesignId:String = "";
      
      private var _ship:Ship;
      
      public var onDesignSetAdded:ISignal = new Signal();
      
      public function TartarusPetDockAnimationEffect(param1:MapEntity, param2:String)
      {
         this.petDesignId = param2;
         super(EffectIDList.TARTARUS_PET_DOCK_EFFECT,param1,PERSISTANT);
         this._ship = param1 as Ship;
         this._ship.hasDesignSet.changed.add(this.onDesignSetChanged);
      }
      
      private function onDesignSetChanged() : void
      {
         if(!this._ship.hasDesignSet.value)
         {
            ScreenManager.getInstance().map.effects.removeEffect(this);
         }
         else
         {
            this.onDesignSetAdded.dispatch();
         }
      }
   }
}

