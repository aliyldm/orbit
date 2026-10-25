package net.bigpoint.darkorbit.map.view3D.utils
{
   import away3d.animators.SpriteSheetAnimationSet;
   import away3d.animators.SpriteSheetAnimator;
   import away3d.animators.data.SpriteSheetAnimationFrame;
   import away3d.animators.nodes.SpriteSheetClipNode;
   import away3d.core.base.Geometry;
   import away3d.entities.Mesh;
   import away3d.materials.TextureMaterial;
   import away3d.textures.BitmapTexture;
   import away3d.tools.utils.TextureUtils;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   
   public class Helper
   {
      
      private static const _cache:Dictionary = new Dictionary(true);
      
      private static const _movieClipScales:Dictionary = new Dictionary();
      
      private static const CACHED_MESH_MARKER:String = "__helperCachedMesh";
      
      World3D.instance.resetSignal.add(clearCache);
      
      public function Helper()
      {
         super();
      }
      
      public static function calculateBestTextureSize(param1:int, param2:int, param3:int) : int
      {
         var _loc4_:int = int(TextureUtils.getBestPowerOf2(Math.max(param1,param2)));
         while(int(_loc4_ / param1) * int(_loc4_ / param2) < param3)
         {
            _loc4_ <<= 1;
         }
         return _loc4_;
      }
      
      public static function clearCache() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in _cache)
         {
            _cache[_loc1_] = null;
            delete _cache[_loc1_];
         }
         for(_loc1_ in _movieClipScales)
         {
            delete _movieClipScales[_loc1_];
         }
      }
      
      public static function applyMovieClipScale(param1:String, param2:Mesh, param3:DisplayObject = null) : void
      {
         if(param2 == null)
         {
            return;
         }
         var _loc4_:Vector3D = _movieClipScales[param1] as Vector3D;
         if(_loc4_ == null)
         {
            if(param3 == null)
            {
               return;
            }
            _loc4_ = new Vector3D(param3.height,param3.height,param3.width);
            if(param1)
            {
               _movieClipScales[param1] = _loc4_;
            }
         }
         param2.scaleX = _loc4_.x;
         param2.scaleY = _loc4_.y;
         param2.scaleZ = _loc4_.z;
      }
      
      public static function isCachedMesh(param1:Mesh) : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:Mesh = null;
         if(param1 == null)
         {
            return false;
         }
         if(Boolean(param1.extra) && Boolean(param1.extra[CACHED_MESH_MARKER]))
         {
            return true;
         }
         for(_loc2_ in _cache)
         {
            _loc3_ = _cache[_loc2_] as Mesh;
            if(Boolean(_loc3_) && (_loc3_.geometry == param1.geometry || _loc3_.material == param1.material))
            {
               return true;
            }
         }
         return false;
      }
      
      public static function movieclip2mesh(param1:String, param2:DisplayObject, param3:Geometry = null, param4:int = 25) : Mesh
      {
         var _loc7_:TextureMaterial = null;
         var _loc8_:Rectangle = null;
         var _loc9_:int = 0;
         var _loc10_:BitmapData = null;
         var _loc11_:Matrix = null;
         var _loc12_:MovieClip = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:SpriteSheetClipNode = null;
         var _loc16_:BitmapData = null;
         var _loc17_:Point = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:SpriteSheetAnimationSet = null;
         if(param2 == null)
         {
            return null;
         }
         var _loc5_:Mesh = _cache[param1];
         if(_loc5_ == null)
         {
            _loc7_ = new TextureMaterial();
            _loc7_.alphaBlending = true;
            _loc7_.alphaPremultiplied = true;
            _loc5_ = new Mesh(param3,_loc7_);
            if(param1)
            {
               _cache[param1] = _loc5_;
               _loc5_.extra = {};
               _loc5_.extra[CACHED_MESH_MARKER] = true;
            }
            _loc11_ = new Matrix();
            _loc12_ = param2 as MovieClip;
            if(Boolean(param2) && (_loc12_ == null || _loc12_.totalFrames == 1))
            {
               _loc9_ = int(TextureUtils.getBestPowerOf2(Math.max(param2.width,param2.height)));
               _loc10_ = new BitmapData(_loc9_,_loc9_,true,0);
               _loc8_ = param2.getBounds(param2);
               _loc11_.translate(-_loc8_.x,-_loc8_.y);
               _loc11_.scale(_loc10_.width / _loc8_.width,_loc10_.height / _loc8_.height);
               _loc10_.draw(param2,_loc11_);
            }
            else
            {
               _loc8_ = new Rectangle();
               _loc13_ = 1;
               _loc13_ = 1;
               while(_loc13_ <= _loc12_.totalFrames)
               {
                  _loc12_.gotoAndStop(_loc13_);
                  _loc8_ = _loc8_.union(_loc12_.getBounds(_loc12_));
                  _loc13_++;
               }
               _loc12_.gotoAndStop(1);
               _loc9_ = calculateBestTextureSize(_loc8_.width,_loc8_.height,_loc12_.totalFrames);
               _loc10_ = new BitmapData(_loc9_,_loc9_,true,0);
               _loc14_ = int(_loc9_ / _loc8_.width);
               _loc15_ = new SpriteSheetClipNode();
               _loc15_.name = "default";
               _loc11_ = new Matrix();
               _loc16_ = new BitmapData(_loc8_.width,_loc8_.height,true,0);
               _loc17_ = new Point();
               _loc18_ = 0;
               _loc19_ = 0;
               _loc13_ = 1;
               while(_loc13_ <= _loc12_.totalFrames)
               {
                  _loc18_ = (_loc13_ - 1) % _loc14_;
                  _loc19_ = int((_loc13_ - 1) / _loc14_);
                  _loc12_.gotoAndStop(_loc13_);
                  _loc11_.identity();
                  _loc11_.translate(-_loc8_.x + (_loc8_.width - _loc12_.width),-_loc8_.y + (_loc8_.height - _loc12_.height));
                  _loc16_.fillRect(_loc16_.rect,16777215);
                  _loc16_.draw(_loc12_,_loc11_,null,null,null,true);
                  _loc17_.x = _loc18_ * _loc8_.width;
                  _loc17_.y = _loc19_ * _loc8_.height;
                  _loc10_.copyPixels(_loc16_,_loc16_.rect,_loc17_);
                  _loc15_.addFrame(new SpriteSheetAnimationFrame(_loc17_.x / _loc9_,_loc17_.y / _loc9_,_loc8_.width / _loc9_,_loc8_.height / _loc9_,0),1000 / param4);
                  _loc13_++;
               }
               _loc20_ = new SpriteSheetAnimationSet();
               _loc20_.addAnimation(_loc15_);
               _loc5_.animator = new SpriteSheetAnimator(_loc20_);
            }
            if(_loc10_.width < 2048 && _loc10_.height < 2048)
            {
               _loc7_.texture = new BitmapTexture(_loc10_,true);
            }
         }
         var _loc6_:Mesh = _loc5_.clone() as Mesh;
         if(_loc6_.animator is SpriteSheetAnimator)
         {
            SpriteSheetAnimator(_loc6_.animator).play("default");
            SpriteSheetAnimator(_loc6_.animator).stop();
            SpriteSheetAnimator(_loc6_.animator).fps = param4;
         }
         return _loc6_;
      }
      
      public static function displayObject2texture(param1:DisplayObject) : BitmapTexture
      {
         var _loc2_:Rectangle = null;
         var _loc3_:int = 0;
         var _loc4_:BitmapData = null;
         var _loc5_:Matrix = new Matrix();
         _loc3_ = int(TextureUtils.getBestPowerOf2(Math.max(param1.width,param1.height)));
         _loc4_ = new BitmapData(_loc3_,_loc3_,true,0);
         _loc2_ = param1.getBounds(param1);
         _loc5_.translate(-_loc2_.x,-_loc2_.y);
         _loc5_.scale(_loc4_.width / _loc2_.width,_loc4_.height / _loc2_.height);
         _loc4_.draw(param1,_loc5_);
         return new BitmapTexture(_loc4_,true);
      }
   }
}

