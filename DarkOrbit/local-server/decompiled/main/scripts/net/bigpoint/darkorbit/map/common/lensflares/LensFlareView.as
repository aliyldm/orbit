package net.bigpoint.darkorbit.map.common.lensflares
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   
   public class LensFlareView extends Sprite
   {
      
      private static const _screenPos:PointLite = new PointLite();
      
      private var _vo:LensFlareVO;
      
      private var _clips:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var _star:MovieClip;
      
      private var _lensFlash:Bitmap;
      
      private var _useLensFlash:Boolean;
      
      private var _rect:Rectangle;
      
      private var _flareVisible:Boolean = false;
      
      private var _occlusionKnown:Boolean = false;
      
      public function LensFlareView(param1:LensFlareVO, param2:Rectangle)
      {
         super();
         this._vo = param1;
         this._rect = param2;
         visible = false;
         ResourceManager.fileCollection.load("lensflare" + this._vo.typeID,this.handleResourcesReady);
      }
      
      public function updateLens(param1:ILensFlaresProvider, param2:Vector.<ILensFlareCollider>, param3:Boolean = true) : void
      {
         if(!visible)
         {
            return;
         }
         param1.calculateScreenPosition(this._vo,_screenPos);
         this.x = _screenPos.x;
         this.y = _screenPos.y;
         var _loc4_:Boolean = this._flareVisible;
         if(x < 0 || x > this._rect.width || y < 0 || y > this._rect.height)
         {
            _loc4_ = false;
            this._occlusionKnown = false;
         }
         else if(param3 || !this._occlusionKnown)
         {
            _loc4_ = this.isLensFlareVisible(param2);
            this._occlusionKnown = true;
         }
         if(_loc4_ != this._flareVisible)
         {
            this._flareVisible = _loc4_;
            if(this._flareVisible)
            {
               this.fadeInChildren();
            }
            else
            {
               this.fadeOutChildren();
            }
         }
         this.drawLenses();
         if(this._star)
         {
            this._star.rotation -= 0.15;
         }
      }
      
      public function cleanup() : void
      {
         this._star = null;
         if(this._lensFlash)
         {
            this._lensFlash.bitmapData.dispose();
         }
         while(numChildren)
         {
            removeChild(getChildAt(0));
         }
      }
      
      public function set rect(param1:Rectangle) : void
      {
         this._rect = param1;
         this._occlusionKnown = false;
      }
      
      private function handleResourcesReady(param1:SWFFinisher) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         while(param1.hasEmbeddedObject("lens" + _loc3_))
         {
            _loc2_ = param1.getEmbeddedMovieClip("lens" + _loc3_);
            _loc2_.alpha = 0;
            if(this._vo.blendMode)
            {
               _loc2_.blendMode = this._vo.blendMode;
            }
            this._clips.push(_loc2_);
            addChild(_loc2_);
            _loc3_++;
         }
         if(this._vo.isStar)
         {
            this._star = MovieClip(param1.getEmbeddedMovieClip("star"));
            this._star.play();
            this.addChildAt(this._star,0);
            ResourceManager.fileCollection.load("lensFlash",this.handleLensFlashReady);
         }
         else
         {
            visible = true;
         }
      }
      
      private function handleLensFlashReady(param1:SWFFinisher) : void
      {
         this._lensFlash = param1.getEmbeddedBitmap("lensFlash");
         this._lensFlash.x = -this._lensFlash.width / 2;
         this._lensFlash.y = -this._lensFlash.height / 2;
         addChild(this._lensFlash);
         this._lensFlash.visible = false;
         visible = true;
      }
      
      private function isLensFlareVisible(param1:Vector.<ILensFlareCollider>) : Boolean
      {
         if(x < 0 || x > this._rect.width || y < 0 || y > this._rect.height)
         {
            return false;
         }
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1[_loc3_].testLensFlareCollision(x,y))
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      private function fadeInChildren() : void
      {
         var _loc1_:int = int(this._clips.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            TweenLite.to(this._clips[_loc2_],0.1,{"alpha":1});
            _loc2_++;
         }
         if(this._star != null)
         {
            TweenLite.to(this._star,0,{"alpha":1});
            if(this._useLensFlash)
            {
               this._lensFlash.alpha = 0;
               this._lensFlash.visible = true;
               TweenLite.to(this._lensFlash,0.2,{
                  "alpha":0.75,
                  "onComplete":this.fadeOutLensFlash,
                  "onCompleteParams":[this._lensFlash]
               });
               this._useLensFlash = false;
            }
         }
      }
      
      private function fadeOutLensFlash(param1:Bitmap) : void
      {
         TweenLite.to(param1,3,{
            "alpha":0,
            "onComplete":this.handleRemoveLensFlash,
            "onCompleteParams":[param1]
         });
      }
      
      private function handleRemoveLensFlash(param1:Bitmap) : void
      {
         param1.visible = false;
      }
      
      private function fadeOutChildren() : void
      {
         var _loc1_:int = int(this._clips.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            TweenLite.to(this._clips[_loc2_],0,{"alpha":0});
            _loc2_++;
         }
         if(this._star != null)
         {
            TweenLite.to(this._star,0,{"alpha":0});
         }
      }
      
      private function drawLenses() : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Sprite = null;
         var _loc1_:int = int(this._clips.length);
         var _loc2_:Number = x - this._rect.width / 2;
         var _loc3_:Number = y - this._rect.height / 2;
         var _loc4_:Number = -_loc2_ * 3 / _loc1_;
         _loc5_ = -_loc3_ * 3 / _loc1_;
         var _loc7_:int = 0;
         while(_loc7_ < _loc1_)
         {
            _loc6_ = this._clips[_loc7_];
            _loc6_.x = _loc4_ * _loc7_;
            _loc6_.y = _loc5_ * _loc7_;
            _loc7_++;
         }
         var _loc8_:Number = (Math.sqrt(_loc2_ * _loc2_ + _loc3_ * _loc3_) + 50) * 0.0033;
         _loc8_ = Math.max(0,Math.min(_loc8_,1));
      }
   }
}

