package net.bigpoint.darkorbit.map.view3D.display3D.background
{
   import away3d.core.base.Geometry;
   import away3d.core.base.SubGeometry;
   import away3d.entities.Mesh;
   import away3d.materials.TextureMaterial;
   import away3d.textures.ATFTexture;
   import away3d.textures.Texture2DBase;
   import com.bigpoint.utils.bindables.BindableString;
   import com.greensock.TweenLite;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import net.bigpoint.as3toolbox.filecollection.finish.DefaultFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.as3toolbox.starling.mapfactory.IMapElement;
   import net.bigpoint.as3toolbox.starling.mapfactory.MapElement;
   import net.bigpoint.as3toolbox.starling.mapfactory.TileMap;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberContainer3D;
   import net.bigpoint.darkorbit.pattern.BackgroundPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class DustTileMap3D extends UberContainer3D
   {
      
      private const BASE_HEIGHT:int = -3500;
      
      private var _atlasVo:AtlasVo;
      
      private var _mat:TextureMaterial = new TextureMaterial(null);
      
      private var _texture:Texture2DBase;
      
      private var _maskID:int = -1;
      
      private var _layerIndex:int = 0;
      
      private var _backgroundPattern:BackgroundPattern;
      
      private var _verts:Vector.<Number> = new Vector.<Number>();
      
      private var _indices:Vector.<uint> = new Vector.<uint>();
      
      private var _uvs:Vector.<Number> = new Vector.<Number>();
      
      private var _indicesMaxNumber:int = 0;
      
      private var _map:Vector.<Vector.<IMapElement>>;
      
      private var _mapWidth:int = 5000;
      
      private var _mapHeight:int = 5000;
      
      private var _tileWidth:Number;
      
      private var _tileHeight:Number;
      
      private var _rand:Number = 0;
      
      private var _textureResKey:String;
      
      public function DustTileMap3D(param1:XML = null, param2:BindableString = null)
      {
         if(param1.attribute("layer").length() > 0)
         {
            this._layerIndex = int(param1.attribute("layer"));
         }
         if(param1.attribute("maskID").length() > 0)
         {
            this._maskID = int(param1.attribute("maskID"));
         }
         var _loc3_:Number = 1;
         if(param1.attribute("mapScale").length() > 0)
         {
            _loc3_ = Number(param1.attribute("mapScale"));
         }
         var _loc4_:Number = 5;
         if(param1.attribute("tileScale").length() > 0)
         {
            _loc4_ = Number(param1.attribute("tileScale"));
         }
         this._backgroundPattern = PatternManager.backgroundPatterns[int(param1.attribute("typeID"))] as BackgroundPattern;
         this._mapWidth = ScreenManager.getInstance().map.serious_width * _loc3_;
         this._mapHeight = ScreenManager.getInstance().map.serious_height * _loc3_;
         this._tileWidth = this._backgroundPattern.tileWidth * _loc4_;
         this._tileHeight = this._backgroundPattern.tileHeight * _loc4_;
         super(param1,param2);
         y = this.BASE_HEIGHT + this._layerIndex * 550;
         x -= (this._mapWidth - ScreenManager.getInstance().map.serious_width) / 2;
         z += (this._mapHeight - ScreenManager.getInstance().map.serious_height - this._tileWidth) / 2;
      }
      
      override protected function loadView() : void
      {
         ResourceManager.fileCollection.load(this._backgroundPattern.atlasXml,this.handleAtlasLoadComplete);
      }
      
      override protected function unloadView() : void
      {
         ResourceManager.fileCollection.removeCallbacks(this._textureResKey,this.handleTextureLoadComplete);
         ResourceManager.fileCollection.removeCallbacks(this._backgroundPattern.atlasXml,this.handleAtlasLoadComplete);
         this._atlasVo = null;
         this._map = null;
         this._verts.length = 0;
         this._indices.length = 0;
         this._uvs.length = 0;
      }
      
      private function handleAtlasLoadComplete(param1:XMLFinisher) : void
      {
         var _loc2_:XML = param1.getXML();
         this._atlasVo = new AtlasVo(_loc2_);
         this._map = this.prepareTileMap(this._atlasVo.numImages);
         if(this._map)
         {
            this.loadTexture();
         }
         else
         {
            disposeView();
         }
      }
      
      private function loadTexture() : void
      {
         this._textureResKey = this._backgroundPattern.resKeyStarling;
         if(ResourceManager.fileCollection.fileExists(this._textureResKey + "_atf"))
         {
            this._textureResKey += "_atf";
         }
         ResourceManager.fileCollection.load(this._textureResKey,this.handleTextureLoadComplete);
      }
      
      private function handleTextureLoadComplete(param1:FileCollectionFinisher) : void
      {
         DefaultFinisher(param1).data.position = 0;
         var _loc2_:ATFTexture = new ATFTexture(DefaultFinisher(param1).data);
         this._texture = _loc2_;
         this._mat.smooth = true;
         this._mat.mipmap = false;
         this._mat.alphaBlending = true;
         this._mat.alphaPremultiplied = false;
         this._mat.texture = _loc2_;
         this.createTileMesh();
      }
      
      private function addSubMesh(param1:Rectangle, param2:int, param3:int) : void
      {
         this._rand = Math.min(-500 + Math.random() * 1000,-200);
         this._verts.push(param2 * this._tileWidth,this._rand,param3 * this._tileHeight);
         this._verts.push(param2 * this._tileWidth + this._tileWidth,this._rand,param3 * this._tileHeight);
         this._verts.push(param2 * this._tileWidth + this._tileWidth,this._rand,param3 * this._tileHeight + this._tileHeight);
         this._verts.push(param2 * this._tileWidth,this._rand,param3 * this._tileHeight + this._tileHeight);
         this._indices.push(this._indicesMaxNumber + 0,this._indicesMaxNumber + 2,this._indicesMaxNumber + 1);
         this._indices.push(this._indicesMaxNumber + 0,this._indicesMaxNumber + 3,this._indicesMaxNumber + 2);
         this._indicesMaxNumber += 4;
         this._uvs.push(param1.x / this._texture.width,param1.y / this._texture.height);
         this._uvs.push(param1.x / this._texture.width + param1.width / this._texture.width,param1.y / this._texture.height);
         this._uvs.push(param1.x / this._texture.width + param1.width / this._texture.width,param1.y / this._texture.height + param1.height / this._texture.height);
         this._uvs.push(param1.x / this._texture.width,param1.y / this._texture.height + param1.height / this._texture.height);
      }
      
      private function createTileMesh() : void
      {
         var _loc7_:int = 0;
         var _loc8_:IMapElement = null;
         var _loc9_:Vector.<int> = null;
         var _loc10_:int = 0;
         var _loc11_:Mesh = null;
         var _loc1_:Geometry = new Geometry();
         var _loc2_:SubGeometry = new SubGeometry();
         var _loc3_:Boolean = false;
         var _loc4_:Number = this._map.length;
         var _loc5_:Number = this._map[0].length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc5_)
            {
               _loc8_ = this._map[_loc6_][_loc7_] as IMapElement;
               _loc9_ = _loc8_.getTileIDs();
               for each(_loc10_ in _loc9_)
               {
                  if(_loc10_ != -1)
                  {
                     _loc3_ = true;
                     this.addSubMesh(this._atlasVo.rectangles[_loc10_],_loc7_,-_loc6_);
                  }
               }
               _loc7_++;
            }
            _loc6_++;
         }
         if(_loc3_)
         {
            _loc2_.updateVertexData(this._verts);
            _loc2_.updateUVData(this._uvs);
            _loc2_.updateIndexData(this._indices);
            _loc1_.addSubGeometry(_loc2_);
            _loc11_ = new Mesh(_loc1_,this._mat);
            this._mat.alpha = 0;
            TweenLite.to(this._mat,1,{"alpha":1});
            addChild(_loc11_);
         }
      }
      
      private function prepareTileMap(param1:int) : Vector.<Vector.<IMapElement>>
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<Vector.<IMapElement>> = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:BitmapData = null;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc2_:int = Math.round(this._mapWidth / this._tileWidth);
         var _loc3_:int = Math.round(this._mapHeight / this._tileHeight);
         _loc2_ = _loc2_ < 1 ? 1 : _loc2_;
         _loc3_ = _loc3_ < 1 ? 1 : _loc3_;
         if(_loc2_ >= 1 && _loc3_ >= 1)
         {
            _loc6_ = TileMap.createMap(_loc2_,_loc3_);
            _loc9_ = this.maskBitmapData;
            if(_loc9_ != null)
            {
               _loc10_ = this._mapWidth / _loc9_.width;
               _loc7_ = 0;
               while(_loc7_ < _loc3_)
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc2_)
                  {
                     _loc11_ = Math.round((_loc8_ * this._tileWidth + this._tileWidth / 2) / _loc10_);
                     _loc12_ = Math.round((_loc7_ * this._tileHeight + this._tileHeight / 2) / _loc10_);
                     if(_loc9_.getPixel32(_loc11_,_loc12_) == 0)
                     {
                        (_loc6_[_loc7_][_loc8_] as MapElement).setTileID(-1);
                     }
                     else if(param1 <= 1)
                     {
                        _loc5_ = FastMath.getRandomCount(0,param1 - 1);
                        (_loc6_[_loc7_][_loc8_] as MapElement).setTileID(_loc5_);
                     }
                     else
                     {
                        _loc5_ = FastMath.getRandomCount(0,param1 - 1);
                        if(!(_loc7_ == 0 && _loc8_ == 0))
                        {
                           if(_loc7_ == 0)
                           {
                              while((_loc6_[_loc7_][_loc8_ - 1] as MapElement).getTileID() == _loc5_)
                              {
                                 _loc5_ = FastMath.getRandomCount(0,param1 - 1);
                              }
                           }
                           else if(_loc8_ == 0)
                           {
                              while((_loc6_[_loc7_ - 1][_loc8_] as MapElement).getTileID() == _loc5_)
                              {
                                 _loc5_ = FastMath.getRandomCount(0,param1 - 1);
                              }
                           }
                           else
                           {
                              while((_loc6_[_loc7_][_loc8_ - 1] as MapElement).getTileID() == _loc5_ || (_loc6_[_loc7_ - 1][_loc8_] as MapElement).getTileID() == _loc5_)
                              {
                                 _loc5_ = FastMath.getRandomCount(0,param1 - 1);
                              }
                           }
                        }
                        (_loc6_[_loc7_][_loc8_] as MapElement).setTileID(_loc5_);
                     }
                     _loc8_++;
                  }
                  _loc7_++;
               }
            }
            else
            {
               if(this._backgroundPattern.order != null)
               {
                  switch(this._backgroundPattern.order)
                  {
                     case "DESC":
                        _loc4_ = param1;
                        break;
                     case "ASC":
                     default:
                        _loc4_ = 1;
                  }
               }
               _loc7_ = 0;
               while(_loc7_ < _loc3_)
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc2_)
                  {
                     if(this._backgroundPattern.order != null)
                     {
                        (_loc6_[_loc7_][_loc8_] as MapElement).setTileID(_loc4_);
                        switch(this._backgroundPattern.order)
                        {
                           case "DESC":
                              if(--_loc4_ < 1)
                              {
                                 _loc4_ = param1;
                              }
                              break;
                           case "ASC":
                           default:
                              if(++_loc4_ > param1)
                              {
                                 _loc4_ = 1;
                              }
                        }
                     }
                     else if(param1 <= 1)
                     {
                        _loc5_ = FastMath.getRandomCount(0,param1 - 1);
                        (_loc6_[_loc7_][_loc8_] as MapElement).setTileID(_loc5_);
                     }
                     else
                     {
                        if(_loc7_ == 0 && _loc8_ == 0)
                        {
                           _loc5_ = FastMath.getRandomCount(0,param1 - 1);
                        }
                        else if(_loc7_ == 0)
                        {
                           while((_loc6_[_loc7_][_loc8_ - 1] as MapElement).getTileID() == _loc5_)
                           {
                              _loc5_ = FastMath.getRandomCount(0,param1 - 1);
                           }
                        }
                        else if(_loc8_ == 0)
                        {
                           while((_loc6_[_loc7_ - 1][_loc8_] as MapElement).getTileID() == _loc5_)
                           {
                              _loc5_ = FastMath.getRandomCount(0,param1 - 1);
                           }
                        }
                        else
                        {
                           while((_loc6_[_loc7_][_loc8_ - 1] as MapElement).getTileID() == _loc5_ || (_loc6_[_loc7_ - 1][_loc8_] as MapElement).getTileID() == _loc5_)
                           {
                              _loc5_ = FastMath.getRandomCount(0,param1 - 1);
                           }
                        }
                        (_loc6_[_loc7_][_loc8_] as MapElement).setTileID(_loc5_);
                     }
                     _loc8_++;
                  }
                  _loc7_++;
               }
            }
         }
         return _loc6_;
      }
      
      public function get maskBitmapData() : BitmapData
      {
         var _loc1_:ResourcePattern = PatternManager.backgroundMaskPatterns[this._maskID];
         return _loc1_ ? ResourceManager.getBitmapData(_loc1_.resKey,"mask") : null;
      }
   }
}

