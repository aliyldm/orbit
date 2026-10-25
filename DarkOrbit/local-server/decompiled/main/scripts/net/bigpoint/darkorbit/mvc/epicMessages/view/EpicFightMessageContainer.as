package net.bigpoint.darkorbit.mvc.epicMessages.view
{
   import com.greensock.TimelineMax;
   import com.greensock.TweenLite;
   import com.greensock.easing.Back;
   import flash.display.BlendMode;
   import flash.display.GradientType;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Styles;
   
   public class EpicFightMessageContainer extends Sprite
   {
      
      private static const FILTER:Array = [new GlowFilter(16763904,1,3,3,10,3)];
      
      private var _messageTF:TextField;
      
      private var _gradient:Shape = new Shape();
      
      private var _showTimeLine:TimelineMax;
      
      public function EpicFightMessageContainer()
      {
         super();
         visible = false;
         mouseChildren = mouseEnabled = false;
      }
      
      private function setup() : void
      {
         this._messageTF = new TextField();
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.font = Styles.corporateFontExt;
         _loc1_.bold = _loc1_.italic = true;
         _loc1_.color = 16763904;
         _loc1_.size = 72;
         this._messageTF.embedFonts = Styles.systemSplashEmbed;
         this._messageTF.defaultTextFormat = _loc1_;
         this._messageTF.antiAliasType = AntiAliasType.ADVANCED;
         this._messageTF.autoSize = TextFieldAutoSize.LEFT;
         this._messageTF.blendMode = BlendMode.ALPHA;
         this._messageTF.selectable = false;
         var _loc2_:Matrix = new Matrix();
         _loc2_.createGradientBox(800,100,Math.PI * 0.5);
         this._gradient.graphics.beginGradientFill(GradientType.LINEAR,[16772459,16213011],[1,1],[0,255],_loc2_);
         this._gradient.graphics.drawRect(0,0,1,100);
         this._gradient.blendMode = BlendMode.LAYER;
         filters = FILTER;
         addChild(this._gradient);
         addChild(this._messageTF);
         cacheAsBitmap = true;
         this._showTimeLine = new TimelineMax();
         this._showTimeLine.append(TweenLite.to(this,0.3,{"glowFilter":{
            "blurX":30,
            "blurY":30,
            "strength":0.1
         }}));
      }
      
      public function updateDisplayedText(param1:String) : void
      {
         if(!this._messageTF)
         {
            this.setup();
         }
         TweenLite.killTweensOf(this,true,{
            "autoAlpha":true,
            "transformAroundCenter":true,
            "scaleX":true,
            "scaleY":true
         });
         this._messageTF.text = param1;
         this._gradient.width = this._messageTF.width;
         this._gradient.height = this._messageTF.height;
         scaleX = scaleY = 1;
         TweenLite.to(this,0.3,{"autoAlpha":1});
         this._showTimeLine.restart();
      }
      
      public function hideMessage() : void
      {
         if(parent)
         {
            if(!this._messageTF)
            {
               this.setup();
            }
            TweenLite.to(this,0.5,{
               "autoAlpha":0,
               "transformAroundCenter":{
                  "scaleX":3,
                  "scaleY":3
               },
               "ease":Back.easeInOut
            });
         }
      }
   }
}

