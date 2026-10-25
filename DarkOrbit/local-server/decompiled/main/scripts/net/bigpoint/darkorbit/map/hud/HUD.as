package net.bigpoint.darkorbit.map.hud
{
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.common.tools.DebugInfoTrait;
   import net.bigpoint.darkorbit.map.hud.click.ClickIcon;
   import net.bigpoint.darkorbit.map.hud.debug.DebugHitAreaView;
   import net.bigpoint.darkorbit.map.hud.debug.DebugInfo;
   import net.bigpoint.darkorbit.map.hud.debug.ShipDebugHUD;
   import net.bigpoint.darkorbit.map.hud.ship.HealthInfoHUD;
   import net.bigpoint.darkorbit.map.hud.ship.ShipHUD;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitContainer;
   import net.bigpoint.darkorbit.map.model.core.MapEntityContainer;
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   import net.bigpoint.darkorbit.map.model.traits.LabelTrait;
   import net.bigpoint.darkorbit.map.model.traits.MouseHitAreaTrait;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.ClickIconTrait;
   import net.bigpoint.darkorbit.map.model.traits.hud.MapObjectInfoTrait;
   import net.bigpoint.darkorbit.mvc.display.impl.flash.LayeredSprite;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class HUD extends LayeredSprite
   {
      
      MapEntityContainer.registerTraitClass(MapObjectInfoTrait);
      MapEntityContainer.registerTraitClass(ClickIconTrait);
      MapEntityContainer.registerTraitClass(HPTrait);
      
      private const _traitClass2internalList:Vector.<InternalDisplayLayer> = new Vector.<InternalDisplayLayer>();
      
      private var _mapView:IMapView;
      
      private var _map:Map;
      
      public function HUD(param1:IMapView)
      {
         super();
         this._mapView = param1;
         this.addTrait2ViewMapping(ClickIconTrait,ClickIcon);
         this.addTrait2ViewMapping(MapObjectInfoTrait,ShipHUD);
         this.addTrait2ViewMapping(HPTrait,HealthInfoHUD);
         this.addTrait2ViewMapping(LabelTrait,HUDLabel);
      }
      
      public function set map(param1:Map) : void
      {
         var _loc2_:InternalDisplayLayer = null;
         this._map = param1;
         for each(_loc2_ in this._traitClass2internalList)
         {
            _loc2_.list = this._map ? this._map.getTraitsList(_loc2_.traitClass) : null;
         }
         if(this._map)
         {
            Settings.showHUD.changed.add(this.visibilitySettingChanged);
            this.visibilitySettingChanged();
         }
         else
         {
            Settings.showHUD.changed.remove(this.visibilitySettingChanged);
         }
      }
      
      public function addTrait2ViewMapping(param1:Class, param2:Class) : void
      {
         var _loc3_:InternalDisplayLayer = new InternalDisplayLayer(this._mapView,this,param1,param2);
         this._traitClass2internalList.push(_loc3_);
         _loc3_.list = this._map ? this._map.getTraitsList(_loc3_.traitClass) : null;
      }
      
      protected function removeTrait2ViewMapping(param1:Class, param2:Class) : void
      {
         var _loc3_:InternalDisplayLayer = null;
         for each(_loc3_ in this._traitClass2internalList)
         {
            if(_loc3_.traitClass == param1 && _loc3_.viewClass == param2)
            {
               this._traitClass2internalList.splice(this._traitClass2internalList.indexOf(_loc3_),1);
               _loc3_.list = null;
            }
         }
      }
      
      private function updateDebugObjects() : void
      {
         this.removeTrait2ViewMapping(MouseHitAreaTrait,DebugHitAreaView);
         this.removeTrait2ViewMapping(ClickIconTrait,DebugHitAreaView);
         this.removeTrait2ViewMapping(DebugInfoTrait,DebugInfo);
         this.removeTrait2ViewMapping(MapObjectInfoTrait,ShipDebugHUD);
         if(Settings.show_debug_objects.value)
         {
            this.addTrait2ViewMapping(MouseHitAreaTrait,DebugHitAreaView);
            this.addTrait2ViewMapping(ClickIconTrait,DebugHitAreaView);
            this.addTrait2ViewMapping(DebugInfoTrait,DebugInfo);
            this.addTrait2ViewMapping(MapObjectInfoTrait,ShipDebugHUD);
         }
      }
      
      private function visibilitySettingChanged() : void
      {
         visible = Settings.showHUD.value;
      }
   }
}

import flash.display.DisplayObject;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import net.bigpoint.darkorbit.map.IMapView;
import net.bigpoint.darkorbit.map.common.IDisposable;
import net.bigpoint.darkorbit.map.common.ILayerChild;
import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
import net.bigpoint.darkorbit.map.model.core.EntityTraitContainer;
import net.bigpoint.darkorbit.mvc.display.impl.flash.LayeredSprite;

class InternalDisplayLayer
{
   
   private const _viewByData:Dictionary = new Dictionary(true);
   
   private var _container:LayeredSprite;
   
   private var _traitClass:Class;
   
   private var _viewClass:Class;
   
   private var _list:EntityTraitContainer;
   
   private var _mapView:IMapView;
   
   public function InternalDisplayLayer(param1:IMapView, param2:LayeredSprite, param3:Class, param4:Class)
   {
      super();
      this._mapView = param1;
      this._container = param2;
      this._traitClass = param3;
      this._viewClass = param4;
   }
   
   public function set list(param1:EntityTraitContainer) : void
   {
      var _loc2_:* = undefined;
      var _loc3_:Vector.<EntityTraitBase> = null;
      var _loc4_:int = 0;
      var _loc5_:int = 0;
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
         _loc3_ = this._list.traits;
         _loc4_ = int(_loc3_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            this.addTrait(_loc3_[_loc5_]);
            _loc5_++;
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
      if(getQualifiedClassName(param1) == getQualifiedClassName(this._traitClass))
      {
         _loc2_ = new this._viewClass(this._mapView,param1);
         _loc3_ = 0;
         if(_loc2_ is ILayerChild)
         {
            _loc3_ = ILayerChild(_loc2_).layer;
         }
         this._container.addChildOnLayer(_loc2_,_loc3_);
         this._viewByData[param1] = _loc2_;
      }
   }
   
   private function removeTrait(param1:EntityTraitBase) : void
   {
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
         this._viewByData[param1] = null;
         delete this._viewByData[param1];
      }
   }
   
   public function get traitClass() : Class
   {
      return this._traitClass;
   }
   
   public function get viewClass() : Class
   {
      return this._viewClass;
   }
}
