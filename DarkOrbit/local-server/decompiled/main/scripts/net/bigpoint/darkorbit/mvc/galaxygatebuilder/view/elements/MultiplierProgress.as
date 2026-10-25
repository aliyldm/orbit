package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.elements
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   
   public class MultiplierProgress extends Sprite
   {
      
      private static const MAX_WIDTH:int = 148;
      
      private var labels:Array = [];
      
      private var bar:Sprite;
      
      public function MultiplierProgress()
      {
         super();
         var _loc1_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         var _loc2_:SWFFinisher = SWFFinisher(_loc1_.getLib("common"));
         this.bar = new Sprite();
         var _loc3_:Bitmap = _loc2_.getEmbeddedBitmap("multiplier_progressBar_bg");
         this.bar.addChild(_loc3_);
         var _loc4_:GlowFilter = new GlowFilter(11857657);
         _loc4_.alpha = 0.65;
         _loc4_.blurX = 7;
         _loc4_.blurY = 7;
         _loc4_.strength = 2.8;
         _loc4_.quality = BitmapFilterQuality.HIGH;
         _loc4_.inner = false;
         _loc4_.knockout = false;
         this.bar.filters = [_loc4_];
         this.bar.x = 0;
         this.bar.y = 17;
         this.bar.scaleX = 0;
         addChild(this.bar);
      }
      
      public function init(param1:int) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:TextField = null;
         _loc3_ = 1;
         while(_loc3_ <= param1)
         {
            _loc4_ = this.getMultiplierLight(_loc3_);
            if(_loc3_ == 1)
            {
               _loc4_.x = 0;
            }
            else if(_loc3_ < param1)
            {
               _loc2_ = (MAX_WIDTH - _loc4_.width) / (param1 - 1);
               _loc4_.x = (_loc3_ - 1) * _loc2_;
            }
            else
            {
               _loc4_.x = MAX_WIDTH - _loc4_.width;
            }
            addChild(_loc4_);
            this.labels[_loc3_] = _loc4_;
            _loc3_++;
         }
      }
      
      private function getMultiplierLight(param1:int) : TextField
      {
         var _loc2_:TextField = new TextField();
         _loc2_.defaultTextFormat = Styles.strongStdFmt;
         _loc2_.embedFonts = Styles.strongStdEmbed;
         _loc2_.selectable = false;
         _loc2_.text = "x" + String(param1 + 1);
         _loc2_.autoSize = TextFieldAutoSize.CENTER;
         return _loc2_;
      }
      
      public function setValue(param1:int) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:TextField = null;
         this.bar.scaleX = 0;
         var _loc4_:GlowFilter = new GlowFilter(43263);
         _loc4_.alpha = 0.8;
         _loc4_.blurX = 6;
         _loc4_.blurY = 6;
         _loc4_.strength = 2;
         _loc4_.quality = BitmapFilterQuality.HIGH;
         _loc4_.inner = false;
         _loc4_.knockout = false;
         var _loc5_:int = 1;
         while(_loc5_ < this.labels.length)
         {
            _loc3_ = this.labels[_loc5_] as TextField;
            if(_loc5_ == param1)
            {
               _loc3_.textColor = 13824255;
               _loc3_.filters = [_loc4_];
               _loc2_ = (_loc3_.x + _loc3_.width / 2) / MAX_WIDTH;
               if(_loc5_ == this.labels.length - 1)
               {
                  _loc2_ = 1;
               }
               this.bar.scaleX = _loc2_;
            }
            else
            {
               _loc3_.textColor = 0;
               _loc3_.filters = [];
            }
            _loc5_++;
         }
      }
   }
}

