package net.bigpoint.darkorbit.map.model.core
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class EntityTraitContainer
   {
      
      public const traitAdded:ISignal = new Signal();
      
      public const traitRemoved:ISignal = new Signal();
      
      private var _traits:Vector.<EntityTraitBase> = new Vector.<EntityTraitBase>();
      
      public function EntityTraitContainer()
      {
         super();
      }
      
      public function get traits() : Vector.<EntityTraitBase>
      {
         return this._traits;
      }
      
      public function addTrait(param1:EntityTraitBase) : EntityTraitBase
      {
         var _loc2_:int = this._traits.indexOf(param1);
         if(_loc2_ == -1)
         {
            this._traits.push(param1);
            this.traitAdded.dispatch(param1);
         }
         return param1;
      }
      
      public function removeTrait(param1:EntityTraitBase) : EntityTraitBase
      {
         var _loc2_:int = this._traits.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._traits.splice(_loc2_,1);
            this.traitRemoved.dispatch(param1);
         }
         return param1;
      }
      
      public function removeAllTraits() : void
      {
         while(this._traits.length > 0)
         {
            this.removeTrait(this._traits[0]);
         }
      }
   }
}

