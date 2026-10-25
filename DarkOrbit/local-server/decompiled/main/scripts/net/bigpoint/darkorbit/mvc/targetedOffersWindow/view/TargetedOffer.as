package net.bigpoint.darkorbit.mvc.targetedOffersWindow.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.delete_in_eic.IItemInfo;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.text.label.LabelSkin;
   import net.bigpoint.darkorbit.fui.components.video.VideoPlayer;
   import net.bigpoint.darkorbit.mvc.targetedOffersWindow.controller.TargetedOfferEvent;
   
   public class TargetedOffer extends Sprite
   {
      
      private var _mainContainer:Coreponent;
      
      private var _backgroundContainer:Coreponent;
      
      private var _videoContainer:Coreponent;
      
      private var _itemListContainer:Coreponent;
      
      private var _percentageText:Coreponent;
      
      private var _amountTextContainer:Coreponent;
      
      private var _buyButton:Button;
      
      private var _video2:VideoPlayer;
      
      private var _video1:VideoPlayer;
      
      private var _currentVideo:VideoPlayer;
      
      private var _currentReward:IItemInfo;
      
      private var _percentage:int;
      
      private var _urlList:Array;
      
      private var _rewards:Array;
      
      private var _currentVideoNr:Number;
      
      private var _offerKey:String;
      
      private var _price:String;
      
      private var _glow:GlowFilter;
      
      private var _ds:DropShadowFilter;
      
      private var _hoverImg:DisplayObject;
      
      public function TargetedOffer(param1:String, param2:int, param3:String)
      {
         super();
         this._offerKey = param1;
         this._percentage = param2;
         this._price = param3;
         this._urlList = new Array();
         this._currentVideoNr = 0;
         this._rewards = new Array();
         this.alpha = 0;
      }
      
      public function handleWindowContentCreated() : void
      {
         this._mainContainer = this.getChildByName("windowContainer") as Coreponent;
         this._backgroundContainer = this._mainContainer.getChildByName("imageBackgroundContainer") as Coreponent;
         this._videoContainer = this._mainContainer.getChildByName("videoContainer") as Coreponent;
         this._videoContainer.addEventListener(MouseEvent.CLICK,this.offerClickedHandler);
         this._video1 = this._videoContainer.getChildByName("videoplayer") as VideoPlayer;
         this._video1.addEventListener(MouseEvent.CLICK,this.offerClickedHandler);
         this._video1.filters = [new GlowFilter(15637065),new DropShadowFilter(3,45,15637065)];
         this._video2 = this._videoContainer.getChildByName("videoplayer2") as VideoPlayer;
         this._video2.addEventListener(MouseEvent.CLICK,this.offerClickedHandler);
         this._video2.filters = [new GlowFilter(15637065),new DropShadowFilter(3,45,15637065)];
         this._currentVideo = this._video1;
         this._currentVideo = this._video1;
         this._itemListContainer = this._mainContainer.getChildByName("itemListContainer") as Coreponent;
         this._percentageText = this._videoContainer.getChildByName("percentageTextContainer") as Coreponent;
         this._amountTextContainer = this._videoContainer.getChildByName("amountTextContainer") as Coreponent;
         this._buyButton = this._mainContainer.getChildByName("buy_button") as Button;
         this._buyButton.addEventListener(MouseEvent.CLICK,this.offerClickedHandler);
         this._buyButton.buttonMode = true;
         var _loc1_:Label = this._mainContainer.getChildByName("label_topText") as Label;
         var _loc2_:Label = this._mainContainer.getChildByName("label_price") as Label;
         _loc1_.text = _loc1_.text.toUpperCase();
         this._glow = new GlowFilter(16733184,0.6,15,15,1,3);
         this._ds = new DropShadowFilter(1,45,16733184);
         (_loc2_.skin as LabelSkin).textField.filters = [this._glow,this._ds];
         (_loc1_.skin as LabelSkin).textField.filters = [this._glow,this._ds];
         dispatchEvent(new TargetedOfferEvent(TargetedOfferEvent.OFFER_COREPONENTS_CREATED));
      }
      
      private function playVideo(param1:String) : void
      {
         this._currentVideo.playURL(param1);
         this._currentVideo.addEventListener(Event.ENTER_FRAME,this.handleVideoUpdate);
         this._currentVideo.addEventListener(VideoPlayer.STREAM_RESTARTED,this.handleVideoRestarted);
      }
      
      private function handleVideoRestarted(param1:Event) : void
      {
         this._currentVideo.removeEventListener(Event.ENTER_FRAME,this.handleVideoUpdate);
         this._currentVideo.removeEventListener(VideoPlayer.STREAM_RESTARTED,this.handleVideoRestarted);
         this._currentVideo.stop();
         this._currentVideo.alpha = 0;
         this._currentVideo = this._currentVideo == this._video1 ? this._video2 : this._video1;
         this.playNextVideo();
      }
      
      private function handleVideoUpdate(param1:Event) : void
      {
         this._currentVideo.alpha = 1 - Math.pow(this._currentVideo.playbackProgressPercentage - 0.5,2) * 5;
         this._amountTextContainer.alpha = this._currentVideo.alpha;
         this._amountTextContainer.alpha = this._currentVideo.alpha;
      }
      
      private function get nextVideoNr() : int
      {
         var _loc1_:int = this._currentVideoNr;
         ++this._currentVideoNr;
         if(this._currentVideoNr > this._urlList.length - 1)
         {
            this._currentVideoNr = 0;
         }
         return _loc1_;
      }
      
      private function playNextVideo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(this._urlList)
         {
            _loc1_ = this.nextVideoNr;
            _loc2_ = this._urlList[_loc1_];
            this.playVideo(_loc2_);
         }
         if(this._rewards)
         {
            this._currentReward = this._rewards[_loc1_] as IItemInfo;
            this.addAmountText();
         }
      }
      
      public function setUrlList(param1:Array) : void
      {
         this._urlList = param1;
      }
      
      public function setRewards(param1:Array) : void
      {
         this._rewards = param1;
      }
      
      private function offerClickedHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new TargetedOfferEvent(TargetedOfferEvent.OFFER_ACCEPTED));
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         if(this._hoverImg != null)
         {
            TweenLite.to(this._hoverImg,0.1,{"alpha":1});
         }
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         if(this._hoverImg != null)
         {
            TweenLite.to(this._hoverImg,0.1,{"alpha":0});
         }
      }
      
      public function createOffer(param1:ImageFinisher = null) : void
      {
         if(param1)
         {
            this.addBackgroundImage(param1.getBitmap());
         }
         this.addPercentText();
         this.addListOfItems();
         this.addPrice();
         dispatchEvent(new TargetedOfferEvent(TargetedOfferEvent.OFFER_CREATED));
         TweenLite.to(this,1,{"alpha":1});
         this.playNextVideo();
      }
      
      public function addHoverImage(param1:ImageFinisher = null) : void
      {
         this._hoverImg = param1.getBitmap();
         this._backgroundContainer.addChild(this._hoverImg);
         this._hoverImg.alpha = 0;
         TweenMax.to(this._hoverImg,1,{
            "alpha":1,
            "yoyo":true,
            "repeat":-1
         });
      }
      
      public function addBackgroundImage(param1:DisplayObject) : void
      {
         this._backgroundContainer.addChild(param1);
         param1.cacheAsBitmap = true;
         dispatchEvent(new TargetedOfferEvent(TargetedOfferEvent.OFFER_BG_ADDED));
      }
      
      private function addPercentText() : void
      {
         if(this._percentage <= 0)
         {
            return;
         }
         var _loc1_:String = "-" + this._percentage + "%\n";
         var _loc2_:GlowFilter = new GlowFilter(16771584,0.5,1,1,1,3);
         var _loc3_:DropShadowFilter = new DropShadowFilter(4,45,5046272,1,4,4,1,3);
         var _loc4_:TextFormat = new TextFormat(Styles.corporateFontExt,Styles.strongStdFontHeight);
         _loc4_.align = TextFormatAlign.RIGHT;
         _loc4_.color = 16761344;
         _loc4_.leading = 1;
         _loc4_.size = 36;
         var _loc5_:TextField = new TextField();
         _loc5_.mouseEnabled = false;
         _loc5_.selectable = false;
         _loc5_.antiAliasType = AntiAliasType.ADVANCED;
         _loc5_.height = 5;
         _loc5_.width = this._percentageText.width;
         _loc5_.embedFonts = Styles.plainStdEmbed;
         _loc5_.defaultTextFormat = _loc4_;
         _loc5_.filters = [_loc2_,_loc3_];
         _loc5_.multiline = true;
         _loc5_.wordWrap = true;
         _loc5_.text = _loc1_;
         _loc5_.autoSize = TextFieldAutoSize.LEFT;
         _loc5_.rotation = -15;
         _loc5_.alpha = 0;
         this._percentageText.addChild(_loc5_);
         TweenLite.to(_loc5_,0.25,{
            "alpha":1,
            "delay":0.5
         });
      }
      
      private function addPrice() : void
      {
         var _loc1_:Label = this._mainContainer.getChildByName("label_price") as Label;
         if(this._price)
         {
            _loc1_.text = this._price;
         }
         else
         {
            _loc1_.text = "";
         }
      }
      
      private function addAmountText() : void
      {
         while(this._amountTextContainer.numChildren > 0)
         {
            this._amountTextContainer.removeChildAt(0);
         }
         var _loc1_:DropShadowFilter = new DropShadowFilter(4,45,1708039);
         if(this._currentReward == null || this._currentReward.amount <= 1)
         {
            return;
         }
         var _loc2_:String = "x" + TextFormatter.AbbreviationReplacement(this._currentReward.amount);
         var _loc3_:TextFormat = new TextFormat(Styles.corporateFontExt,Styles.strongStdFontHeight);
         _loc3_.align = TextFormatAlign.RIGHT;
         _loc3_.color = 16643792;
         _loc3_.leading = 1;
         _loc3_.size = 24;
         var _loc4_:TextField = new TextField();
         _loc4_.mouseEnabled = false;
         _loc4_.selectable = false;
         _loc4_.antiAliasType = AntiAliasType.ADVANCED;
         _loc4_.height = 5;
         _loc4_.width = this._amountTextContainer.width;
         _loc4_.embedFonts = Styles.plainStdEmbed;
         _loc4_.defaultTextFormat = _loc3_;
         _loc4_.multiline = true;
         _loc4_.wordWrap = true;
         _loc4_.text = _loc2_;
         _loc4_.autoSize = TextFieldAutoSize.LEFT;
         _loc4_.rotation = -15;
         _loc4_.filters = [_loc1_];
         _loc4_.alpha = 1;
         this._amountTextContainer.addChild(_loc4_);
         TweenLite.to(_loc4_,0.25,{
            "alpha":1,
            "delay":0.5
         });
      }
      
      private function addListOfItems() : void
      {
         var _loc6_:int = 0;
         var _loc1_:String = "";
         var _loc2_:int = int(this._rewards.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc6_ = (this._rewards[_loc3_] as IItemInfo).amount;
            _loc1_ += "- " + (_loc6_ > 1 ? _loc6_ + "x " : "") + BPLocale.getItemInCategory("items","items_" + (this._rewards[_loc3_] as IItemInfo).lootID + "_fullname") + "\n";
            _loc3_++;
         }
         var _loc4_:TextFormat = new TextFormat(Styles.corporateFontRegular,Styles.plainStdFontHeight);
         _loc4_.align = TextFormatAlign.LEFT;
         _loc4_.color = 16711422;
         _loc4_.leading = 1;
         _loc4_.size = 14;
         var _loc5_:TextField = new TextField();
         _loc5_.mouseEnabled = false;
         _loc5_.selectable = false;
         _loc5_.antiAliasType = AntiAliasType.ADVANCED;
         _loc5_.width = this._itemListContainer.width;
         _loc5_.embedFonts = Styles.plainStdEmbed;
         _loc5_.defaultTextFormat = _loc4_;
         _loc5_.multiline = true;
         _loc5_.wordWrap = true;
         _loc5_.text = _loc1_;
         _loc5_.autoSize = TextFieldAutoSize.CENTER;
         _loc5_.alpha = 0;
         this._itemListContainer.addChild(_loc5_);
         TweenLite.to(_loc5_,0.25,{
            "alpha":1,
            "delay":0.5
         });
      }
      
      public function cleanup() : void
      {
         this._backgroundContainer.removeEventListener(MouseEvent.CLICK,this.offerClickedHandler);
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this._video1.removeEventListener(MouseEvent.CLICK,this.offerClickedHandler);
         this._video2.removeEventListener(MouseEvent.CLICK,this.offerClickedHandler);
         this._videoContainer.removeEventListener(MouseEvent.CLICK,this.offerClickedHandler);
         if(this._video1.hasEventListener(Event.ENTER_FRAME))
         {
            this._video1.removeEventListener(Event.ENTER_FRAME,this.handleVideoUpdate);
         }
         if(this._video2.hasEventListener(Event.ENTER_FRAME))
         {
            this._video2.removeEventListener(Event.ENTER_FRAME,this.handleVideoUpdate);
         }
         if(this._currentVideo)
         {
            this._currentVideo.removeEventListener(VideoPlayer.STREAM_RESTARTED,this.handleVideoRestarted);
         }
         TweenLite.killTweensOf(this._video1);
         TweenLite.killTweensOf(this._video2);
         if(this._hoverImg)
         {
            TweenLite.killTweensOf(this._hoverImg);
         }
         this._video1.stop();
         this._video2.stop();
         this._video1.dispose();
         this._video2.dispose();
      }
      
      public function get offerKey() : String
      {
         return this._offerKey;
      }
   }
}

