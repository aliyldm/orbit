package net.bigpoint.darkorbit.map.model.effects.impl
{
   import flash.display.Bitmap;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.LocatorGearTrait;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class LocatorGearEffect extends MapObjectEffect
   {
      
      public const update:ISignal = new Signal();
      
      private var _locatorTrait:LocatorGearTrait;
      
      private var _icon:Bitmap;
      
      public function LocatorGearEffect(param1:MapEntity, param2:Bitmap)
      {
         this._icon = param2;
         super(EffectIDList.LOCATOR,param1,PERSISTANT);
      }
      
      public function get icon() : Bitmap
      {
         return this._icon;
      }
      
      override public function activate() : Boolean
      {
         this._locatorTrait = Ship(source).addTrait(new LocatorGearTrait(this)) as LocatorGearTrait;
         return super.activate();
      }
      
      override public function deactivate() : void
      {
         if(this._locatorTrait)
         {
            Ship(source).removeTrait(this._locatorTrait);
            this._locatorTrait = null;
         }
         super.deactivate();
      }
      
      public function updateEffect(param1:int, param2:int) : void
      {
         this.update.dispatch(param1,param2);
      }
   }
}

