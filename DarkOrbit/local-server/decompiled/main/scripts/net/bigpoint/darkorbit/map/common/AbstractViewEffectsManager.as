package net.bigpoint.darkorbit.map.common
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectManager;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   
   public class AbstractViewEffectsManager
   {
      
      private var _manager:EffectManager;
      
      protected var _effect2view:Dictionary = new Dictionary(true);
      
      public function AbstractViewEffectsManager()
      {
         super();
      }
      
      public function set map(param1:Map) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Effect = null;
         if(this._manager)
         {
            this._manager.effectAdded.remove(this.handleEffectAdded);
            this._manager.effectRemoved.remove(this.handleEffectRemoved);
            for(_loc2_ in this._effect2view)
            {
               this.handleEffectRemoved(_loc2_ as Effect);
            }
         }
         this._manager = param1 ? param1.effects : null;
         if(this._manager)
         {
            this._manager.effectAdded.add(this.handleEffectAdded);
            this._manager.effectRemoved.add(this.handleEffectRemoved);
            for each(_loc3_ in this._manager.effects)
            {
               this.handleEffectAdded(_loc3_);
            }
         }
      }
      
      public function getEffectView(param1:Effect) : AbstractEffect2D
      {
         return this._effect2view[param1] as AbstractEffect2D;
      }
      
      private function handleEffectAdded(param1:Effect) : void
      {
         if(this._effect2view[param1] != null)
         {
            this.handleEffectRemoved(param1);
         }
         var _loc2_:Object = this.buildEffect(param1);
         if(Boolean(_loc2_) && (param1.persistent || param1.timeout))
         {
            this._effect2view[param1] = _loc2_;
         }
      }
      
      protected function buildEffect(param1:Effect) : Object
      {
         throw new Error("buildEffect is an abstract function. Override it.");
      }
      
      protected function handleEffectRemoved(param1:Effect) : void
      {
         var _loc2_:Object = this._effect2view[param1];
         if(_loc2_ != null)
         {
            if(_loc2_ is IDisposable)
            {
               (_loc2_ as IDisposable).disposeView();
            }
            this._effect2view[param1] = null;
            delete this._effect2view[param1];
         }
      }
   }
}

