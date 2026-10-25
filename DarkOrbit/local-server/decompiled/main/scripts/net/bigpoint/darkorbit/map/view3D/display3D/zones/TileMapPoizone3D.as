package net.bigpoint.darkorbit.map.view3D.display3D.zones
{
   import away3d.containers.ObjectContainer3D;
   import away3d.entities.Mesh;
   import away3d.textures.Texture2DBase;
   import away3d.tools.commands.Merge;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.EntityBasicMaterial;
   import net.bigpoint.darkorbit.pattern.BackgroundPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.Poi3dVO;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class TileMapPoizone3D extends ObjectContainer3D
   {
      
      private static const LIB_POIZONES_XML:Class = TileMapPoizone3D_LIB_POIZONES_XML;
      
      private static const LIMITED_WIDTH:int = 5021;
      
      private static const LIMITED_HEIGHT:int = 3132;
      
      private static const MARGIN:int = 0;
      
      private var _maskBitmapData:BitmapData;
      
      private var _bounds:Rectangle;
      
      private var _maskScale:Number = 0.1;
      
      private var pattern:BackgroundPattern;
      
      private var _poi3dVO:Poi3dVO;
      
      private var _geoDict:Dictionary = new Dictionary();
      
      private var _diff:Vector.<Texture2DBase>;
      
      private var _normals:Vector.<Texture2DBase>;
      
      private var _specular:Texture2DBase;
      
      private var _glow:Texture2DBase;
      
      private var _alphaMask:Texture2DBase;
      
      private var _amountOfMeshesToLoad:int = 0;
      
      private var _amountOfTexturesToLoad:int = 0;
      
      private var _amountOfTexturesLoaded:int = 0;
      
      public function TileMapPoizone3D(param1:int, param2:Rectangle, param3:int, param4:int)
      {
         var _loc7_:Number = NaN;
         super();
         this._bounds = param2;
         this.pattern = PatternManager.backgroundPatterns[param1] as BackgroundPattern;
         this._poi3dVO = this.pattern.poi3dVO;
         if(!this.pattern.useOutOfMapBorder)
         {
            if(this._bounds.left < -MARGIN)
            {
               this._bounds.left = -MARGIN;
            }
            if(this._bounds.right > param3 + MARGIN)
            {
               this._bounds.right = param3 + MARGIN;
            }
            if(this._bounds.top < -MARGIN)
            {
               this._bounds.top = -MARGIN;
            }
            if(this._bounds.bottom > param4 + MARGIN)
            {
               this._bounds.bottom = param4 + MARGIN;
            }
         }
         var _loc5_:Number = this._bounds.width * this._maskScale;
         var _loc6_:Number = this._bounds.height * this._maskScale;
         if(_loc5_ > LIMITED_WIDTH || _loc6_ > LIMITED_HEIGHT)
         {
            _loc7_ = Math.max(_loc5_ / LIMITED_WIDTH,_loc6_ / LIMITED_HEIGHT);
            this._maskScale /= _loc7_;
            _loc5_ /= _loc7_;
            _loc6_ /= _loc7_;
         }
         this._maskBitmapData = new BitmapData(int(_loc5_),int(_loc6_),true,0);
      }
      
      public function get maskBitmapData() : BitmapData
      {
         return this._maskBitmapData;
      }
      
      public function get maskScale() : Number
      {
         return this._maskScale;
      }
      
      override public function dispose() : void
      {
         this._maskBitmapData.dispose();
         this._maskBitmapData = null;
         this.disposeTileMap();
         super.dispose();
      }
      
      public function get bounds() : Rectangle
      {
         return this._bounds;
      }
      
      public function update() : void
      {
         var _loc2_:String = null;
         if(!this._poi3dVO.geometry)
         {
            return;
         }
         this._geoDict = new Dictionary();
         var _loc1_:Vector.<String> = this._poi3dVO.geometry;
         this._amountOfMeshesToLoad = _loc1_.length;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_)
            {
               World3D.instance.geometryLoader.loadGeometry(_loc2_,World3D.LIFETIME_MAP).addOnce(this.geoReady);
            }
            else
            {
               --this._amountOfMeshesToLoad;
            }
         }
      }
      
      private function geoReady(param1:ObjectContainer3D) : void
      {
         var _loc2_:Mesh = null;
         var _loc3_:Merge = null;
         if(param1)
         {
            _loc2_ = new Mesh(null);
            _loc3_ = new Merge();
            _loc3_.applyToContainer(_loc2_,param1);
            _loc2_.name = param1.name;
            this._geoDict[param1.name] = _loc2_;
         }
         if(--this._amountOfMeshesToLoad <= 0)
         {
            this._diff = new Vector.<Texture2DBase>();
            this.loadTextures(this._poi3dVO.textureDiff,this.diffReady);
         }
      }
      
      private function diffReady(param1:Texture2DBase) : void
      {
         ++this._amountOfTexturesLoaded;
         if(param1)
         {
            this._diff.push(param1);
         }
         if(this._amountOfTexturesLoaded >= this._amountOfTexturesToLoad)
         {
            if(this._poi3dVO.textureNormal.length >= 1)
            {
               this._normals = new Vector.<Texture2DBase>();
               this.loadTextures(this._poi3dVO.textureNormal,this.normalReady);
            }
            else
            {
               this.normalReady(null);
            }
         }
      }
      
      private function loadTextures(param1:Vector.<String>, param2:Function) : void
      {
         var _loc3_:String = null;
         this._amountOfTexturesToLoad = param1.length;
         this._amountOfTexturesLoaded = 0;
         this._normals = new Vector.<Texture2DBase>();
         for each(_loc3_ in param1)
         {
            if(_loc3_)
            {
               World3D.instance.textureLoader.loadTexture(_loc3_,World3D.LIFETIME_MAP).addOnce(param2);
            }
            else
            {
               --this._amountOfTexturesToLoad;
            }
         }
      }
      
      private function normalReady(param1:Texture2DBase) : void
      {
         ++this._amountOfTexturesLoaded;
         if(param1)
         {
            this._normals.push(param1);
         }
         if(this._amountOfTexturesLoaded >= this._amountOfTexturesToLoad)
         {
            if(this._poi3dVO.textureSpecular.length >= 1)
            {
               World3D.instance.textureLoader.loadTexture(this._poi3dVO.textureSpecular[0],World3D.LIFETIME_MAP).addOnce(this.specularReady);
            }
            else
            {
               this.specularReady(null);
            }
         }
      }
      
      private function specularReady(param1:Texture2DBase) : void
      {
         this._specular = param1;
         if(this._poi3dVO.textureGlow.length >= 1)
         {
            World3D.instance.textureLoader.loadTexture(this._poi3dVO.textureGlow[0],World3D.LIFETIME_MAP).addOnce(this.glowReady);
         }
         else
         {
            this.glowReady(null);
         }
      }
      
      private function glowReady(param1:Texture2DBase) : void
      {
         this._glow = param1;
         if(this._poi3dVO.textureAlphaMask.length >= 1)
         {
            World3D.instance.textureLoader.loadTexture(this._poi3dVO.textureAlphaMask[0],World3D.LIFETIME_MAP).addOnce(this.alphaMaskReady);
         }
         else
         {
            this.allReady();
         }
      }
      
      private function alphaMaskReady(param1:Texture2DBase) : void
      {
         this._alphaMask = param1;
         this.allReady();
      }
      
      private function allReady() : void
      {
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:BitmapData = null;
         var _loc10_:Vector.<EntityBasicMaterial> = null;
         var _loc11_:Dictionary = null;
         var _loc12_:int = 0;
         var _loc13_:ObjectContainer3D = null;
         var _loc14_:int = 0;
         var _loc15_:EntityBasicMaterial = null;
         var _loc16_:Number = NaN;
         var _loc17_:EntityBasicMaterial = null;
         var _loc18_:Boolean = false;
         var _loc19_:Mesh = null;
         var _loc20_:String = null;
         var _loc21_:String = null;
         var _loc22_:EntityBasicMaterial = null;
         var _loc23_:String = null;
         this.disposeTileMap();
         var _loc1_:BackgroundPattern = this.pattern;
         var _loc2_:int = Math.round(this._bounds.width / _loc1_.tileWidth);
         var _loc3_:int = Math.round(this._bounds.height / _loc1_.tileHeight);
         var _loc4_:int = this._bounds.x % _loc1_.tileWidth;
         if(_loc4_ < 0)
         {
            _loc4_ += _loc1_.tileWidth;
         }
         var _loc5_:int = this._bounds.y % _loc1_.tileHeight;
         if(_loc5_ < 0)
         {
            _loc5_ += _loc1_.tileHeight;
         }
         _loc4_ += _loc1_.offsetX;
         _loc5_ += _loc1_.offsetY;
         _loc2_ = _loc2_ < 1 ? 1 : _loc2_;
         _loc3_ = _loc3_ < 1 ? 1 : _loc3_;
         if(_loc2_ >= 1 && _loc3_ >= 1)
         {
            _loc9_ = this.maskBitmapData;
            if(_loc9_ != null)
            {
               _loc10_ = new Vector.<EntityBasicMaterial>();
               _loc11_ = new Dictionary();
               _loc12_ = 0;
               while(_loc12_ < this._diff.length)
               {
                  _loc17_ = new EntityBasicMaterial();
                  _loc17_.name = this._diff[_loc12_].name;
                  _loc17_.texture = this._diff[_loc12_];
                  _loc17_.alphaBlending = this._poi3dVO.alphaBlending;
                  _loc17_.alphaPremultiplied = this._poi3dVO.alphaPremultiplied;
                  _loc18_ = this._poi3dVO.useLights;
                  if(_loc18_)
                  {
                     _loc17_.lightPicker = World3D.instance.lights.picker;
                     _loc17_.specularMap = this._specular;
                     _loc17_.setTexture("glow",this._glow);
                     _loc17_.normalMap = this._normals[this._normals.length > _loc12_ ? _loc12_ : this._normals.length - 1];
                  }
                  if(this._alphaMask)
                  {
                     _loc17_.setTexture("alpha",this._alphaMask);
                  }
                  _loc10_.push(_loc17_);
                  _loc11_[_loc17_.name] = _loc17_;
                  _loc12_++;
               }
               _loc13_ = new ObjectContainer3D();
               _loc14_ = int(this._poi3dVO.geometry.length);
               _loc15_ = null;
               _loc16_ = 0;
               _loc7_ = 0;
               while(_loc7_ < _loc3_)
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc2_)
                  {
                     if(this.checkMaskOpaque(_loc8_,_loc7_,_loc9_,_loc2_,_loc3_))
                     {
                        _loc6_ = FastMath.getRandomCount(0,_loc14_ - 1);
                        if(!this.checkMaskOpaque(_loc8_,_loc7_ + 1,_loc9_,_loc2_,_loc3_))
                        {
                           while(this._poi3dVO.deepTiles.indexOf(this._poi3dVO.geometry[_loc6_]) != -1)
                           {
                              _loc6_ = FastMath.getRandomCount(0,_loc14_ - 1);
                           }
                        }
                        if(this._poi3dVO.textureIdIsGeoId)
                        {
                           _loc20_ = this._poi3dVO.geometry[_loc6_];
                           _loc21_ = this._poi3dVO.textureDiff[_loc6_];
                           _loc19_ = Mesh(this._geoDict[_loc20_]).clone() as Mesh;
                           _loc22_ = EntityBasicMaterial(_loc11_[_loc21_]);
                           _loc19_.material = _loc22_;
                        }
                        else
                        {
                           _loc15_ = _loc10_[_loc16_];
                           _loc16_ = (_loc16_ + 1) % _loc10_.length;
                           _loc23_ = this._poi3dVO.geometry[_loc6_];
                           _loc19_ = Mesh(this._geoDict[_loc23_]).clone() as Mesh;
                           _loc19_.material = _loc15_;
                        }
                        _loc19_.x = this._bounds.x + _loc8_ * _loc1_.tileWidth + _loc4_ + 128;
                        _loc19_.y += -0.5 * this._poi3dVO.ySpread + Math.random() * this._poi3dVO.ySpread;
                        _loc19_.z = -(this._bounds.y + _loc7_ * _loc1_.tileHeight + _loc5_ + 128);
                        if(this._poi3dVO.randomGeometryRotation)
                        {
                           _loc19_.rotate(Vector3D.Y_AXIS,int(Math.random() * 4) * 90);
                        }
                        _loc19_.scale(this._poi3dVO.meshScale);
                        if(this._poi3dVO.enlargeInnerTilesFactor != 1 && this.checkIsInnerTile(_loc8_,_loc7_,_loc9_,_loc2_,_loc3_))
                        {
                           _loc19_.scale(this._poi3dVO.enlargeInnerTilesFactor);
                        }
                        _loc13_.addChild(_loc19_);
                     }
                     _loc8_ += 1 / (1 + this._poi3dVO.additionalTilesInGrid);
                  }
                  _loc7_ += 1 / (1 + this._poi3dVO.additionalTilesInGrid);
               }
               addChild(_loc13_);
            }
         }
      }
      
      private function checkIsInnerTile(param1:Number, param2:Number, param3:BitmapData, param4:int, param5:int) : Boolean
      {
         if(this.checkMaskOpaque(param1 - 1,param2,param3,param4,param5) && this.checkMaskOpaque(param1 + 1,param2,param3,param4,param5) && this.checkMaskOpaque(param1,param2 - 1,param3,param4,param5) && this.checkMaskOpaque(param1,param2 + 1,param3,param4,param5))
         {
            return true;
         }
         return false;
      }
      
      private function checkMaskOpaque(param1:Number, param2:Number, param3:BitmapData, param4:int, param5:int) : Boolean
      {
         var _loc14_:String = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc6_:int = param3.width * Math.min(param1 + 0.1,param4) / param4;
         var _loc7_:int = param3.width * Math.min(param1 + 0.5,param4) / param4;
         var _loc8_:int = param3.width * Math.min(param1 + 0.9,param4) / param4;
         var _loc9_:int = param3.height * Math.min(param2 + 0.1,param5) / param5;
         var _loc10_:int = param3.height * Math.min(param2 + 0.5,param5) / param5;
         var _loc11_:int = param3.height * Math.min(param2 + 0.9,param5) / param5;
         var _loc12_:Number = 0.6;
         var _loc13_:Array = new Array();
         if(param3.getPixel32(_loc7_,_loc10_) != 0)
         {
            if(param3.getPixel32(_loc6_,_loc9_) != 0)
            {
               _loc13_.push(1);
            }
            if(param3.getPixel32(_loc8_,_loc9_) != 0)
            {
               _loc13_.push(3);
            }
            if(param3.getPixel32(_loc6_,_loc11_) != 0)
            {
               _loc13_.push(7);
            }
            if(param3.getPixel32(_loc8_,_loc11_) != 0)
            {
               _loc13_.push(9);
            }
            if(_loc13_.length < 2)
            {
               return false;
            }
            if(_loc13_.length > 2)
            {
               return true;
            }
            _loc14_ = _loc13_.toString();
            if(_loc14_ == "1,3")
            {
               _loc15_ = param3.height * Math.min(param2 + _loc12_,param5) / param5;
               return param3.getPixel32(_loc6_,_loc15_) != 0 && param3.getPixel32(_loc8_,_loc15_) != 0;
            }
            if(_loc14_ == "1,7")
            {
               _loc16_ = param3.width * Math.min(param1 + _loc12_,param4) / param4;
               return param3.getPixel32(_loc16_,_loc9_) != 0 && param3.getPixel32(_loc16_,_loc11_) != 0;
            }
         }
         return false;
      }
      
      private function disposeTileMap() : void
      {
         while(numChildren)
         {
            removeChildAt(0);
         }
      }
   }
}

