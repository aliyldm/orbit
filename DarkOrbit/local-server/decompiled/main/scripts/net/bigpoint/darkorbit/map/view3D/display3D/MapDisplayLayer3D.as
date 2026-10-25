package net.bigpoint.darkorbit.map.view3D.display3D
{
   import away3d.containers.ObjectContainer3D;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitContainer;
   import net.bigpoint.darkorbit.map.model.core.MapEntityContainer;
   import net.bigpoint.darkorbit.map.model.poizones.circle.CircleZoneDisplayTrait;
   import net.bigpoint.darkorbit.map.model.poizones.polygon.PoligonZoneDisplayTrait;
   import net.bigpoint.darkorbit.map.model.poizones.rectangle.RectangleZoneDisplayTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.zones.CirclePoizone3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.zones.PoligonZone3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.zones.RectanglePoizone3D;
   
   public class MapDisplayLayer3D
   {
      
      MapEntityContainer.registerTraitClass(RectangleZoneDisplayTrait);
      MapEntityContainer.registerTraitClass(CircleZoneDisplayTrait);
      MapEntityContainer.registerTraitClass(PoligonZoneDisplayTrait);
      
      private const _traitClass2internalList:Dictionary = new Dictionary(true);
      
      private var _container:ObjectContainer3D;
      
      public function MapDisplayLayer3D(param1:ObjectContainer3D)
      {
         super();
         this._container = param1;
         this.addTrait2ViewMapping(UberDisplayTrait,MapUberAsset3D);
         this.addTrait2ViewMapping(RectangleZoneDisplayTrait,RectanglePoizone3D);
         this.addTrait2ViewMapping(CircleZoneDisplayTrait,CirclePoizone3D);
         this.addTrait2ViewMapping(PoligonZoneDisplayTrait,PoligonZone3D);
      }
      
      public function set map(param1:MapEntityContainer) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this._traitClass2internalList)
         {
            InternalDisplayLayer(this._traitClass2internalList[_loc2_]).list = param1 ? param1.getTraitsList(_loc2_) : null;
         }
      }
      
      public function getViewByTrait(param1:EntityTraitBase) : ObjectContainer3D
      {
         var _loc2_:InternalDisplayLayer = null;
         var _loc3_:ObjectContainer3D = null;
         var _loc4_:* = undefined;
         for(_loc4_ in this._traitClass2internalList)
         {
            _loc2_ = this._traitClass2internalList[_loc4_] as InternalDisplayLayer;
            _loc3_ = _loc2_.getView(param1);
            if(_loc3_)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      protected function addTrait2ViewMapping(param1:Class, param2:Class) : void
      {
         var _loc3_:InternalDisplayLayer = new InternalDisplayLayer(this._container,param1,param2);
         this._traitClass2internalList[param1] = _loc3_;
      }
   }
}

import away3d.containers.ObjectContainer3D;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import net.bigpoint.darkorbit.map.common.IDisposable;
import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
import net.bigpoint.darkorbit.map.model.core.EntityTraitContainer;

class InternalDisplayLayer
{
   
   private const _viewByData:Dictionary = new Dictionary(true);
   
   private var _container:ObjectContainer3D;
   
   private var _traitClass:Class;
   
   private var _viewClass:Class;
   
   private var _list:EntityTraitContainer;
   
   public function InternalDisplayLayer(param1:ObjectContainer3D, param2:Class, param3:Class)
   {
      super();
      this._container = param1;
      this._traitClass = param2;
      this._viewClass = param3;
   }
   
   public function set list(param1:EntityTraitContainer) : void
   {
      var _loc2_:* = undefined;
      var _loc3_:EntityTraitBase = null;
      if(this._list)
      {
         this._list.traitAdded.remove(this.addTrait);
         this._list.traitRemoved.remove(this.removeTrait);
         for(_loc2_ in this._viewByData)
         {
            this.removeTrait(_loc2_);
         }
      }
      this._list = param1;
      if(this._list)
      {
         this._list.traitAdded.add(this.addTrait);
         this._list.traitRemoved.add(this.removeTrait);
         for each(_loc3_ in this._list.traits)
         {
            this.addTrait(_loc3_);
         }
      }
   }
   
   public function getView(param1:EntityTraitBase) : ObjectContainer3D
   {
      return this._viewByData[param1] as ObjectContainer3D;
   }
   
   private function addTrait(param1:EntityTraitBase) : void
   {
      var _loc2_:ObjectContainer3D = null;
      if(getQualifiedClassName(param1) == getQualifiedClassName(this._traitClass))
      {
         _loc2_ = new this._viewClass(param1);
         this._container.addChild(_loc2_);
         this._viewByData[param1] = _loc2_;
      }
   }
   
   private function removeTrait(param1:EntityTraitBase) : void
   {
      var _loc2_:ObjectContainer3D = this._viewByData[param1] as ObjectContainer3D;
      if(_loc2_ != null)
      {
         if(_loc2_ is IDisposable)
         {
            (_loc2_ as IDisposable).disposeView();
         }
         else if(_loc2_.parent)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         this._viewByData[param1] = null;
         delete this._viewByData[param1];
      }
   }
}
