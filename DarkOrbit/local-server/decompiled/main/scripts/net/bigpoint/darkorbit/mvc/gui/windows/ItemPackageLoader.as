package net.bigpoint.darkorbit.mvc.gui.windows
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.fui.builder.xml.factories.TransitionEffectFactory;
   import net.bigpoint.darkorbit.fui.components.image.ImageSlideShow;
   import net.bigpoint.darkorbit.fui.components.image.ImageSlideShowElement;
   
   public class ItemPackageLoader extends Loadable
   {
      
      private var _slideShow:ImageSlideShow;
      
      private var _playlist:Vector.<ImageSlideShowElement>;
      
      private var _itemShowTimeInSec:Number = 3;
      
      public function ItemPackageLoader()
      {
         super();
         this._slideShow = new ImageSlideShow();
         this._slideShow.repeat = true;
         this.addChildAt(this._slideShow,0);
      }
      
      override public function set width(param1:Number) : void
      {
         this._slideShow.width = param1;
      }
      
      override public function set height(param1:Number) : void
      {
         this._slideShow.height = param1;
      }
      
      public function set list(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:ImageSlideShowElement = null;
         if(param1)
         {
            this._playlist = new Vector.<ImageSlideShowElement>();
            _loadedIndex = 0;
            _loc2_ = param1.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = new ImageSlideShowElement();
               _loc5_.duration = this._itemShowTimeInSec;
               _loc5_.transitionEffect = TransitionEffectFactory.create(TransitionEffectFactory.EFFECT_ALPHAFADE);
               this._playlist.push(_loc5_);
               _loc3_++;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               load(param1[_loc4_]);
               _loc4_++;
            }
         }
      }
      
      override protected function handleItemLoaded(param1:ImageFinisher = null) : void
      {
         var _loc2_:ImageSlideShowElement = null;
         if(_loadedIndex < this._playlist.length)
         {
            _loc2_ = this._playlist[_loadedIndex];
            _loc2_.target = new Bitmap(param1.getBitmap().bitmapData);
            ++_loadedIndex;
         }
         if(_loadedIndex == this._playlist.length - 1)
         {
            _loadingSpinner.finished();
            this._slideShow.playlist = this._playlist;
            this._slideShow.start();
         }
      }
      
      override protected function handleItemLoadError(param1:Object = null) : void
      {
         _loadingSpinner.finished();
      }
      
      public function set itemShowTimeInSec(param1:Number) : void
      {
         this._itemShowTimeInSec = param1;
      }
   }
}

