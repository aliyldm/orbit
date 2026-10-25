package net.bigpoint.darkorbit.map.model.traits
{
   import com.bigpoint.utils.bindables.BindableInt;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class HPTrait extends EntityTraitBase
   {
      
      public const hp:BindableInt = new BindableInt(0);
      
      public const maxHP:BindableInt = new BindableInt(0);
      
      public const nanohullHP:BindableInt = new BindableInt(0);
      
      public const nanohullMaxHP:BindableInt = new BindableInt(0);
      
      public const shield:BindableInt = new BindableInt(0);
      
      public const maxShield:BindableInt = new BindableInt(0);
      
      private var _changed:ISignal;
      
      public var hpBarWidth:int = 0;
      
      public function HPTrait()
      {
         super();
      }
      
      public function get changed() : ISignal
      {
         if(this._changed == null)
         {
            this._changed = new Signal();
            this.hp.changed.add(this._changed.dispatch);
            this.maxHP.changed.add(this._changed.dispatch);
            this.nanohullHP.changed.add(this._changed.dispatch);
            this.nanohullMaxHP.changed.add(this._changed.dispatch);
            this.shield.changed.add(this._changed.dispatch);
            this.maxShield.changed.add(this._changed.dispatch);
         }
         return this._changed;
      }
   }
}

