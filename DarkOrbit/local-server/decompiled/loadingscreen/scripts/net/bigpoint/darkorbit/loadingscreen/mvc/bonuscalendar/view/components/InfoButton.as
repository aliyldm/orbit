package net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.view.components
{
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.loadingscreen.utils.ImageUtils;
   
   public class InfoButton extends Sprite
   {
      
      public static const WIDTH:uint = 52;
      
      public static const HEIGHT:uint = 52;
      
      public static const COLOR_STYLE_BLUE:String = "blue";
      
      public static const COLOR_STYLE_ORANGE:String = "orange";
      
      private static const STATE_NORMAL:String = "daily_login_bonus_infobutton_normal";
      
      private static const STATE_OVER:String = "daily_login_bonus_infobutton_hover";
      
      private static const STATE_NORMAL_ORANGE:String = "daily_login_bonus_infobutton_orange_normal";
      
      private static const STATE_OVER_ORANGE:String = "daily_login_bonus_infobutton_orange_hover";
      
      private var _skin_Over:String;
      
      private var _skin_Normal:String;
      
      private var _uiLibrary:SWFFinisher;
      
      private var _hitLayer:Sprite;
      
      public function InfoButton(param1:SWFFinisher, param2:String)
      {
         super();
         this._uiLibrary = param1;
         this.assignStates(param2);
         this.addEventListeners();
         this.getChildByName(this._skin_Normal).visible = true;
      }
      
      private function addEventListeners() : void
      {
         this._hitLayer = new Sprite();
         var _loc1_:Graphics = this._hitLayer.graphics;
         _loc1_.beginFill(0,0);
         _loc1_.moveTo(0,0);
         _loc1_.lineTo(WIDTH,0);
         _loc1_.lineTo(WIDTH,HEIGHT);
         _loc1_.endFill();
         this.addChild(this._hitLayer);
         this._hitLayer.addEventListener(MouseEvent.ROLL_OVER,this.handleRollOverEvent);
         this._hitLayer.addEventListener(MouseEvent.ROLL_OUT,this.handleRollOutEvent);
      }
      
      private function removeEventListeners() : void
      {
         this._hitLayer.removeEventListener(MouseEvent.ROLL_OVER,this.handleRollOverEvent);
         this._hitLayer.removeEventListener(MouseEvent.ROLL_OUT,this.handleRollOutEvent);
         this._hitLayer = null;
      }
      
      private function handleRollOutEvent(param1:MouseEvent) : void
      {
         TweenMax.to(this.getChildByName(this._skin_Normal),0.4,{"autoAlpha":1});
         TweenMax.to(this.getChildByName(this._skin_Over),0.35,{"autoAlpha":0});
      }
      
      private function handleRollOverEvent(param1:MouseEvent) : void
      {
         TweenMax.to(this.getChildByName(this._skin_Normal),0.35,{"autoAlpha":0});
         TweenMax.to(this.getChildByName(this._skin_Over),0.4,{"autoAlpha":1});
      }
      
      private function assignStates(param1:String) : void
      {
         switch(param1)
         {
            case COLOR_STYLE_BLUE:
               this._skin_Over = STATE_OVER;
               this._skin_Normal = STATE_NORMAL;
               this.addLayer(STATE_NORMAL);
               this.addLayer(STATE_OVER);
               break;
            case COLOR_STYLE_ORANGE:
               this._skin_Over = STATE_OVER_ORANGE;
               this._skin_Normal = STATE_NORMAL_ORANGE;
               this.addLayer(STATE_NORMAL_ORANGE);
               this.addLayer(STATE_OVER_ORANGE);
         }
      }
      
      private function addLayer(param1:String) : void
      {
         var _loc2_:Bitmap = this._uiLibrary.getEmbeddedBitmap(param1);
         _loc2_.name = param1;
         _loc2_.visible = false;
         this.addChild(_loc2_);
      }
      
      public function setGrayScale() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.numChildren)
         {
            _loc1_ = this.getChildAt(_loc2_);
            if(_loc1_ is Bitmap)
            {
               ImageUtils.setGrayScale(Bitmap(_loc1_).bitmapData);
            }
            _loc2_++;
         }
      }
      
      public function dispose() : void
      {
         this.removeEventListeners();
         this._uiLibrary = null;
      }
   }
}

