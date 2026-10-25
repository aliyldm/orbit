package net.bigpoint.darkorbit.map.model.utils
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class LockManager
   {
      
      public const targetChanged:ISignal = new Signal(MapEntity);
      
      private var _target:MapEntity;
      
      public function LockManager()
      {
         super();
      }
      
      public function get target() : MapEntity
      {
         return this._target;
      }
      
      public function set target(param1:MapEntity) : void
      {
         if(this._target != param1)
         {
            if(this._target)
            {
               this._target.entityDeactivated.remove(this.handleTargetDisposed);
            }
            this._target = param1;
            if(this._target)
            {
               this._target.entityDeactivated.add(this.handleTargetDisposed);
            }
            this.targetChanged.dispatch(this._target);
         }
      }
      
      public function cleanup() : void
      {
         this.target = null;
      }
      
      private function handleTargetDisposed() : void
      {
         this.target = null;
      }
   }
}

