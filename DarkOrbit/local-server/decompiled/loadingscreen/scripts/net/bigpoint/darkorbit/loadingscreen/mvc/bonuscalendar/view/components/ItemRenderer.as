package net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.view.components
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.display.Loader;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.model.vo.ItemVO;
   import net.bigpoint.darkorbit.loadingscreen.utils.ImageUtils;
   import net.bigpoint.darkorbit.loadingscreen.utils.Styles;
   import net.bigpoint.darkorbit.loadingscreen.utils.TooltipControl;
   
   public class ItemRenderer extends Sprite
   {
      
      public static const EVENT_IMAGE_LOADED:String = "imageLoaded";
      
      public static const WIDTH:uint = 83;
      
      public static const HEIGHT:uint = 120;
      
      public static const BOOSTER_PREFIX:String = "booster";
      
      private static var loadingFontHeight:int = 9;
      
      private static var loadingFmt:TextFormat = new TextFormat("Verdana",loadingFontHeight,16777215);
      
      private static var dayFontHeight:int = 12;
      
      private static var dayFmt:TextFormat = new TextFormat(Styles.boldFontName,dayFontHeight,16434692);
      
      private static const BG_NORMAL:String = "daily_login_bonus_itembg_normal";
      
      private static const BG_ACTIVE:String = "daily_login_bonus_itembg_active";
      
      private static const BG_GREY:String = "daily_login_bonus_itembg_grey";
      
      private static const BG_YELLOW_NORMAL:String = "daily_login_bonus_itembg_yellow_normal";
      
      private static const BG_YELLOW_ACTIVE:String = "daily_login_bonus_itembg_yellow_active";
      
      private static const CHECK_MARK:String = "checkmark_small";
      
      private static const CHECK_MARK_WHITE:String = "checkmark_small_white";
      
      private static var _headlineText:String = BPLocale.getItem("login_bonus_item_headline");
      
      loadingFmt.align = TextFormatAlign.CENTER;
      dayFmt.align = TextFormatAlign.LEFT;
      
      private var _data:ItemVO;
      
      private var _animContainer:Sprite;
      
      private var _titleTextField:TextField;
      
      private var _amountTextField:TextField;
      
      private var _uiLibrary:SWFFinisher;
      
      private var _imageContainer:Sprite = new Sprite();
      
      private var _imageLoader:Loader;
      
      public function ItemRenderer(param1:ItemVO, param2:SWFFinisher)
      {
         super();
         this._data = param1;
         this._uiLibrary = param2;
         this.name = param1.index + "_" + param1.lootID;
         this.initComponents();
      }
      
      private function initComponents() : void
      {
         this._animContainer = new Sprite();
         this._animContainer.y = 80;
         this._animContainer.alpha = 0;
         addChild(this._animContainer);
         this.drawBackground();
         this.addImageContainer();
         this.createTextField();
         this.createAmountField();
      }
      
      private function drawBackground() : void
      {
         var _loc1_:Graphics = this._animContainer.graphics;
         _loc1_.beginFill(0,0);
         _loc1_.drawRect(0,0,WIDTH,HEIGHT);
         _loc1_.endFill();
         this.addLayer(BG_NORMAL);
         this.addLayer(BG_ACTIVE);
         this.addLayer(BG_GREY);
         this.addLayer(BG_YELLOW_NORMAL);
         this.addLayer(BG_YELLOW_ACTIVE);
      }
      
      private function addImageContainer() : void
      {
         this._imageContainer = new Sprite();
         this._animContainer.addChild(this._imageContainer);
      }
      
      private function addLayer(param1:String) : void
      {
         var _loc2_:Bitmap = this._uiLibrary.getEmbeddedBitmap(param1);
         _loc2_.name = param1;
         _loc2_.visible = false;
         this._animContainer.addChild(_loc2_);
      }
      
      private function getLayer(param1:String) : Bitmap
      {
         return this._animContainer.getChildByName(param1) as Bitmap;
      }
      
      private function createAmountField() : void
      {
         this._amountTextField = new TextField();
         this._amountTextField.defaultTextFormat = loadingFmt;
         this._amountTextField.embedFonts = false;
         this._amountTextField.width = WIDTH - 24;
         this._amountTextField.height = 17;
         this._amountTextField.selectable = false;
         this._amountTextField.y = HEIGHT - 30;
         this._amountTextField.x = 11;
         this._animContainer.addChild(this._amountTextField);
      }
      
      private function createTextField() : void
      {
         this._titleTextField = new TextField();
         this._titleTextField.defaultTextFormat = dayFmt;
         this._titleTextField.embedFonts = true;
         this._titleTextField.width = WIDTH - 24;
         this._titleTextField.height = 18;
         this._titleTextField.y = 12;
         this._titleTextField.x = 14;
         this._titleTextField.selectable = false;
         this._animContainer.addChild(this._titleTextField);
      }
      
      public function set data(param1:ItemVO) : void
      {
         var _loc2_:String = null;
         var _loc3_:Bitmap = null;
         var _loc4_:String = null;
         var _loc5_:URLRequest = null;
         if(param1)
         {
            this._titleTextField.text = _headlineText.replace("%VALUE%",param1.index.toString());
            if(param1.lootID.substr(0,BOOSTER_PREFIX.length) == BOOSTER_PREFIX)
            {
               this._amountTextField.text = param1.amount.toString() + BPLocale.getItem("login_booster_time_info");
            }
            else
            {
               this._amountTextField.text = BPLocale.getItem("login_reward_amount_info").replace("%VALUE%",param1.amount.toString());
            }
            _loc2_ = BPLocale.getItemInCategory("items","items_" + param1.lootID + "_fullname");
            TooltipControl.getInstance().addToolTip(this,_loc2_);
            if(param1.isActive())
            {
               if(param1.isSpecial())
               {
                  this.getLayer(BG_YELLOW_ACTIVE).visible = true;
                  this._titleTextField.textColor = 8226900;
               }
               else
               {
                  this.getLayer(BG_ACTIVE).visible = true;
                  this._titleTextField.textColor = 6403275;
               }
               _loc3_ = this._uiLibrary.getEmbeddedBitmap(CHECK_MARK_WHITE);
               _loc3_.x = WIDTH - _loc3_.width >> 1;
               _loc3_.y = HEIGHT - _loc3_.height >> 1;
               _loc3_.alpha = 0.9;
               this._animContainer.addChild(_loc3_);
            }
            else if(param1.isBooked())
            {
               this._titleTextField.textColor = 12566463;
               this._amountTextField.textColor = 12566463;
               this.alpha = 0.5;
               _loc3_ = this._uiLibrary.getEmbeddedBitmap(CHECK_MARK);
               _loc3_.x = WIDTH - _loc3_.width >> 1;
               _loc3_.y = HEIGHT - _loc3_.height >> 1;
               this._animContainer.addChild(_loc3_);
               if(param1.isSpecial())
               {
                  this.getLayer(BG_YELLOW_NORMAL).visible = true;
               }
               else
               {
                  this.getLayer(BG_GREY).visible = true;
               }
            }
            else if(param1.isSpecial())
            {
               this._titleTextField.textColor = 8226900;
               this.getLayer(BG_YELLOW_NORMAL).visible = true;
            }
            else
            {
               this._titleTextField.textColor = 6403275;
               this.getLayer(BG_NORMAL).visible = true;
            }
            _loc4_ = true ? param1.path : param1.fullPath;
            if(_loc4_ != null)
            {
               _loc5_ = new URLRequest(_loc4_);
               this._imageLoader = new Loader();
               this._imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.handleImageLoaded);
               this._imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.handleImageIOError);
               this._imageLoader.load(_loc5_);
            }
         }
      }
      
      public function showIt() : void
      {
         TweenMax.to(this._animContainer,0.3,{
            "y":0,
            "delay":this._data.index * 0.03,
            "alpha":1,
            "ease":Back.easeOut
         });
      }
      
      private function handleImageLoaded(param1:Event) : void
      {
         this._imageLoader.scaleX = 0.6;
         this._imageLoader.scaleY = 0.6;
         this._imageContainer.addChild(this._imageLoader);
         this._imageContainer.x = 1 + (WIDTH - this._imageLoader.width) >> 1;
         this._imageContainer.y = HEIGHT - this._imageLoader.height >> 1;
         (this._imageLoader.content as Bitmap).smoothing = true;
         (this._imageLoader.content as Bitmap).pixelSnapping = PixelSnapping.ALWAYS;
         if(this._data.isBooked())
         {
            ImageUtils.setGrayScale(Bitmap(this._imageLoader.content).bitmapData);
         }
         else if(this._data.isActive())
         {
            this._imageContainer.alpha = 0.5;
         }
         dispatchEvent(new Event(EVENT_IMAGE_LOADED));
      }
      
      private function handleImageIOError(param1:IOErrorEvent) : void
      {
         dispatchEvent(new Event(EVENT_IMAGE_LOADED));
      }
   }
}

