package net.bigpoint.darkorbit.map.view3D.display3D.zones
{
   import com.bigpoint.utils.PointLite;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   import net.bigpoint.darkorbit.map.model.poizones.circle.CircleZone;
   import net.bigpoint.darkorbit.map.model.poizones.circle.CircleZoneDisplayTrait;
   import net.bigpoint.darkorbit.map.model.poizones.polygon.PoligonZone;
   import net.bigpoint.darkorbit.map.model.poizones.polygon.PoligonZoneDisplayTrait;
   import net.bigpoint.darkorbit.map.model.poizones.rectangle.RectangleZone;
   import net.bigpoint.darkorbit.map.model.poizones.rectangle.RectangleZoneDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.pattern.POIBackgroundPattern;
   import net.bigpoint.darkorbit.pattern.POIPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class TileMapsContainer3D
   {
      
      private var _map:Map;
      
      private var _zones:Vector.<POIZone> = new Vector.<POIZone>();
      
      private var _designs:Object = {};
      
      private var _designMasks:Object = {};
      
      private var _dirtyDesigns:Object = {};
      
      private var _debugContainer:Sprite;
      
      private var _debugBitmap:Bitmap = new Bitmap();
      
      public function TileMapsContainer3D(param1:Sprite)
      {
         super();
         this._debugContainer = param1;
         Settings.qualityPoizone.changed.add(this.redrawAll);
      }
      
      public function set map(param1:Map) : void
      {
         var _loc2_:String = null;
         var _loc3_:TileMapPoizone3D = null;
         var _loc4_:Vector.<EntityTraitBase> = null;
         var _loc5_:EntityTraitBase = null;
         if(this._map)
         {
            this._map.poiManager.ready.remove(this.redrawDirty);
            this._map.getTraitsList(RectangleZoneDisplayTrait).traitAdded.remove(this.traitAdded);
            this._map.getTraitsList(CircleZoneDisplayTrait).traitAdded.remove(this.traitAdded);
            this._map.getTraitsList(PoligonZoneDisplayTrait).traitAdded.remove(this.traitAdded);
            this._map.getTraitsList(RectangleZoneDisplayTrait).traitRemoved.remove(this.traitRemoved);
            this._map.getTraitsList(CircleZoneDisplayTrait).traitRemoved.remove(this.traitRemoved);
            this._map.getTraitsList(PoligonZoneDisplayTrait).traitRemoved.remove(this.traitRemoved);
         }
         this._zones.length = 0;
         this._dirtyDesigns = {};
         this._designs = {};
         for(_loc2_ in this._designMasks)
         {
            _loc3_ = this._designMasks[_loc2_] as TileMapPoizone3D;
            if(_loc3_ != null)
            {
               _loc3_.dispose();
               if(_loc3_.parent)
               {
                  _loc3_.parent.removeChild(_loc3_);
               }
               this._designMasks[_loc2_] = null;
               delete this._designMasks[_loc2_];
            }
         }
         this._designMasks = {};
         this._map = param1;
         if(this._map)
         {
            this._map.poiManager.ready.add(this.redrawDirty);
            this._map.getTraitsList(RectangleZoneDisplayTrait).traitAdded.add(this.traitAdded);
            this._map.getTraitsList(CircleZoneDisplayTrait).traitAdded.add(this.traitAdded);
            this._map.getTraitsList(PoligonZoneDisplayTrait).traitAdded.add(this.traitAdded);
            this._map.getTraitsList(RectangleZoneDisplayTrait).traitRemoved.add(this.traitRemoved);
            this._map.getTraitsList(CircleZoneDisplayTrait).traitRemoved.add(this.traitRemoved);
            this._map.getTraitsList(PoligonZoneDisplayTrait).traitRemoved.add(this.traitRemoved);
            _loc4_ = this._map.getTraitsList(PoligonZoneDisplayTrait).traits.concat(this._map.getTraitsList(RectangleZoneDisplayTrait).traits.concat(this._map.getTraitsList(CircleZoneDisplayTrait).traits));
            for each(_loc5_ in _loc4_)
            {
               this.traitAdded(_loc5_);
            }
            this.redrawAll();
         }
      }
      
      private function traitAdded(param1:EntityTraitBase) : void
      {
         var _loc2_:POIZone = param1.owner as POIZone;
         this._zones.push(_loc2_);
         if(_loc2_.designID != 0)
         {
            this._designs[_loc2_.designID] = true;
            this._dirtyDesigns[_loc2_.designID] = true;
         }
      }
      
      private function traitRemoved(param1:EntityTraitBase) : void
      {
         var _loc2_:POIZone = param1.owner as POIZone;
         var _loc3_:int = this._zones.indexOf(_loc2_);
         if(_loc3_ != -1)
         {
            this._zones.splice(_loc3_,1);
            if(_loc2_.designID != 0)
            {
               this._designs[_loc2_.designID] = null;
               delete this._designs[_loc2_.designID];
               this._dirtyDesigns[_loc2_.designID] = true;
            }
         }
      }
      
      private function redrawDirty() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this._dirtyDesigns)
         {
            this.updateDesign(_loc1_ as int);
         }
      }
      
      private function redrawAll() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this._designs)
         {
            this.updateDesign(_loc1_ as int);
         }
      }
      
      private function updateDesign(param1:int) : void
      {
         var _loc6_:Rectangle = null;
         var _loc7_:POIZone = null;
         var _loc2_:TileMapPoizone3D = this._designMasks[param1] as TileMapPoizone3D;
         if(_loc2_ != null)
         {
            _loc2_.dispose();
            if(_loc2_.parent)
            {
               _loc2_.parent.removeChild(_loc2_);
            }
            this._designMasks[param1] = null;
            delete this._designMasks[param1];
         }
         this._dirtyDesigns[param1] = null;
         delete this._dirtyDesigns[param1];
         var _loc3_:Vector.<POIPattern> = PatternManager.poizonePatterns;
         var _loc4_:POIBackgroundPattern = _loc3_[param1] as POIBackgroundPattern;
         var _loc5_:int = 0;
         if(_loc4_)
         {
            if(Settings.qualityPoizone.value >= Settings.QUALITY_GOOD && _loc4_.backgroundID > 0)
            {
               _loc5_ = _loc4_.backgroundID;
            }
            else if(_loc4_.simpleBackgroundID)
            {
               _loc5_ = _loc4_.simpleBackgroundID;
            }
         }
         if(_loc5_ > 0)
         {
            _loc6_ = new Rectangle(0,0,this._map.serious_width,this._map.serious_height);
            for each(_loc7_ in this._zones)
            {
               if(_loc7_.designID == param1)
               {
                  _loc6_ = _loc6_.union(_loc7_.bounds);
               }
            }
            this._designMasks[param1] = _loc2_ = new TileMapPoizone3D(_loc5_,_loc6_,this._map.serious_width,this._map.serious_height);
            for each(_loc7_ in this._zones)
            {
               if(_loc7_.designID == param1)
               {
                  if(_loc7_ is RectangleZone)
                  {
                     this.drawRectangle(_loc7_ as RectangleZone,_loc2_,4278190080);
                  }
                  else if(_loc7_ is CircleZone)
                  {
                     this.drawCircle(_loc7_ as CircleZone,_loc2_,4278190080);
                  }
                  else if(_loc7_ is PoligonZone)
                  {
                     this.drawPoli(_loc7_ as PoligonZone,_loc2_,4278190080);
                  }
               }
            }
            _loc2_.update();
            World3D.instance.mapView.gameWorld.addChild(_loc2_);
         }
      }
      
      private function drawRectangle(param1:POIZone, param2:TileMapPoizone3D, param3:uint) : void
      {
         var _loc4_:RectangleZone = param1 as RectangleZone;
         var _loc5_:Shape = new Shape();
         _loc5_.graphics.beginFill(param3);
         if(param1.inverted)
         {
            _loc5_.graphics.drawRect(0,0,100000,100000);
         }
         _loc5_.graphics.drawRect(param1.x,param1.y,_loc4_.width,_loc4_.height);
         _loc5_.graphics.endFill();
         var _loc6_:Matrix = new Matrix();
         _loc6_.translate(-param2.bounds.x,-param2.bounds.y);
         _loc6_.scale(param2.maskScale,param2.maskScale);
         param2.maskBitmapData.draw(_loc5_,_loc6_);
      }
      
      private function drawCircle(param1:POIZone, param2:TileMapPoizone3D, param3:uint) : void
      {
         var _loc4_:CircleZone = param1 as CircleZone;
         var _loc5_:Shape = new Shape();
         _loc5_.graphics.beginFill(param3);
         if(param1.inverted)
         {
            _loc5_.graphics.drawCircle(0,0,1000000);
         }
         _loc5_.graphics.drawCircle(0,0,_loc4_.radius.value);
         _loc5_.graphics.endFill();
         var _loc6_:Matrix = new Matrix();
         _loc6_.translate(-param2.bounds.x,-param2.bounds.y);
         _loc6_.translate(param1.position.x,param1.position.y);
         _loc6_.scale(param2.maskScale,param2.maskScale);
         param2.maskBitmapData.draw(_loc5_,_loc6_);
      }
      
      private function drawPoli(param1:POIZone, param2:TileMapPoizone3D, param3:uint) : void
      {
         var _loc9_:PointLite = null;
         var _loc4_:PoligonZone = param1 as PoligonZone;
         var _loc5_:Shape = new Shape();
         _loc5_.graphics.beginFill(param3);
         if(param1.inverted)
         {
            _loc5_.graphics.drawRect(0,0,100000,100000);
         }
         var _loc6_:int = int(_loc4_.points.length);
         _loc5_.graphics.moveTo(_loc4_.points[_loc6_ - 1].x,_loc4_.points[_loc6_ - 1].y);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc9_ = _loc4_.points[_loc7_];
            _loc5_.graphics.lineTo(_loc9_.x,_loc9_.y);
            _loc7_++;
         }
         var _loc8_:Matrix = new Matrix();
         _loc8_.translate(-param2.bounds.x,-param2.bounds.y);
         _loc8_.scale(param2.maskScale,param2.maskScale);
         param2.maskBitmapData.draw(_loc5_,_loc8_);
      }
   }
}

