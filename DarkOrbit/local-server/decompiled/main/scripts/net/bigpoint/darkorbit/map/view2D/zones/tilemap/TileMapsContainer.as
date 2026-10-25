package net.bigpoint.darkorbit.map.view2D.zones.tilemap
{
   import com.bigpoint.utils.PointLite;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitContainer;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   import net.bigpoint.darkorbit.map.model.poizones.POIZoneTrait;
   import net.bigpoint.darkorbit.map.model.poizones.circle.CircleZone;
   import net.bigpoint.darkorbit.map.model.poizones.polygon.PoligonZone;
   import net.bigpoint.darkorbit.map.model.poizones.rectangle.RectangleZone;
   import net.bigpoint.darkorbit.map.view2D.backgrounds.view.AbstractBackgroundElement2D;
   import net.bigpoint.darkorbit.map.view2D.backgrounds.view.Background2D;
   import net.bigpoint.darkorbit.map.view2D.backgrounds.view.BasicElement2D;
   import net.bigpoint.darkorbit.map.view2D.backgrounds.view.StarlingTiledMap;
   import net.bigpoint.darkorbit.mvc.display.FlashSprite;
   import net.bigpoint.darkorbit.mvc.display.IDisplayObject;
   import net.bigpoint.darkorbit.mvc.display.StarlingSprite;
   import net.bigpoint.darkorbit.pattern.POIBackgroundPattern;
   import net.bigpoint.darkorbit.pattern.POIPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class TileMapsContainer
   {
      
      private var _backgrounds:Background2D;
      
      private var _map:Map;
      
      private var _zones:Vector.<POIZone> = new Vector.<POIZone>();
      
      private var _designMasks:Object = {};
      
      private var _designs:Object = {};
      
      private var _debugContainer:Sprite;
      
      private var _debugBitmap:Bitmap = new Bitmap();
      
      private var _list:EntityTraitContainer;
      
      public function TileMapsContainer(param1:Background2D, param2:Sprite)
      {
         super();
         this._backgrounds = param1;
         this._debugContainer = param2;
      }
      
      public function set map(param1:Map) : void
      {
         var _loc2_:Vector.<EntityTraitBase> = null;
         var _loc3_:POIZoneTrait = null;
         if(this._map)
         {
            this._map.poiManager.ready.remove(this.redrawDirty);
            this._list.traitAdded.remove(this.traitAdded);
            this._list.traitRemoved.remove(this.traitRemoved);
         }
         this._zones.length = 0;
         this._designs = {};
         this._designMasks = {};
         this._map = param1;
         if(this._map)
         {
            this._map.poiManager.ready.add(this.redrawDirty);
            this._list = this._map.getTraitsList(POIZoneTrait);
            this._list.traitAdded.add(this.traitAdded);
            this._list.traitRemoved.add(this.traitRemoved);
            _loc2_ = this._list.traits;
            for each(_loc3_ in _loc2_)
            {
               this.traitAdded(_loc3_);
            }
            this.redrawAll();
            Settings.qualityPoizone.changed.add(this.redrawAll);
         }
         else
         {
            Settings.qualityPoizone.changed.remove(this.redrawAll);
         }
      }
      
      private function traitAdded(param1:POIZoneTrait) : void
      {
         var _loc2_:POIZone = param1.owner as POIZone;
         var _loc3_:POIBackgroundPattern = PatternManager.poizonePatterns[_loc2_.designID] as POIBackgroundPattern;
         if(Boolean(_loc2_.designID != 0) && Boolean(_loc3_) && _loc3_.designType == POIPattern.DESIGN_TYPE_BACKGROUND)
         {
            this._zones.push(_loc2_);
            this._designs[_loc2_.designID] = true;
         }
      }
      
      private function traitRemoved(param1:POIZoneTrait) : void
      {
         var _loc2_:POIZone = param1.owner as POIZone;
         var _loc3_:int = this._zones.indexOf(_loc2_);
         if(_loc3_ != -1)
         {
            this._zones.splice(_loc3_,1);
            this._designs[_loc2_.designID] = true;
         }
      }
      
      private function redrawDirty() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this._designs)
         {
            if(this._designs[_loc1_])
            {
               this.updateDesign(_loc1_ as int);
            }
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
         var _loc5_:Rectangle = null;
         var _loc6_:POIZone = null;
         var _loc7_:AbstractBackgroundElement2D = null;
         this._designs[param1] = false;
         var _loc2_:TileMapPoizone2D = this._designMasks[param1] as TileMapPoizone2D;
         if(_loc2_ != null)
         {
            _loc2_.dispose();
            this._backgrounds.removeElement(_loc2_);
            this._designMasks[param1] = null;
            delete this._designMasks[param1];
         }
         if(Settings.qualityPoizone.value <= Settings.QUALITY_LOW)
         {
            return;
         }
         var _loc3_:POIBackgroundPattern = PatternManager.poizonePatterns[param1] as POIBackgroundPattern;
         var _loc4_:int = 0;
         if(_loc3_)
         {
            if(Settings.qualityPoizone.value == Settings.QUALITY_HIGH && _loc3_.backgroundID > 0)
            {
               _loc4_ = _loc3_.backgroundID;
            }
            else if(_loc3_.simpleBackgroundID)
            {
               _loc4_ = _loc3_.simpleBackgroundID;
            }
         }
         if(_loc4_ > 0)
         {
            _loc5_ = new Rectangle(0,0,this._map.serious_width,this._map.serious_height);
            for each(_loc6_ in this._zones)
            {
               if(_loc6_.designID == param1)
               {
                  _loc5_ = _loc5_.union(_loc6_.bounds);
               }
            }
            this._designMasks[param1] = _loc2_ = new TileMapPoizone2D(_loc4_,_loc5_,this._map.serious_width,this._map.serious_height);
            for each(_loc6_ in this._zones)
            {
               if(_loc6_.designID == param1)
               {
                  if(_loc6_ is RectangleZone)
                  {
                     this.drawRectangle(_loc6_ as RectangleZone,_loc2_,4278190080);
                  }
                  else if(_loc6_ is CircleZone)
                  {
                     this.drawCircle(_loc6_ as CircleZone,_loc2_,4278190080);
                  }
                  else if(_loc6_ is PoligonZone)
                  {
                     this.drawPoli(_loc6_ as PoligonZone,_loc2_,4278190080);
                  }
               }
            }
            if(Settings.gpuSupport && _loc2_.isBackgroundTiled(Settings.gpuSupport))
            {
               _loc7_ = new StarlingTiledMap(_loc2_,this._map.serious_width,this._map.serious_height);
            }
            else
            {
               _loc7_ = new BasicElement2D(Settings.gpuSupport ? new StarlingSprite() : new FlashSprite(),_loc2_);
            }
            this._backgrounds.addElement(_loc7_,_loc2_);
         }
      }
      
      private function drawRectangle(param1:POIZone, param2:TileMapPoizone2D, param3:uint) : void
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
      
      private function drawCircle(param1:POIZone, param2:TileMapPoizone2D, param3:uint) : void
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
      
      private function drawPoli(param1:POIZone, param2:TileMapPoizone2D, param3:uint) : void
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

