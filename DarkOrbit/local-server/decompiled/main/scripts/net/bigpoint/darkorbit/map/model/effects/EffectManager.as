package net.bigpoint.darkorbit.map.model.effects
{
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.model.effects.impl.SolaceEffect;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class EffectManager
   {
      
      private var _effectGroupsData:Object = {};
      
      private var _effectsCache:Vector.<Effect> = new Vector.<Effect>();
      
      private var _effects:Vector.<Effect> = new Vector.<Effect>();
      
      public const effectAdded:ISignal = new Signal(Effect);
      
      public const effectRemoved:ISignal = new Signal(Effect);
      
      public function EffectManager()
      {
         super();
      }
      
      public function get effects() : Vector.<Effect>
      {
         return this._effects.concat();
      }
      
      public function playEffect(param1:Effect) : Effect
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         if(!param1.isValid())
         {
            return param1;
         }
         if(param1.excludeGroup != 0)
         {
            _loc2_ = this._effectGroupsData[param1.excludeGroup] = this._effectGroupsData[param1.excludeGroup] || {};
            _loc3_ = getTimer();
            if(_loc3_ < int(_loc2_.nextAllowedTimer))
            {
               setTimeout(this.internalPlay,int(_loc2_.nextAllowedTimer) - _loc3_,param1);
               _loc2_.nextAllowedTimer = int(_loc2_.nextAllowedTimer) + 1500;
               return param1;
            }
            _loc2_.nextAllowedTimer = _loc3_ + 1500;
         }
         this.internalPlay(param1);
         return param1;
      }
      
      public function addEffect(param1:Effect) : Effect
      {
         if(!param1.isValid())
         {
            return param1;
         }
         if(param1.persistent || param1.timeout)
         {
            this._effects.push(param1);
         }
         return this.playEffect(param1);
      }
      
      public function addEffectOnce(param1:Effect) : void
      {
         if(!param1.isValid())
         {
            return;
         }
         if(param1 is SolaceEffect)
         {
            if(this.getEffectByIdAndEntityId(param1.id,(param1 as SolaceEffect).sourceId) == null)
            {
               this.addEffect(param1);
            }
            else
            {
               this.getEffectByIdAndEntityId(param1.id,(param1 as SolaceEffect).sourceId).reactivate(param1);
            }
            return;
         }
         if(this.getEffectById(param1.id) == null)
         {
            this.addEffect(param1);
         }
         else
         {
            this.getEffectById(param1.id).reactivate(param1);
         }
      }
      
      public function addMapObjectEffectOnce(param1:MapObjectEffect) : void
      {
         if(!param1.isValid())
         {
            return;
         }
         if(this.getEffectForMapObject(param1.source.id,param1.id) == null)
         {
            this.addEffect(param1);
         }
         else
         {
            this.getEffectForMapObject(param1.source.id,param1.id).reactivate(param1);
         }
      }
      
      public function removeEffect(param1:Effect) : Effect
      {
         if(param1)
         {
            this.internalRemove(param1);
            this.effectRemoved.dispatch(param1);
            param1.deactivate();
         }
         return param1;
      }
      
      private function internalRemove(param1:Effect) : void
      {
         var _loc2_:int = this._effects.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._effects.splice(_loc2_,1);
         }
         _loc2_ = this._effectsCache.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._effectsCache.splice(_loc2_,1);
         }
      }
      
      public function getEffectForMapObject(param1:int, param2:int) : MapObjectEffect
      {
         var _loc3_:Effect = null;
         for each(_loc3_ in this._effects)
         {
            if(_loc3_.id == param2 && _loc3_ is MapObjectEffect && MapObjectEffect(_loc3_).source.id == param1)
            {
               return _loc3_ as MapObjectEffect;
            }
         }
         return null;
      }
      
      public function removeEffectFromMapObject(param1:int, param2:int) : MapObjectEffect
      {
         return this.removeEffect(this.getEffectForMapObject(param1,param2)) as MapObjectEffect;
      }
      
      public function removeAllEffectsFromMapObject(param1:int, param2:int) : void
      {
         var _loc3_:Effect = null;
         for each(_loc3_ in this._effects.concat(this._effectsCache))
         {
            if(_loc3_ is MapObjectEffect && _loc3_.id == param2 && MapObjectEffect(_loc3_).source.id == param1)
            {
               this.removeEffect(_loc3_);
            }
         }
      }
      
      public function removeAllEffectsForMapObject(param1:int) : void
      {
         var _loc2_:Effect = null;
         for each(_loc2_ in this._effects.concat(this._effectsCache))
         {
            if(_loc2_ is MapObjectEffect && (_loc2_ as MapObjectEffect).source.id == param1)
            {
               this.removeEffect(_loc2_);
            }
         }
      }
      
      public function removeAllEffects() : void
      {
         this._effectGroupsData = {};
         while(this._effects.length > 0)
         {
            this.removeEffect(this._effects.pop());
         }
         while(this._effectsCache.length > 0)
         {
            this.removeEffect(this._effectsCache.pop());
         }
      }
      
      public function getEffectById(param1:int) : Effect
      {
         var _loc2_:Effect = null;
         for each(_loc2_ in this._effects)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function removeEffectById(param1:int) : Effect
      {
         var _loc2_:Effect = null;
         for each(_loc2_ in this._effects)
         {
            if(_loc2_.id == param1)
            {
               return this.removeEffect(_loc2_) as Effect;
            }
         }
         return null;
      }
      
      public function getEffectByIdAndEntityId(param1:int, param2:int) : Effect
      {
         var _loc3_:Effect = null;
         var _loc4_:SolaceEffect = null;
         for each(_loc3_ in this._effects)
         {
            if(_loc3_ is SolaceEffect)
            {
               _loc4_ = _loc3_ as SolaceEffect;
               if(_loc4_.id == param1 && _loc4_.sourceId == param2)
               {
                  return _loc3_;
               }
            }
         }
         return null;
      }
      
      public function removeEffectByIdAndEntityId(param1:int, param2:int) : Effect
      {
         var _loc3_:Effect = null;
         var _loc4_:SolaceEffect = null;
         for each(_loc3_ in this._effects)
         {
            if(_loc3_ is SolaceEffect)
            {
               _loc4_ = _loc3_ as SolaceEffect;
               if(_loc4_.id == param1 && _loc4_.sourceId == param2)
               {
                  return this.removeEffect(_loc3_) as Effect;
               }
            }
         }
         return null;
      }
      
      private function internalPlay(param1:Effect) : void
      {
         var _loc2_:Boolean = param1.activate();
         if(_loc2_)
         {
            this.effectAdded.dispatch(param1);
         }
         else if(param1.persistent || param1.timeout)
         {
            this.internalRemove(param1);
            this._effectsCache.push(param1);
         }
      }
      
      public function reactivateEffectsForId(param1:int) : void
      {
         var _loc4_:MapObjectEffect = null;
         var _loc2_:Vector.<Effect> = this._effectsCache.concat();
         var _loc3_:int = int(_loc2_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = _loc2_[_loc5_] as MapObjectEffect;
            if((Boolean(_loc4_)) && Boolean(_loc4_.source) && _loc4_.source.id == param1)
            {
               this.internalRemove(_loc4_);
               this.addMapObjectEffectOnce(_loc4_);
            }
            _loc5_++;
         }
      }
      
      public function moveEffectsToCacheForId(param1:int) : void
      {
         var _loc4_:MapObjectEffect = null;
         var _loc2_:Vector.<Effect> = this._effects.concat();
         var _loc3_:int = int(_loc2_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = _loc2_[_loc5_] as MapObjectEffect;
            if(Boolean((_loc4_) && _loc4_.source) && Boolean(_loc4_.source.id == param1) && !_loc4_.ignoresCloak)
            {
               this.internalRemove(_loc4_);
               this.effectRemoved.dispatch(_loc4_);
               this._effectsCache.push(_loc4_);
            }
            _loc5_++;
         }
      }
   }
}

