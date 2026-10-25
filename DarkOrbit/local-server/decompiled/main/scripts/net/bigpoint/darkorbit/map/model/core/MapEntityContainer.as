package net.bigpoint.darkorbit.map.model.core
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.map.model.env.rabbit.Rabbit;
   import net.bigpoint.eventstream.EventStreamClient;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class MapEntityContainer
   {
      
      private static const _registeredTraitClasses:Vector.<Class> = new Vector.<Class>();
      
      private static const _storage:Object = {};
      
      public const entityAdded:ISignal = new Signal(Number);
      
      private var _entities:Vector.<MapEntity> = new Vector.<MapEntity>();
      
      private var _entitiesById:Object = {};
      
      private var _traitsByClass:Dictionary = new Dictionary();
      
      private var _rabbits:Vector.<Rabbit> = new Vector.<Rabbit>();
      
      public function MapEntityContainer()
      {
         var _loc1_:Class = null;
         super();
         for each(_loc1_ in _registeredTraitClasses)
         {
            this._traitsByClass[_loc1_] = new EntityTraitContainer();
         }
      }
      
      public static function registerTraitClass(param1:Class) : void
      {
         _registeredTraitClasses.push(param1);
      }
      
      public function get entities() : Vector.<MapEntity>
      {
         return this._entities.concat();
      }
      
      public function addEntity(param1:MapEntity) : MapEntity
      {
         var _loc3_:EntityTraitBase = null;
         var _loc4_:* = undefined;
         var _loc5_:EntityTraitContainer = null;
         var _loc2_:int = param1 ? int(this._entities.indexOf(param1)) : 0;
         if(_loc2_ == -1)
         {
            this.removeEntityById(param1.id);
            this._entities.push(param1);
            this._entitiesById[param1.id] = param1;
            param1.traitAdded.add(this.traitAdded);
            param1.traitRemoved.add(this.traitRemoved);
            param1.activateEntity(this);
            for each(_loc3_ in param1.traits)
            {
               for(_loc4_ in this._traitsByClass)
               {
                  if(_loc3_ is _loc4_)
                  {
                     _loc5_ = this._traitsByClass[_loc4_] as EntityTraitContainer;
                     _loc5_.addTrait(_loc3_);
                  }
               }
            }
         }
         this.entityAdded.dispatch(param1.id);
         return param1;
      }
      
      public function removeEntity(param1:MapEntity) : MapEntity
      {
         var _loc3_:EntityTraitBase = null;
         var _loc4_:* = 0;
         var _loc5_:EntityTraitContainer = null;
         if(param1 is Rabbit)
         {
            this.removeRabbit(param1 as Rabbit);
            return param1;
         }
         var _loc2_:int = param1 ? int(this._entities.indexOf(param1)) : -1;
         if(_loc2_ != -1)
         {
            param1.traitAdded.remove(this.traitAdded);
            param1.traitRemoved.remove(this.traitRemoved);
            _loc4_ = int(param1.traits.length - 1);
            while(_loc4_ >= 0)
            {
               _loc3_ = param1.traits[_loc4_];
               for each(_loc5_ in this._traitsByClass)
               {
                  _loc5_.removeTrait(_loc3_);
               }
               _loc4_--;
            }
            this._entities.splice(_loc2_,1);
            this._entitiesById[param1.id] = null;
            delete this._entitiesById[param1.id];
            param1.deactivateEntity();
         }
         return param1;
      }
      
      public function removeEntityById(param1:int) : MapEntity
      {
         return this.removeEntity(this.getEntityById(param1));
      }
      
      public function removeTraitById(param1:int, param2:Class) : void
      {
         var _loc3_:MapEntity = this.getEntityById(param1);
         if(_loc3_ != null)
         {
            _loc3_.removeTraitByType(param2);
         }
      }
      
      public function removeAll() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:MapEntity = null;
         for(_loc1_ in this._traitsByClass)
         {
            EntityTraitContainer(this._traitsByClass[_loc1_]).removeAllTraits();
         }
         while(this._entities.length > 0)
         {
            _loc2_ = this._entities.pop() as MapEntity;
            _loc2_.traitAdded.remove(this.traitAdded);
            _loc2_.traitRemoved.remove(this.traitRemoved);
            _loc2_.deactivateEntity();
         }
         this._entitiesById = {};
      }
      
      public function getEntityById(param1:int) : MapEntity
      {
         var _loc2_:MapEntity = this._entitiesById[param1];
         if(_loc2_ == null)
         {
            return this.getRabbit(param1);
         }
         return _loc2_;
      }
      
      public function getEntityByType(param1:Class) : Vector.<MapEntity>
      {
         var _loc4_:MapEntity = null;
         var _loc2_:Vector.<MapEntity> = new Vector.<MapEntity>();
         var _loc3_:uint = this._entities.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = this._entities[_loc5_];
            if(_loc4_ is param1)
            {
               _loc2_.push(_loc4_);
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      public function getRandomEntity() : MapEntity
      {
         return this._entities[int(Math.random() * this._entities.length)] as MapEntity;
      }
      
      public function getRandomEntityContainingTrait(param1:Class) : MapEntity
      {
         var _loc2_:Vector.<EntityTraitBase> = EntityTraitContainer(this.getTraitsList(param1)).traits;
         return _loc2_.length > 0 ? _loc2_[int(Math.random() * _loc2_.length)].owner : null;
      }
      
      public function getTraitById(param1:int, param2:Class) : EntityTraitBase
      {
         var _loc3_:MapEntity = this.getEntityById(param1);
         return _loc3_ ? _loc3_.getFirstTrait(param2) : null;
      }
      
      public function getTraitsById(param1:int, param2:Class) : Vector.<EntityTraitBase>
      {
         var _loc3_:MapEntity = this.getEntityById(param1);
         return _loc3_ ? _loc3_.getTraits(param2) : null;
      }
      
      public function addTraitToId(param1:int, param2:EntityTraitBase) : EntityTraitBase
      {
         var _loc3_:MapEntity = this.getEntityById(param1);
         return _loc3_ ? _loc3_.addTrait(param2) : null;
      }
      
      public function getTraitsList(param1:*) : EntityTraitContainer
      {
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:MapEntity = null;
         var _loc7_:EntityTraitBase = null;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc2_:String = new Error().getStackTrace();
         if(_loc2_)
         {
            _loc4_ = _loc2_.split("\n");
            _loc5_ = _loc4_.length > 0 ? _loc4_[_loc4_.length - 1] : _loc2_;
            if(_storage[_loc5_] == null)
            {
               EventStreamClient.track("flash.exec.tr",{"stack":_loc5_});
               _storage[_loc5_] = true;
            }
         }
         var _loc3_:EntityTraitContainer = this._traitsByClass[param1];
         if(_loc3_ == null)
         {
            _loc3_ = this._traitsByClass[param1] = new EntityTraitContainer();
            _loc8_ = int(this._entities.length - 1);
            while(_loc8_ >= 0)
            {
               _loc6_ = this._entities[_loc8_];
               _loc9_ = int(_loc6_.traits.length - 1);
               while(_loc9_ >= 0)
               {
                  _loc7_ = _loc6_.traits[_loc9_];
                  if(_loc7_ is param1)
                  {
                     _loc3_.addTrait(_loc7_);
                  }
                  _loc9_--;
               }
               _loc8_--;
            }
         }
         return _loc3_;
      }
      
      private function traitAdded(param1:EntityTraitBase) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:EntityTraitContainer = null;
         for(_loc2_ in this._traitsByClass)
         {
            if(param1 is _loc2_)
            {
               _loc3_ = this._traitsByClass[_loc2_] as EntityTraitContainer;
               _loc3_.addTrait(param1);
            }
         }
      }
      
      private function traitRemoved(param1:EntityTraitBase) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:EntityTraitContainer = null;
         for(_loc2_ in this._traitsByClass)
         {
            if(param1 is _loc2_)
            {
               _loc3_ = this._traitsByClass[_loc2_] as EntityTraitContainer;
               _loc3_.removeTrait(param1);
            }
         }
      }
      
      public function getRabbit(param1:int) : Rabbit
      {
         var _loc2_:* = int(this._rabbits.length - 1);
         while(_loc2_ >= 0)
         {
            if(this._rabbits[_loc2_].id == param1)
            {
               return this._rabbits[_loc2_];
            }
            _loc2_--;
         }
         return null;
      }
      
      public function addRabbit(param1:Rabbit) : void
      {
         var _loc2_:int = param1 ? int(this._rabbits.indexOf(param1)) : 0;
         if(_loc2_ == -1)
         {
            this._rabbits.push(param1);
         }
      }
      
      public function removeRabbit(param1:Rabbit) : *
      {
         var _loc2_:int = param1 ? int(this._rabbits.indexOf(param1)) : -1;
         if(_loc2_ != -1)
         {
            this._rabbits.splice(_loc2_,1);
         }
      }
   }
}

