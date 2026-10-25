package net.bigpoint.darkorbit.map.view2D.backgrounds.view
{
   import com.greensock.TweenLite;
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   import net.bigpoint.as3toolbox.filecollection.finish.DefaultFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.as3toolbox.starling.mapfactory.Config;
   import net.bigpoint.as3toolbox.starling.mapfactory.IMapElement;
   import net.bigpoint.as3toolbox.starling.mapfactory.MapElement;
   import net.bigpoint.as3toolbox.starling.mapfactory.OversizedTilesModifier;
   import net.bigpoint.as3toolbox.starling.mapfactory.TileMap;
   import net.bigpoint.as3toolbox.starling.mapfactory.TileMapBuilder;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.view2D.backgrounds.model.BackgroundVO;
   import net.bigpoint.darkorbit.map.view2D.zones.tilemap.TileMapPoizone2D;
   import net.bigpoint.darkorbit.mvc.display.StarlingSprite;
   import net.bigpoint.darkorbit.mvc.display.impl.starling.TexturesCache;
   import net.bigpoint.darkorbit.pattern.BackgroundPattern;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   import starling.textures.ConcreteTexture;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   import starling.textures.TextureOptions;
   
   public class StarlingTiledMap extends AbstractBackgroundElement2D
   {
      
      public var offsetX:int = 0;
      
      public var offsetY:int = 0;
      
      private var _tileMap:TileMap;
      
      private var width:int;
      
      private var height:int;
      
      private var _viewportWidth:int = 0;
      
      private var _viewportHeight:int = 0;
      
      public var equalNeighborsAllowed:Boolean = false;
      
      private var _texture:Texture;
      
      private var _atlasXML:XML;
      
      public function StarlingTiledMap(param1:BackgroundVO, param2:int, param3:int)
      {
         super(new StarlingSprite(),param1);
         if(this.backgroundVO.pattern.width > 0 && this.backgroundVO.pattern.height > 0)
         {
            this.width = this.backgroundVO.pattern.width;
            this.height = this.backgroundVO.pattern.height;
         }
         else if(this.backgroundVO.pattern.order == "ASC" || this.backgroundVO.pattern.order == "DESC")
         {
            this.width = Math.round(param2 / 10 * this.backgroundVO.scale);
            this.height = Math.round(param3 / 10 * this.backgroundVO.scale);
         }
         else
         {
            this.width = Math.round(param2 / this.backgroundVO.parallaxFactor * this.backgroundVO.scale * this.backgroundVO.tileMapSizeMultiplier);
            this.height = Math.round(param3 / this.backgroundVO.parallaxFactor * this.backgroundVO.scale * this.backgroundVO.tileMapSizeMultiplier);
         }
      }
      
      public function get backgroundVO() : BackgroundVO
      {
         return data as BackgroundVO;
      }
      
      override public function setViewportSize(param1:int, param2:int) : void
      {
         super.setViewportSize(param1,param2);
         this._viewportWidth = param1;
         this._viewportHeight = param2;
         this.loadView();
      }
      
      override public function update(param1:int, param2:int, param3:int, param4:int) : void
      {
         if(this._tileMap)
         {
            this._tileMap.setPosition(int(-param1 / this.backgroundVO.parallaxFactor + param3 + this.offsetX),int(-param2 / this.backgroundVO.parallaxFactor + param4 + this.offsetY));
         }
      }
      
      override protected function loadView() : void
      {
         if(this.meetsQualitySettings())
         {
            ResourceManager.fileCollection.load(this.backgroundVO.pattern.atlasXml,this.handleAtlasLoadComplete);
         }
         else
         {
            this.unloadView();
         }
      }
      
      override protected function meetsQualitySettings() : Boolean
      {
         if(this.backgroundVO is TileMapPoizone2D)
         {
            return Settings.qualityPoizone.value >= Settings.QUALITY_MEDIUM;
         }
         return Settings.qualityBackground.value == Settings.QUALITY_HIGH;
      }
      
      override protected function unloadView() : void
      {
         this.disposeTileMap();
         this._atlasXML = null;
         if(this._texture)
         {
            if(this._texture is ConcreteTexture)
            {
               ConcreteTexture(this._texture).onRestore = null;
            }
            this._texture.dispose();
            this._texture = null;
         }
         super.unloadView();
      }
      
      private function handleAtlasLoadComplete(param1:XMLFinisher) : void
      {
         if(this.meetsQualitySettings())
         {
            this._atlasXML = param1.getXML();
            this.loadTexture();
         }
         else
         {
            this.unloadView();
         }
         param1.dispose();
      }
      
      private function loadTexture() : void
      {
         var _loc1_:String = this.backgroundVO.pattern.resKeyStarling;
         if(Settings.useATF && ResourceManager.fileCollection.fileExists(_loc1_ + "_atf"))
         {
            _loc1_ += "_atf";
         }
         ResourceManager.fileCollection.load(_loc1_,this.handleTextureLoadComplete);
      }
      
      private function handleTextureLoadComplete(param1:FileCollectionFinisher) : void
      {
         var _loc2_:Object = null;
         var _loc3_:TextureOptions = null;
         if(this.meetsQualitySettings())
         {
            if(param1 is DefaultFinisher)
            {
               _loc2_ = DefaultFinisher(param1).data as ByteArray;
            }
            if(this._texture)
            {
               TexturesCache.reupload(this._texture,_loc2_);
               this.initTileMap();
            }
            else
            {
               _loc3_ = new TextureOptions();
               _loc3_.onReady = this.initTileMap;
               this._texture = Texture.fromData(_loc2_,_loc3_);
               ConcreteTexture(this._texture).onRestore = this.loadTexture;
            }
         }
         else
         {
            this.unloadView();
         }
         param1.dispose();
      }
      
      private function initTileMap() : void
      {
         this.disposeTileMap();
         var _loc1_:TextureAtlas = new TextureAtlas(this._texture,this._atlasXML);
         if(this.backgroundVO.scale != 1)
         {
            this.offsetX = -Math.round((this.width - this.width / this.backgroundVO.scale) / 2) + this.backgroundVO.shiftX;
            this.offsetY = -Math.round((this.height - this.height / this.backgroundVO.scale) / 2) + this.backgroundVO.shiftY;
         }
         else
         {
            this.offsetX = this.backgroundVO.shiftX;
            this.offsetY = this.backgroundVO.shiftY;
         }
         var _loc2_:Vector.<Vector.<IMapElement>> = this.prepareTileMap(_loc1_.getTextures().length);
         var _loc3_:int = this._viewportWidth + this.backgroundVO.pattern.tileWidth * 2;
         var _loc4_:int = this._viewportHeight + this.backgroundVO.pattern.tileHeight * 2;
         var _loc5_:Config = new Config(_loc1_,_loc2_,_loc3_,_loc4_,this.backgroundVO.pattern.tileWidth,this.backgroundVO.pattern.tileHeight,this.backgroundVO.pattern.tileWidth,this.backgroundVO.pattern.tileHeight);
         this._tileMap = new TileMapBuilder(_loc5_).withConfigModifier(new OversizedTilesModifier()).build();
         this._tileMap.x = -this.backgroundVO.pattern.tileWidth;
         this._tileMap.y = -this.backgroundVO.pattern.tileHeight;
         view.addUntypedChild(this._tileMap);
         this._tileMap.alpha = 0;
         TweenLite.to(this._tileMap,1,{"alpha":1});
      }
      
      private function prepareTileMap(param1:int) : Vector.<Vector.<IMapElement>>
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Vector.<Vector.<IMapElement>> = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:BitmapData = null;
         var _loc11_:Number = NaN;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc2_:BackgroundPattern = this.backgroundVO.pattern;
         var _loc3_:int = Math.round(this.width / _loc2_.tileWidth);
         var _loc4_:int = Math.round(this.height / _loc2_.tileHeight);
         _loc3_ = _loc3_ < 1 ? 1 : _loc3_;
         _loc4_ = _loc4_ < 1 ? 1 : _loc4_;
         if(_loc3_ >= 1 && _loc4_ >= 1)
         {
            _loc7_ = TileMap.createMap(_loc3_,_loc4_);
            _loc10_ = this.backgroundVO.maskBitmapData;
            if(_loc10_ != null)
            {
               _loc11_ = this.width / _loc10_.width;
               _loc8_ = 0;
               while(_loc8_ < _loc4_)
               {
                  _loc9_ = 0;
                  while(_loc9_ < _loc3_)
                  {
                     _loc12_ = Math.round((_loc9_ * _loc2_.tileWidth + _loc2_.tileWidth / 2) / _loc11_);
                     _loc13_ = Math.round((_loc8_ * _loc2_.tileHeight + _loc2_.tileHeight / 2) / _loc11_);
                     if(_loc10_.getPixel32(_loc12_,_loc13_) == 0)
                     {
                        (_loc7_[_loc8_][_loc9_] as MapElement).setTileID(-1);
                     }
                     else if(this.equalNeighborsAllowed || param1 <= 1)
                     {
                        _loc6_ = FastMath.getRandomCount(0,param1 - 1);
                        (_loc7_[_loc8_][_loc9_] as MapElement).setTileID(_loc6_);
                     }
                     else
                     {
                        _loc6_ = FastMath.getRandomCount(0,param1 - 1);
                        if(!(_loc8_ == 0 && _loc9_ == 0))
                        {
                           if(_loc8_ == 0)
                           {
                              while((_loc7_[_loc8_][_loc9_ - 1] as MapElement).getTileID() == _loc6_)
                              {
                                 _loc6_ = FastMath.getRandomCount(0,param1 - 1);
                              }
                           }
                           else if(_loc9_ == 0)
                           {
                              while((_loc7_[_loc8_ - 1][_loc9_] as MapElement).getTileID() == _loc6_)
                              {
                                 _loc6_ = FastMath.getRandomCount(0,param1 - 1);
                              }
                           }
                           else
                           {
                              while((_loc7_[_loc8_][_loc9_ - 1] as MapElement).getTileID() == _loc6_ || (_loc7_[_loc8_ - 1][_loc9_] as MapElement).getTileID() == _loc6_)
                              {
                                 _loc6_ = FastMath.getRandomCount(0,param1 - 1);
                              }
                           }
                        }
                        (_loc7_[_loc8_][_loc9_] as MapElement).setTileID(_loc6_);
                     }
                     _loc9_++;
                  }
                  _loc8_++;
               }
            }
            else
            {
               if(_loc2_.order != null)
               {
                  switch(_loc2_.order)
                  {
                     case "DESC":
                        _loc5_ = param1;
                        break;
                     case "ASC":
                     default:
                        _loc5_ = 1;
                  }
               }
               _loc8_ = 0;
               while(_loc8_ < _loc4_)
               {
                  _loc9_ = 0;
                  while(_loc9_ < _loc3_)
                  {
                     if(_loc2_.order != null)
                     {
                        (_loc7_[_loc8_][_loc9_] as MapElement).setTileID(_loc5_);
                        switch(_loc2_.order)
                        {
                           case "DESC":
                              if(--_loc5_ < 1)
                              {
                                 _loc5_ = param1;
                              }
                              break;
                           case "ASC":
                           default:
                              if(++_loc5_ > param1)
                              {
                                 _loc5_ = 1;
                              }
                        }
                     }
                     else if(this.equalNeighborsAllowed || param1 <= 1)
                     {
                        _loc6_ = FastMath.getRandomCount(0,param1 - 1);
                        (_loc7_[_loc8_][_loc9_] as MapElement).setTileID(_loc6_);
                     }
                     else
                     {
                        if(_loc8_ == 0 && _loc9_ == 0)
                        {
                           _loc6_ = FastMath.getRandomCount(0,param1 - 1);
                        }
                        else if(_loc8_ == 0)
                        {
                           while((_loc7_[_loc8_][_loc9_ - 1] as MapElement).getTileID() == _loc6_)
                           {
                              _loc6_ = FastMath.getRandomCount(0,param1 - 1);
                           }
                        }
                        else if(_loc9_ == 0)
                        {
                           while((_loc7_[_loc8_ - 1][_loc9_] as MapElement).getTileID() == _loc6_)
                           {
                              _loc6_ = FastMath.getRandomCount(0,param1 - 1);
                           }
                        }
                        else
                        {
                           while((_loc7_[_loc8_][_loc9_ - 1] as MapElement).getTileID() == _loc6_ || (_loc7_[_loc8_ - 1][_loc9_] as MapElement).getTileID() == _loc6_)
                           {
                              _loc6_ = FastMath.getRandomCount(0,param1 - 1);
                           }
                        }
                        (_loc7_[_loc8_][_loc9_] as MapElement).setTileID(_loc6_);
                     }
                     _loc9_++;
                  }
                  _loc8_++;
               }
            }
         }
         return _loc7_;
      }
      
      private function disposeTileMap() : void
      {
         if(this._tileMap)
         {
            view.removeUntypedChild(this._tileMap);
            this._tileMap.dispose();
            this._tileMap = null;
         }
      }
   }
}

