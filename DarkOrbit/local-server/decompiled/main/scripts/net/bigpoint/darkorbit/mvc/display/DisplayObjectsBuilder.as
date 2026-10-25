package net.bigpoint.darkorbit.mvc.display
{
   import avmplus.getQualifiedClassName;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.mvc.display.filter.FilterBuilder;
   import net.bigpoint.darkorbit.mvc.display.filter.impl.flash.DOFlashBlurFilter;
   import net.bigpoint.darkorbit.mvc.display.filter.impl.flash.DOFlashColorMatrixFilter;
   import net.bigpoint.darkorbit.mvc.display.filter.impl.flash.DOFlashDropShadowFilter;
   import net.bigpoint.darkorbit.mvc.display.filter.impl.flash.DOFlashGlowFilter;
   import net.bigpoint.darkorbit.mvc.display.filter.impl.starling.DOStarlingBlurFilter;
   import net.bigpoint.darkorbit.mvc.display.filter.impl.starling.DOStarlingColorMatrixFilter;
   import net.bigpoint.darkorbit.mvc.display.filter.impl.starling.DOStarlingDropShadowFilter;
   import net.bigpoint.darkorbit.mvc.display.filter.impl.starling.DOStarlingGlowFilter;
   import net.bigpoint.darkorbit.mvc.display.impl.flash.DOFlashBitmap;
   import net.bigpoint.darkorbit.mvc.display.impl.flash.DOFlashMovieClip;
   import net.bigpoint.darkorbit.mvc.display.impl.flash.DOFlashSprite;
   import net.bigpoint.darkorbit.mvc.display.impl.flash.DOFlashTextField;
   import net.bigpoint.darkorbit.mvc.display.impl.starling.DOStarlingBitmap;
   import net.bigpoint.darkorbit.mvc.display.impl.starling.DOStarlingMovieClip;
   import net.bigpoint.darkorbit.mvc.display.impl.starling.DOStarlingSprite;
   import net.bigpoint.darkorbit.mvc.display.impl.starling.DOStarlingTextField;
   import net.bigpoint.darkorbit.mvc.display.utils.DOBitmapAtlasResource;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class DisplayObjectsBuilder
   {
      
      private static var _flashViewBuilder:DisplayObjectsBuilder;
      
      private static var _starlingViewBuilder:DisplayObjectsBuilder;
      
      private var _useATF:Boolean;
      
      private var _impl:Dictionary;
      
      private var _filterbuilder:FilterBuilder;
      
      public function DisplayObjectsBuilder(param1:Boolean, param2:Class, param3:Class, param4:Class, param5:Class, param6:FilterBuilder)
      {
         super();
         this._useATF = param1;
         this._impl = new Dictionary(true);
         this.setImplementation(IDOSprite,param2);
         this.setImplementation(IDOBitmap,param3);
         this.setImplementation(IDOMovieClip,param4);
         this.setImplementation(IDOTextField,param5);
      }
      
      public static function get viewBuilder() : DisplayObjectsBuilder
      {
         return Settings.gpuSupport ? starlingViewBuilder : flashViewBuilder;
      }
      
      public static function get flashViewBuilder() : DisplayObjectsBuilder
      {
         var _loc1_:FilterBuilder = null;
         if(_flashViewBuilder == null)
         {
            _loc1_ = new FilterBuilder(DOFlashBlurFilter,DOFlashGlowFilter,DOFlashDropShadowFilter,DOFlashColorMatrixFilter);
            _flashViewBuilder = new DisplayObjectsBuilder(false,DOFlashSprite,DOFlashBitmap,DOFlashMovieClip,DOFlashTextField,_loc1_);
            _flashViewBuilder.setImplementation(IDisplayObject,FlashSprite);
         }
         return _flashViewBuilder;
      }
      
      public static function get starlingViewBuilder() : DisplayObjectsBuilder
      {
         var _loc1_:FilterBuilder = null;
         if(_starlingViewBuilder == null)
         {
            _loc1_ = new FilterBuilder(DOStarlingBlurFilter,DOStarlingGlowFilter,DOStarlingDropShadowFilter,DOStarlingColorMatrixFilter);
            _starlingViewBuilder = new DisplayObjectsBuilder(true,DOStarlingSprite,DOStarlingBitmap,DOStarlingMovieClip,DOStarlingTextField,_loc1_);
            _starlingViewBuilder.setImplementation(IDisplayObject,StarlingSprite);
         }
         return _starlingViewBuilder;
      }
      
      public function setImplementation(param1:Class, param2:Class) : void
      {
         this._impl[param1] = param2;
      }
      
      public function build(param1:Class) : Object
      {
         var _loc2_:Class = this._impl[param1] as Class;
         if(_loc2_)
         {
            return new _loc2_();
         }
         throw new Error("No implementation for " + getQualifiedClassName(param1) + " interface");
      }
      
      public function buildSprite() : IDOSprite
      {
         return this.build(IDOSprite) as IDOSprite;
      }
      
      public function buildMovieClip(param1:DOBitmapAtlasResource, param2:String = null, param3:Number = 30) : IDOMovieClip
      {
         var _loc4_:Class = this._impl[IDOMovieClip] as Class;
         if(_loc4_)
         {
            return new _loc4_(param1,param2,param3) as IDOMovieClip;
         }
         throw new Error("No implementation for " + getQualifiedClassName(IDOMovieClip) + " interface");
      }
      
      public function buildBitmap(param1:Object = null) : IDOBitmap
      {
         var _loc2_:IDOBitmap = this.build(IDOBitmap) as IDOBitmap;
         if(param1)
         {
            _loc2_.texture = param1;
         }
         return _loc2_;
      }
      
      public function buildTextField() : IDOTextField
      {
         return this.build(IDOTextField) as IDOTextField;
      }
      
      public function buildDisplayObject(param1:DOBitmapAtlasResource, param2:String, param3:int = 30) : IDODisplayObject
      {
         var _loc5_:IDODisplayObject = null;
         var _loc4_:int = Boolean(param1) && Boolean(param1.atlas) ? param1.atlas.getTexturesCount(param2) : 0;
         if(_loc4_ == 1)
         {
            _loc5_ = this.buildBitmap();
            IDOBitmap(_loc5_).setSubtexture(param1.texture,param1.atlas.getRegion(param2));
         }
         else if(_loc4_ > 1)
         {
            _loc5_ = this.buildMovieClip(param1,param2,param3 || 30);
         }
         else
         {
            _loc5_ = this.buildSprite();
         }
         return _loc5_;
      }
      
      public function get filterbuilder() : FilterBuilder
      {
         return this._filterbuilder;
      }
      
      public function get useATF() : Boolean
      {
         return this._useATF;
      }
   }
}

