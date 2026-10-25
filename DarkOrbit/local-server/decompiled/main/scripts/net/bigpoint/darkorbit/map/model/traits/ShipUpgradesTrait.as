package net.bigpoint.darkorbit.map.model.traits
{
   import com.bigpoint.utils.bindables.BindableVector;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ShipUpgradesTrait extends EntityTraitBase
   {
      
      public var _shipUpgrades:BindableVector = new BindableVector();
      
      private var _changed:ISignal;
      
      public function ShipUpgradesTrait()
      {
         super();
      }
      
      public function get changed() : ISignal
      {
         if(this._changed == null)
         {
            this._changed = new Signal();
            this._shipUpgrades.changed.add(this._changed.dispatch);
         }
         return this._changed;
      }
   }
}

