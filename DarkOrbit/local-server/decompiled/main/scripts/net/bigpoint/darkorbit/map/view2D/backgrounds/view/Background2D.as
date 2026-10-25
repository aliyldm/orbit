package net.bigpoint.darkorbit.map.view2D.backgrounds.view
{
   import com.bigpoint.utils.PointLite;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.common.lensflares.ILensFlaresProvider;
   import net.bigpoint.darkorbit.map.common.lensflares.LensFlareVO;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitContainer;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.UberBackgroundDisplayTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.backgrounds.model.BackgroundVO;
   import net.bigpoint.darkorbit.map.view2D.backgrounds.model.PlanetVO;
   import net.bigpoint.darkorbit.map.view2D.backgrounds.view.uber.UberBackgroundElement2D;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   import net.bigpoint.darkorbit.mvc.display.DisplayObjectsBuilder;
   import net.bigpoint.darkorbit.mvc.display.FlashSprite;
   import net.bigpoint.darkorbit.mvc.display.IDOSprite;
   import net.bigpoint.darkorbit.mvc.display.IDisplayObject;
   import net.bigpoint.darkorbit.mvc.display.StarlingSprite;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class Background2D implements ILensFlaresProvider
   {
      
      private var _viewBuilder:DisplayObjectsBuilder;
      
      private var _backgrounds:Vector.<AbstractBackgroundElement2D> = new Vector.<AbstractBackgroundElement2D>();
      
      private var _data2view:Dictionary = new Dictionary(true);
      
      private var _map:Map;
      
      private var _view:IDOSprite;
      
      private var _viewportWidth:int;
      
      private var _viewportHeight:int;
      
      private var _uberDisplayList:EntityTraitContainer;
      
      private var _lensFlares:Vector.<LensFlareVO> = new Vector.<LensFlareVO>();
      
      private var _mapView:IMapView;
      
      private var _invalidateSortingID:uint;
      
      private var _cameraX:Number = 0;
      
      private var _cameraY:Number = 0;
      
      private var _centerX:Number = 0;
      
      private var _centerY:Number = 0;
      
      public function Background2D(param1:DisplayObjectsBuilder, param2:IMapView)
      {
         super();
         this._viewBuilder = param1;
         this._mapView = param2;
         this._view = param1.buildSprite();
         this._view["name"] = "BackgroundLayerView2D";
      }
      
      public function set map(param1:Map) : void
      {
         if(this._map)
         {
            this._map.mapXmlChanged.remove(this.reload);
            this._uberDisplayList.traitAdded.remove(this.handleUberDisplayTraitAdded);
            this._uberDisplayList.traitRemoved.remove(this.handleUberDisplayTraitRemoved);
         }
         this._map = param1;
         if(this._map)
         {
            this._map.mapXmlChanged.add(this.reload);
            this._uberDisplayList = this._map.getTraitsList(UberBackgroundDisplayTrait);
            this._uberDisplayList.traitAdded.add(this.handleUberDisplayTraitAdded);
            this._uberDisplayList.traitRemoved.add(this.handleUberDisplayTraitRemoved);
         }
         this.reload();
      }
      
      public function setViewportSize(param1:int, param2:int) : void
      {
         this._viewportWidth = param1;
         this._viewportHeight = param2;
         var _loc3_:* = int(this._backgrounds.length - 1);
         while(_loc3_ >= 0)
         {
            (this._backgrounds[_loc3_] as AbstractBackgroundElement2D).setViewportSize(this._viewportWidth,this._viewportHeight);
            _loc3_--;
         }
      }
      
      private function reload() : void
      {
         var _loc1_:AbstractBackgroundElement2D = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Rectangle = null;
         var _loc11_:XML = null;
         var _loc12_:XML = null;
         var _loc13_:UberBackgroundDisplayTrait = null;
         var _loc14_:XMLList = null;
         var _loc15_:XML = null;
         var _loc16_:MapEntity = null;
         var _loc17_:BackgroundVO = null;
         var _loc18_:Array = null;
         var _loc19_:PlanetVO = null;
         while(this._backgrounds.length > 0)
         {
            _loc1_ = this._backgrounds.pop();
            this.view.removeUntypedChild(_loc1_.view);
            _loc1_.dispose();
         }
         this._data2view = new Dictionary(true);
         this._lensFlares.length = 0;
         if(this._map == null)
         {
            return;
         }
         var _loc2_:XML = this._map.mapXml;
         if(this._map.mapXml.display2D.length() > 0)
         {
            _loc16_ = new MapEntity(Map.NEXT_FREE_ID,new PointLite());
            _loc16_.addTrait(new UberDisplayTrait(_loc2_));
            this._map.addEntity(_loc16_);
         }
         for each(_loc11_ in _loc2_.child("backgrounds").child("background"))
         {
            _loc3_ = false;
            _loc10_ = null;
            if(_loc11_.attribute("isMain").length() > 0)
            {
               _loc3_ = ParserUtility.parseBooleanFromString(_loc11_.attribute("isMain"));
            }
            else if(_loc2_.child("backgrounds").child("background").length() == 1)
            {
               _loc3_ = true;
            }
            if(_loc11_.attribute("region").length() > 0)
            {
               _loc18_ = _loc11_.attribute("region").toString().split(",");
               if(_loc18_.length > 2)
               {
                  _loc10_ = new Rectangle(_loc18_[0],_loc18_[1],_loc18_[2],_loc18_[3]);
               }
               else
               {
                  _loc10_ = new Rectangle(0,0,_loc18_[0],_loc18_[1]);
               }
            }
            _loc4_ = 10;
            if(_loc11_.attribute("pFactor").length() > 0)
            {
               _loc4_ = int(_loc11_.attribute("pFactor"));
            }
            _loc9_ = 0;
            if(_loc11_.attribute("layer").length() > 0)
            {
               _loc9_ = int(_loc11_.attribute("layer"));
            }
            _loc5_ = 0;
            if(_loc11_.attribute("shiftX").length() > 0)
            {
               _loc5_ = int(_loc11_.attribute("shiftX"));
            }
            _loc6_ = 0;
            if(_loc11_.attribute("shiftY").length() > 0)
            {
               _loc6_ = int(_loc11_.attribute("shiftY"));
            }
            _loc7_ = 1;
            if(_loc11_.attribute("scale").length() > 0)
            {
               _loc7_ = Number(_loc11_.attribute("scale"));
            }
            _loc8_ = -1;
            if(_loc11_.attribute("maskID").length() > 0)
            {
               _loc8_ = int(_loc11_.attribute("maskID"));
            }
            _loc17_ = new BackgroundVO(int(_loc11_.attribute("typeID")),_loc3_,_loc4_,_loc9_,_loc5_,_loc6_,_loc7_,_loc8_,_loc10_);
            if(Settings.gpuSupport && BackgroundVO(_loc17_).isBackgroundTiled(Settings.gpuSupport))
            {
               _loc1_ = new StarlingTiledMap(_loc17_,this._map.serious_width,this._map.serious_height);
            }
            else
            {
               _loc1_ = new BasicElement2D(Settings.gpuSupport ? new StarlingSprite() : new FlashSprite(),_loc17_);
            }
            this.addElement(_loc1_,_loc17_);
         }
         for each(_loc12_ in _loc2_.child("planets").child("planet"))
         {
            _loc9_ = int(_loc12_.attribute("layer"));
            _loc19_ = new PlanetVO(String(_loc12_.attribute("typeID")),int(_loc12_.attribute("x")),int(_loc12_.attribute("y")),Number(_loc12_.attribute("rotation")),Number(_loc12_.attribute("pFactor")),_loc9_,Number(_loc12_.attribute("scale")) || 1,_loc12_.attribute("quality_settings"));
            this.addElement(new Planet2D(this._viewBuilder.buildSprite(),_loc19_),_loc19_);
         }
         for each(_loc13_ in this._uberDisplayList.traits)
         {
            this.handleUberDisplayTraitAdded(_loc13_);
         }
         _loc14_ = this._map.mapXml.lensflares.lensflare;
         for each(_loc15_ in _loc14_)
         {
            this._lensFlares.push(new LensFlareVO(int(_loc15_.attribute("id")),int(_loc15_.attribute("typeID")),new PointLite(Number(_loc15_.attribute("x")) * 10,Number(_loc15_.attribute("y")) * 10,Number(_loc15_.attribute("pFactor"))),ParserUtility.parseBooleanFromString(_loc15_.attribute("star"))));
         }
      }
      
      private function invalidateSorting() : void
      {
         clearTimeout(this._invalidateSortingID);
         this._invalidateSortingID = setTimeout(this.sortElements,1);
      }
      
      public function get view() : IDOSprite
      {
         return this._view;
      }
      
      public function update(param1:Number, param2:Number, param3:int, param4:int) : void
      {
         this._cameraX = param1;
         this._cameraY = param2;
         this._centerX = param3;
         this._centerY = param4;
         var _loc5_:* = int(this._backgrounds.length - 1);
         while(_loc5_ >= 0)
         {
            (this._backgrounds[_loc5_] as AbstractBackgroundElement2D).update(param1,param2,param3,param4);
            _loc5_--;
         }
      }
      
      public function get backgrounds() : Vector.<AbstractBackgroundElement2D>
      {
         return this._backgrounds.concat();
      }
      
      public function testLensFlareCollision(param1:int, param2:int) : Boolean
      {
         var _loc3_:* = int(this._backgrounds.length - 1);
         while(_loc3_ >= 0)
         {
            if(this._backgrounds[_loc3_].testLensFlareCollision(param1,param2))
            {
               return true;
            }
            _loc3_--;
         }
         return false;
      }
      
      public function addElement(param1:AbstractBackgroundElement2D, param2:Object) : void
      {
         if(param1)
         {
            param1.setViewportSize(this._viewportWidth,this._viewportHeight);
            this.view.addUntypedChild(param1.view);
            this._backgrounds.push(param1);
            this._data2view[param2] = param1;
            this.invalidateSorting();
         }
      }
      
      private function sortElements() : void
      {
         this._backgrounds.sort(AbstractBackgroundElement2D.compare);
         var _loc1_:int = 0;
         while(_loc1_ < this._backgrounds.length)
         {
            this.view.addUntypedChild(this._backgrounds[_loc1_].view);
            _loc1_++;
         }
      }
      
      public function removeElement(param1:Object) : void
      {
         var _loc2_:AbstractBackgroundElement2D = this._data2view[param1];
         if(_loc2_)
         {
            this._backgrounds.splice(this._backgrounds.indexOf(_loc2_),1);
            this._data2view[param1] = null;
            delete this._data2view[param1];
            this.view.removeUntypedChild(_loc2_.view);
            _loc2_.dispose();
         }
      }
      
      private function handleUberDisplayTraitAdded(param1:UberBackgroundDisplayTrait) : void
      {
         this.addElement(new UberBackgroundElement2D(this._viewBuilder,param1),param1);
      }
      
      private function handleUberDisplayTraitRemoved(param1:UberBackgroundDisplayTrait) : void
      {
         this.removeElement(param1);
      }
      
      public function get lensFlares() : Vector.<LensFlareVO>
      {
         return this._lensFlares;
      }
      
      public function calculateScreenPosition(param1:LensFlareVO, param2:PointLite) : void
      {
         param2.x = (param1.worldPosition.x - this._cameraX) / param1.worldPosition.z + this._centerX;
         param2.y = (param1.worldPosition.y - this._cameraY) / param1.worldPosition.z + this._centerY;
      }
   }
}

