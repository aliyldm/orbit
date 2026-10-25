package net.bigpoint.darkorbit.map.model.core
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.bindables.BindablePointLite;
   import flash.utils.Dictionary;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class MapEntity extends EntityTraitContainer
   {
      
      private var _id:int;
      
      private var _position:BindablePointLite;
      
      private var _firstTraits:Dictionary = new Dictionary(true);
      
      public const entityActivated:ISignal = new Signal();
      
      public const entityDeactivated:ISignal = new Signal();
      
      private var _container:MapEntityContainer;
      
      private var _pivots:Object = {};
      
      public function MapEntity(param1:int, param2:PointLite)
      {
         super();
         this._id = param1;
         this._position = param2 as BindablePointLite || new BindablePointLite(param2.x,param2.y,param2.z);
      }
      
      public function activateEntity(param1:MapEntityContainer) : void
      {
         var _loc2_:EntityTraitBase = null;
         this._container = param1;
         for each(_loc2_ in traits)
         {
            _loc2_.activateTrait();
         }
         this.entityActivated.dispatch();
      }
      
      public function deactivateEntity() : void
      {
         var _loc1_:EntityTraitBase = null;
         for each(_loc1_ in traits)
         {
            _loc1_.deactivateTrait();
         }
         this.entityDeactivated.dispatch();
         this._container = null;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get position() : BindablePointLite
      {
         return this._position;
      }
      
      public function get x() : int
      {
         return this._position.x;
      }
      
      public function get y() : int
      {
         return this._position.y;
      }
      
      public function get z() : int
      {
         return this._position.z;
      }
      
      public function get x3D() : int
      {
         return this._position.x;
      }
      
      public function get y3D() : int
      {
         return this._position.z;
      }
      
      public function get z3D() : int
      {
         return -this._position.y;
      }
      
      public function getFirstTrait(param1:Class) : EntityTraitBase
      {
         var _loc2_:EntityTraitBase = null;
         var _loc3_:* = 0;
         if(this._firstTraits[param1] == null)
         {
            _loc3_ = int(traits.length - 1);
            while(_loc3_ >= 0)
            {
               _loc2_ = traits[_loc3_];
               if(_loc2_ is param1)
               {
                  this._firstTraits[param1] = _loc2_;
                  return _loc2_;
               }
               _loc3_--;
            }
         }
         return this._firstTraits[param1] as EntityTraitBase;
      }
      
      public function getTraits(param1:Class) : Vector.<EntityTraitBase>
      {
         var _loc5_:EntityTraitBase = null;
         var _loc2_:Vector.<EntityTraitBase> = new Vector.<EntityTraitBase>();
         var _loc3_:Vector.<EntityTraitBase> = traits;
         var _loc4_:int = int(_loc3_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = _loc3_[_loc6_];
            if(_loc5_ is param1)
            {
               _loc2_.push(_loc5_);
            }
            _loc6_++;
         }
         return _loc2_;
      }
      
      override public function addTrait(param1:EntityTraitBase) : EntityTraitBase
      {
         param1.owner = this;
         if(this._container)
         {
            param1.activateTrait();
         }
         super.addTrait(param1);
         return param1;
      }
      
      override public function removeTrait(param1:EntityTraitBase) : EntityTraitBase
      {
         var _loc2_:Object = null;
         for(_loc2_ in this._firstTraits)
         {
            if(this._firstTraits[_loc2_] == param1)
            {
               this._firstTraits[_loc2_] = null;
               delete this._firstTraits[_loc2_];
            }
         }
         if(param1 != null)
         {
            param1.deactivateTrait();
         }
         return super.removeTrait(param1);
      }
      
      public function removeTraitByType(param1:Class) : void
      {
         var _loc2_:EntityTraitBase = null;
         while(true)
         {
            _loc2_ = this.getFirstTrait(param1);
            if(!_loc2_)
            {
               break;
            }
            this.removeTrait(_loc2_);
         }
      }
      
      override public function removeAllTraits() : void
      {
         this._firstTraits = new Dictionary(true);
         super.removeAllTraits();
      }
      
      public function getPivot(param1:String) : BindablePointLite
      {
         var _loc2_:BindablePointLite = this._pivots[param1];
         if(_loc2_ == null)
         {
            _loc2_ = this._pivots[param1] = new BindablePointLite(0,0,0);
         }
         return _loc2_;
      }
      
      public function clearPivots() : void
      {
         this._pivots = {};
      }
      
      public function get container() : MapEntityContainer
      {
         return this._container;
      }
   }
}

