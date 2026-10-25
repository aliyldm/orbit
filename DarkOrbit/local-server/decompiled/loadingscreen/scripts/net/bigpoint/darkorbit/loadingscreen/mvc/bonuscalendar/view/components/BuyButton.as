package net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.view.components
{
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.BpEventStreamUtil;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.model.JavascriptProxy;
   import net.bigpoint.darkorbit.loadingscreen.utils.Styles;
   
   public class BuyButton extends Sprite
   {
      
      public static const WIDTH:uint = 130;
      
      public static const HEIGHT:uint = 15;
      
      private static const STATE_NORMAL:String = "btn_buy_premium_normal";
      
      private static const STATE_ACTIVE:String = "btn_buy_premium_active";
      
      private static const STATE_DISABLED:String = "btn_buy_premium_disabled";
      
      private static const NORMAL_COLOR:uint = 4641531;
      
      private static const HOVER_COLOR:uint = 4641531;
      
      private static const ACTIVE_COLOR:uint = 15327936;
      
      private static const DISABLED_COLOR:uint = 8355711;
      
      private static const STATE_HOVER:String = "btn_buy_premium_hover";
      
      private static var dayFontHeight:int = 10;
      
      private static var dayFmt:TextFormat = new TextFormat(Styles.boldFontName,dayFontHeight,NORMAL_COLOR);
      
      dayFmt.align = TextFormatAlign.CENTER;
      
      private var _uiLibrary:SWFFinisher;
      
      private var _hitLayer:Sprite;
      
      private var _titleTextField:TextField;
      
      public function BuyButton(param1:SWFFinisher)
      {
         super();
         this._uiLibrary = param1;
         this.addLayer(STATE_NORMAL);
         this.addLayer(STATE_DISABLED);
         this.addLayer(STATE_ACTIVE);
         this.addLayer(STATE_HOVER);
         this.createTextField();
         this.setEnabled(true);
         this.addLoaderEventListeners();
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         if(param1)
         {
            this.addLoaderEventListeners();
            this.getChildByName(STATE_NORMAL).visible = true;
            this.getChildByName(STATE_ACTIVE).visible = false;
            this.getChildByName(STATE_HOVER).visible = false;
            this.getChildByName(STATE_DISABLED).visible = false;
         }
         else
         {
            this.removeEventListeners();
            this.getChildByName(STATE_NORMAL).visible = false;
            this.getChildByName(STATE_ACTIVE).visible = false;
            this.getChildByName(STATE_HOVER).visible = false;
            this.getChildByName(STATE_DISABLED).visible = true;
         }
      }
      
      public function dispose() : void
      {
         this.removeEventListeners();
         this._uiLibrary = null;
      }
      
      private function createTextField() : void
      {
         this._titleTextField = new TextField();
         this._titleTextField.defaultTextFormat = dayFmt;
         this._titleTextField.embedFonts = true;
         this._titleTextField.height = HEIGHT;
         this._titleTextField.width = WIDTH;
         this._titleTextField.selectable = false;
         addChild(this._titleTextField);
         this._titleTextField.text = BPLocale.getItem("login_bonus_item_premium_buybutton");
      }
      
      private function addLoaderEventListeners() : void
      {
         var _loc1_:Graphics = null;
         if(this._hitLayer == null)
         {
            this._hitLayer = new Sprite();
            _loc1_ = this._hitLayer.graphics;
            _loc1_.beginFill(0,0);
            _loc1_.drawRect(0,0,WIDTH,HEIGHT);
            _loc1_.endFill();
            this.addChild(this._hitLayer);
         }
         this._hitLayer.addEventListener(MouseEvent.ROLL_OVER,this.handleRollOverEvent);
         this._hitLayer.addEventListener(MouseEvent.ROLL_OUT,this.handleRollOutEvent);
         this._hitLayer.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseEventDown);
         this._hitLayer.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseEventUp);
      }
      
      private function removeEventListeners() : void
      {
         if(this._hitLayer)
         {
            this._hitLayer.removeEventListener(MouseEvent.ROLL_OVER,this.handleRollOverEvent);
            this._hitLayer.removeEventListener(MouseEvent.ROLL_OUT,this.handleRollOutEvent);
            this._hitLayer.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseEventDown);
            this._hitLayer.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseEventUp);
         }
      }
      
      private function addLayer(param1:String) : void
      {
         var _loc2_:Bitmap = this._uiLibrary.getEmbeddedBitmap(param1);
         _loc2_.name = param1;
         _loc2_.visible = false;
         this.addChild(_loc2_);
      }
      
      private function handleRollOutEvent(param1:MouseEvent) : void
      {
         TweenMax.to(this.getChildByName(STATE_NORMAL),0.3,{"autoAlpha":1});
         TweenMax.to(this.getChildByName(STATE_HOVER),0.15,{"autoAlpha":0});
         this._titleTextField.textColor = NORMAL_COLOR;
      }
      
      private function handleRollOverEvent(param1:MouseEvent) : void
      {
         TweenMax.to(this.getChildByName(STATE_NORMAL),0.15,{"autoAlpha":0});
         TweenMax.to(this.getChildByName(STATE_HOVER),0.3,{"autoAlpha":1});
         this._titleTextField.textColor = HOVER_COLOR;
      }
      
      private function handleMouseEventDown(param1:MouseEvent) : void
      {
         this._titleTextField.textColor = ACTIVE_COLOR;
      }
      
      private function handleMouseEventUp(param1:MouseEvent) : void
      {
         this._titleTextField.textColor = NORMAL_COLOR;
         BpEventStreamUtil.rawTrack("button_clicked",{
            "button_id":"buy_premium",
            "element_id":"flash_loadingscreen"
         });
         JavascriptProxy.call("openPaymentFromExternal",["premium"]);
      }
   }
}

