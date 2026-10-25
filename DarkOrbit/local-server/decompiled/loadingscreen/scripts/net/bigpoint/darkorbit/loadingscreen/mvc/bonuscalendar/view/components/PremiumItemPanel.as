package net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.view.components
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Sine;
   import flash.display.Bitmap;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.model.AssetsProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.model.vo.ItemVO;
   import net.bigpoint.darkorbit.loadingscreen.utils.ImageUtils;
   import net.bigpoint.darkorbit.loadingscreen.utils.Styles;
   import net.bigpoint.darkorbit.loadingscreen.utils.TooltipControl;
   
   public class PremiumItemPanel extends Sprite
   {
      
      public static const WIDTH:uint = 545;
      
      public static const HEIGHT:uint = 194;
      
      public static const CONTENT_WIDTH:uint = 508;
      
      public static const CONTENT_HEIGHT:uint = 163;
      
      public static const SECOND_PREMIUM_IMG_OFFSET:uint = 320;
      
      public static const INDEX_NORMAL_COLOR:uint = 16434692;
      
      public static const INDEX_DISABLED_COLOR:uint = 14869218;
      
      private static var loadingFontHeight:int = 25;
      
      private static var loadingFmt:TextFormat = new TextFormat(Styles.boldFontName,loadingFontHeight,16763904);
      
      private static var premiumFontHeight:int = 12;
      
      private static var premiumFmt:TextFormat = new TextFormat(Styles.boldFontName,premiumFontHeight,16777215);
      
      private static var premiumInfoFmt:TextFormat = new TextFormat("Verdana",10,16777215);
      
      private static var premiumItemNameFmt:TextFormat = new TextFormat(Styles.boldFontName,15,16777215);
      
      private static const STATE_GLOW:String = "reward_glow";
      
      private static const STATE_GREY:String = "reward_grey";
      
      private static const STATE_YELLOW:String = "reward_yellow";
      
      private static const CHECK_MARK_BIG:String = "checkmark_big";
      
      private static var _headlineText:String = BPLocale.getItem("login_bonus_item_headline");
      
      private static var _shadowFilter:DropShadowFilter = new DropShadowFilter(4,90,0,0.6);
      
      loadingFmt.align = TextFormatAlign.LEFT;
      premiumFmt.align = TextFormatAlign.CENTER;
      premiumInfoFmt.align = TextFormatAlign.CENTER;
      premiumItemNameFmt.align = TextFormatAlign.CENTER;
      
      private var _uiLibrary:SWFFinisher;
      
      private var _rewardItemBgContainer:Sprite;
      
      private var _contentContainer:Sprite;
      
      private var _rewardsImagesContainer:Sprite;
      
      private var _infoButton:InfoButton;
      
      private var _buyButton:BuyButton;
      
      private var _premiumInfoText:TextField;
      
      private var _activate:Boolean;
      
      private var _data:Vector.<ItemVO>;
      
      private var _titleDayTextField:TextField;
      
      private var _titlePremiumTextField:TextField;
      
      private var _premiumItemNameTextField:TextField;
      
      public function PremiumItemPanel(param1:SWFFinisher, param2:Boolean)
      {
         super();
         this._uiLibrary = param1;
         this._activate = param2;
         this.createRewardItemBgContainer();
         this.createContentContainer();
         this.createBuyPremiumButton();
         this.createPremiumItemName();
         this.createDayLabel();
         this.createPremiumLabel();
         this.createInfoButton();
      }
      
      private function createRewardItemBgContainer() : void
      {
         this._rewardItemBgContainer = new Sprite();
         this.addChild(this._rewardItemBgContainer);
      }
      
      private function createContentContainer() : void
      {
         this._contentContainer = new Sprite();
         this._contentContainer.x = WIDTH - CONTENT_WIDTH >> 1;
         this._contentContainer.y = HEIGHT - CONTENT_HEIGHT >> 1;
         this._contentContainer.graphics.beginFill(0,0.1);
         this._contentContainer.graphics.drawRect(0,0,CONTENT_WIDTH,CONTENT_HEIGHT);
         this._contentContainer.graphics.endFill();
         addChild(this._contentContainer);
         this._rewardsImagesContainer = new Sprite();
         this._contentContainer.addChild(this._rewardsImagesContainer);
      }
      
      private function createDayLabel() : void
      {
         var _loc1_:Sprite = new Sprite();
         this._titleDayTextField = new TextField();
         this._titleDayTextField.defaultTextFormat = loadingFmt;
         this._titleDayTextField.embedFonts = true;
         this._titleDayTextField.width = 200;
         this._titleDayTextField.height = 32;
         this._titleDayTextField.border = false;
         this._titleDayTextField.selectable = false;
         _loc1_.addChild(this._titleDayTextField);
         _loc1_.y = 14;
         _loc1_.x = 21;
         addChild(_loc1_);
      }
      
      private function createPremiumLabel() : void
      {
         this._titlePremiumTextField = new TextField();
         this._titlePremiumTextField.defaultTextFormat = premiumFmt;
         this._titlePremiumTextField.multiline = true;
         this._titlePremiumTextField.wordWrap = true;
         this._titlePremiumTextField.embedFonts = true;
         this._titlePremiumTextField.width = 160;
         this._titlePremiumTextField.height = 60;
         this._titlePremiumTextField.border = false;
         this._titlePremiumTextField.selectable = false;
         this._titlePremiumTextField.text = BPLocale.getItem("login_bonus_item_headline_premium");
         this._titlePremiumTextField.x = 351;
         this._titlePremiumTextField.y = 25;
         addChild(this._titlePremiumTextField);
      }
      
      private function createPremiumItemName() : void
      {
         this._premiumItemNameTextField = new TextField();
         this._premiumItemNameTextField.defaultTextFormat = premiumItemNameFmt;
         this._premiumItemNameTextField.embedFonts = true;
         this._premiumItemNameTextField.width = 330;
         this._premiumItemNameTextField.height = 20;
         this._premiumItemNameTextField.border = false;
         this._premiumItemNameTextField.selectable = false;
         this._premiumItemNameTextField.x = 15;
         this._premiumItemNameTextField.y = 150;
         this._premiumItemNameTextField.filters = [_shadowFilter];
         addChild(this._premiumItemNameTextField);
      }
      
      private function createBuyPremiumButton() : void
      {
         this._premiumInfoText = new TextField();
         this._premiumInfoText.defaultTextFormat = premiumInfoFmt;
         this._premiumInfoText.embedFonts = false;
         this._premiumInfoText.width = 174;
         this._premiumInfoText.height = 40;
         this._premiumInfoText.border = false;
         this._premiumInfoText.selectable = false;
         this._premiumInfoText.multiline = true;
         this._premiumInfoText.wordWrap = true;
         this._premiumInfoText.y = 110;
         this._premiumInfoText.x = 330;
         this._contentContainer.addChild(this._premiumInfoText);
         this._buyButton = new BuyButton(this._uiLibrary);
         this._buyButton.x = CONTENT_WIDTH - (this._buyButton.width + 24);
         this._buyButton.y = 139;
         this._buyButton.visible = false;
         this._contentContainer.addChild(this._buyButton);
      }
      
      private function createInfoButton() : void
      {
         var _loc1_:String = null;
         this._infoButton = new InfoButton(this._uiLibrary,InfoButton.COLOR_STYLE_ORANGE);
         this._infoButton.x = 16 + CONTENT_WIDTH - this._infoButton.width;
         this._infoButton.y = -3;
         this._contentContainer.addChild(this._infoButton);
         if(this._activate)
         {
            _loc1_ = BPLocale.getItem("login_bonus_tooltip_info_premiumitem");
         }
         else
         {
            _loc1_ = BPLocale.getItem("login_bonus_tooltip_info_premiumitem_deactivated");
         }
         TooltipControl.getInstance().addToolTip(this._infoButton,_loc1_);
      }
      
      public function set data(param1:Vector.<ItemVO>) : void
      {
         this._data = param1;
         this.update();
      }
      
      private function update() : void
      {
         this._titleDayTextField.text = _headlineText.replace("%VALUE%",(this._data[0].index - 1).toString());
         var _loc1_:ItemVO = this._data[0];
         var _loc2_:ItemVO = this._data[1];
         var _loc3_:String = BPLocale.getItemInCategory("items","items_" + _loc2_.lootID + "_fullname");
         if(_loc2_.amount > 1)
         {
            _loc3_ = _loc2_.amount + "x " + _loc3_;
         }
         this._premiumInfoText.text = _loc3_;
         this.setPremiumItemName(_loc1_);
         this.createBgnd(_loc1_);
         var _loc4_:String = this.returnImagePath(_loc1_);
         AssetsProxy.loadResource(_loc4_,this.firstPremiumImageLoaded);
         _loc4_ = this.returnImagePath(_loc2_);
         AssetsProxy.loadResource(_loc4_,this.secondPremiumImageLoaded);
      }
      
      private function returnImagePath(param1:ItemVO) : String
      {
         return true ? param1.path : param1.fullPath;
      }
      
      private function setPremiumItemName(param1:ItemVO) : void
      {
         var _loc2_:String = null;
         if(this._premiumItemNameTextField != null)
         {
            _loc2_ = "items_" + param1.lootID + "_fullname";
            this._premiumItemNameTextField.text = BPLocale.getItemInCategory("items",_loc2_);
         }
      }
      
      private function createBgnd(param1:ItemVO) : void
      {
         if(param1.isBooked())
         {
            this.createGrayBgnd();
         }
         else
         {
            this.createGlowBgnd();
         }
      }
      
      private function createGrayBgnd() : void
      {
         this._titleDayTextField.textColor = INDEX_DISABLED_COLOR;
         var _loc1_:Bitmap = this._uiLibrary.getEmbeddedBitmap(STATE_GREY);
         this._rewardItemBgContainer.addChild(_loc1_);
      }
      
      private function createGlowBgnd() : void
      {
         this._titleDayTextField.textColor = INDEX_NORMAL_COLOR;
         var _loc1_:Bitmap = this._uiLibrary.getEmbeddedBitmap(STATE_GLOW);
         _loc1_.name = name;
         this._rewardItemBgContainer.addChild(_loc1_);
         var _loc2_:Bitmap = this._uiLibrary.getEmbeddedBitmap(STATE_YELLOW);
         this._rewardItemBgContainer.addChild(_loc2_);
      }
      
      private function firstPremiumImageLoaded(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         var _loc3_:Bitmap = Bitmap(_loc2_.content);
         this._rewardsImagesContainer.addChild(_loc3_);
         var _loc4_:ItemVO = this._data[0];
         if(_loc4_.isBooked())
         {
            ImageUtils.setGrayScale(_loc3_.bitmapData);
            this.addItemCollectedCheckMark(_loc4_,_loc3_);
         }
      }
      
      private function secondPremiumImageLoaded(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         var _loc3_:Bitmap = Bitmap(_loc2_.content);
         _loc3_.x += SECOND_PREMIUM_IMG_OFFSET;
         var _loc4_:ItemVO = this._data[0];
         var _loc5_:ItemVO = this._data[1];
         this._rewardsImagesContainer.addChild(_loc3_);
         this._buyButton.visible = !_loc5_.isPremium;
         if(_loc5_.isBooked())
         {
            ImageUtils.setGrayScale(_loc3_.bitmapData);
            this.addItemCollectedCheckMark(_loc5_,_loc3_);
            this._infoButton.setGrayScale();
         }
         else if(_loc4_.isBooked())
         {
            ImageUtils.setGrayScale(_loc3_.bitmapData);
         }
      }
      
      private function addItemCollectedCheckMark(param1:ItemVO, param2:Bitmap) : void
      {
         var _loc3_:Bitmap = this._uiLibrary.getEmbeddedBitmap(CHECK_MARK_BIG);
         _loc3_.x = param2.x + (param2.width >> 1) - (_loc3_.width >> 1);
         _loc3_.y = (param2.height >> 1) - (_loc3_.height >> 1);
         this._contentContainer.addChild(_loc3_);
      }
      
      public function showIt() : void
      {
         this.alpha = 0;
         var _loc1_:Number = this.y;
         this.y = _loc1_ + 40;
         TweenMax.to(this,0.4,{
            "y":_loc1_,
            "alpha":1,
            "ease":Sine.easeIn
         });
      }
      
      public function dispose() : void
      {
         this._infoButton.dispose();
         this._buyButton.dispose();
         this._uiLibrary = null;
      }
   }
}

