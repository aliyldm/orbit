package net.bigpoint.darkorbit.map.view2D.display
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitContainer;
   import net.bigpoint.darkorbit.map.model.core.MapEntityContainer;
   import net.bigpoint.darkorbit.map.model.poizones.circle.CircleZoneDisplayTrait;
   import net.bigpoint.darkorbit.map.model.poizones.polygon.PoligonZoneDisplayTrait;
   import net.bigpoint.darkorbit.map.model.poizones.rectangle.RectangleZoneDisplayTrait;
   import net.bigpoint.darkorbit.map.model.traits.ShipDisplayTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.display.ship.Ship2D;
   import net.bigpoint.darkorbit.map.view2D.zones.CirclePoizone2D;
   import net.bigpoint.darkorbit.map.view2D.zones.PoligonZone2D;
   import net.bigpoint.darkorbit.map.view2D.zones.RectanglePoizone2D;
   import net.bigpoint.darkorbit.mvc.display.impl.flash.LayeredSprite;
   import net.bigpoint.darkorbit.mvc.traininggrounds.SimpleShipDisplayTrait;
   
   public class MapDisplayLayer2D extends LayeredSprite implements IUpdatable
   {
      
      private static const _bd:BitmapData = new BitmapData(1,1,true,0);
      
      private static const _tmpMtx:Matrix = new Matrix();
      
      MapEntityContainer.registerTraitClass(UberDisplayTrait);
      MapEntityContainer.registerTraitClass(RectangleZoneDisplayTrait);
      MapEntityContainer.registerTraitClass(CircleZoneDisplayTrait);
      MapEntityContainer.registerTraitClass(PoligonZoneDisplayTrait);
      
      private const _traitClass2internalList:Dictionary = new Dictionary(true);
      
      private var _updatables:Vector.<IUpdatable> = new Vector.<IUpdatable>();
      
      public function MapDisplayLayer2D()
      {
         super();
         this.addTrait2ViewMapping(UberDisplayTrait,MapUberAsset2D);
         this.addTrait2ViewMapping(ShipDisplayTrait,Ship2D);
         this.addTrait2ViewMapping(SimpleShipDisplayTrait,SimpleShip2D);
         this.addTrait2ViewMapping(RectangleZoneDisplayTrait,RectanglePoizone2D);
         this.addTrait2ViewMapping(CircleZoneDisplayTrait,CirclePoizone2D);
         this.addTrait2ViewMapping(PoligonZoneDisplayTrait,PoligonZone2D);
      }
      
      public function set map(param1:MapEntityContainer) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this._traitClass2internalList)
         {
            InternalDisplayLayer(this._traitClass2internalList[_loc2_]).list = param1 ? param1.getTraitsList(_loc2_) : null;
         }
      }
      
      public function getViewByTrait(param1:EntityTraitBase) : DisplayObject
      {
         var _loc2_:InternalDisplayLayer = null;
         var _loc3_:DisplayObject = null;
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
      
      public function testLensFlareCollision(param1:int, param2:int) : Boolean
      {
         _tmpMtx.identity();
         _tmpMtx.translate(-param1,-param2);
         _tmpMtx.concat(transform.concatenatedMatrix);
         _bd.lock();
         _bd.setPixel32(0,0,0);
         _bd.draw(this,_tmpMtx,null,null,new Rectangle(0,0,1,1));
         _bd.unlock();
         var _loc3_:uint = _bd.getPixel32(0,0);
         return _loc3_ >>> 24 > 128;
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc2_:* = int(this._updatables.length - 1);
         while(_loc2_ >= 0)
         {
            this._updatables[_loc2_].updateObj(param1);
            _loc2_--;
         }
      }
      
      protected function addTrait2ViewMapping(param1:Class, param2:Class) : void
      {
         var _loc3_:InternalDisplayLayer = new InternalDisplayLayer(this,param1,param2);
         this._traitClass2internalList[param1] = _loc3_;
         this._updatables.push(_loc3_);
      }
   }
}

import flash.display.DisplayObject;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import net.bigpoint.darkorbit.map.common.IDisposable;
import net.bigpoint.darkorbit.map.common.ILayerChild;
import net.bigpoint.darkorbit.map.common.IUpdatable;
import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
import net.bigpoint.darkorbit.map.model.core.EntityTraitContainer;
import net.bigpoint.darkorbit.mvc.display.impl.flash.LayeredSprite;

class InternalDisplayLayer implements IUpdatable
{
   
   private const _viewByData:Dictionary = new Dictionary(true);
   
   private var _container:LayeredSprite;
   
   private var _traitClass:Class;
   
   private var _viewClass:Class;
   
   private var _list:EntityTraitContainer;
   
   private var _updatables:Vector.<IUpdatable> = new Vector.<IUpdatable>();
   
   public function InternalDisplayLayer(param1:LayeredSprite, param2:Class, param3:Class)
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
   
   public function getView(param1:EntityTraitBase) : DisplayObject
   {
      return this._viewByData[param1] as DisplayObject;
   }
   
   private function addTrait(param1:EntityTraitBase) : void
   {
      var _loc2_:DisplayObject = null;
      var _loc3_:int = 0;
      if(this._viewByData[param1] != null)
      {
         throw Error("Unbelivable");
      }
      if(getQualifiedClassName(param1) == getQualifiedClassName(this._traitClass))
      {
         _loc2_ = new this._viewClass(param1);
         _loc3_ = 0;
         if(_loc2_ is ILayerChild)
         {
            _loc3_ = ILayerChild(_loc2_).layer;
         }
         if(_loc2_ is IUpdatable)
         {
            this._updatables.push(_loc2_);
         }
         this._container.addChildOnLayer(_loc2_,_loc3_);
         this._viewByData[param1] = _loc2_;
      }
   }
   
   private function removeTrait(param1:EntityTraitBase) : void
   {
      var _loc3_:int = 0;
      var _loc2_:DisplayObject = this._viewByData[param1] as DisplayObject;
      if(_loc2_ != null)
      {
         if(_loc2_ is IDisposable)
         {
            IDisposable(_loc2_).disposeView();
         }
         else
         {
            this._container.removeChildFromAllLayers(_loc2_);
         }
         _loc3_ = int(this._updatables.indexOf(_loc2_));
         if(_loc3_ != -1)
         {
            this._updatables.splice(_loc3_,1);
         }
         this._viewByData[param1] = null;
         delete this._viewByData[param1];
      }
   }
   
   public function updateObj(param1:Number) : void
   {
      var _loc2_:* = int(this._updatables.length - 1);
      while(_loc2_ >= 0)
      {
         this._updatables[_loc2_].updateObj(param1);
         _loc2_--;
      }
   }
}
