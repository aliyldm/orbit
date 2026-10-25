package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view
{
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.IGalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.GateBonusGGRewardVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.GateVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.core.CompositeView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.GateEvent;
   import net.bigpoint.darkorbit.utils.BitmapUtils;
   
   public class GateView extends CompositeView
   {
      
      private var gateBackgroundBitmap:BitmapData;
      
      private var gateEffect:MovieClip;
      
      private var gateBitmap:BitmapData;
      
      private var gateColorBitmap:BitmapData;
      
      private var backgrounds:Dictionary = new Dictionary();
      
      private var gateBackgroundRect:Rectangle;
      
      private var gateBackgoundStubAnchor:Point;
      
      private var gateBackgroundAnchor:Point;
      
      private var jumpBtn:MovieClip;
      
      private var titleLabel:TextField;
      
      private var progressLabel:TextField;
      
      private var finishedLabel:TextField;
      
      private var currentGateID:int = 1;
      
      private var buyLifeBtn:MovieClip;
      
      private var _bonusSaleBackground:BitmapData;
      
      private var _bonusSaleTop:BitmapData;
      
      private var _bonusSaleLabel:TextField;
      
      private var livesLeftLabel:TextField;
      
      private var wavesLabel:TextField;
      
      private var commonLib:SWFFinisher;
      
      private var bonusGateView:BonusGateRewardView;
      
      public function GateView(param1:Object, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function update(param1:Event = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:IGalaxyGateBuilderModel = null;
         var _loc6_:GateVO = null;
         var _loc7_:TextField = null;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:String = param1.type;
         _loc5_ = this.model as IGalaxyGateBuilderModel;
         switch(_loc2_)
         {
            case GateEvent.GATE_DETAILS:
               _loc3_ = (param1 as GateEvent).gateID;
               this.currentGateID = _loc3_;
               this.stopGateEffectAnimations();
               this.drawGate(_loc3_);
               this.setProgress();
               this.updateWaves();
               break;
            case ApplicationEvent.INIT_COMPLETE:
               _loc3_ = int((param1 as ApplicationEvent).data);
               this.init(_loc3_);
               _loc6_ = _loc5_.getGateImages(_loc3_);
               if(_loc6_)
               {
                  this.drawBackground(_loc3_,_loc6_.gateImage.bitmapData,_loc6_.lastPartImage.bitmapData);
               }
               break;
            case GateEvent.GATE_PROGRESS:
               getProxy().setGateHandler((param1 as GateEvent).gateID);
               break;
            case GateEvent.GATE_COMPLETE:
               break;
            case ApplicationEvent.LIFE_PRICE_UPDATE:
               (this.buyLifeBtn.getChildByName("mcHolder") as MovieClip).x = 11;
               _loc7_ = (this.buyLifeBtn.getChildByName("mcHolder") as MovieClip).getChildByName("txtLabel") as TextField;
               _loc4_ = _loc5_.getLifePrice() >= 0 ? _loc5_.getLifePrice() : 0;
               _loc8_ = BPLocale.getItemInCategory("galaxyGates","label_buy_life") + "\n(" + BPLocale.getItemInCategory("galaxyGates","pricetag_uridium_compact").replace(/%VALUE%/,BPLocale.formatNumber(_loc4_)) + ")";
               _loc7_.text = _loc8_;
               if(_loc7_.height > 20)
               {
                  (this.buyLifeBtn.getChildByName("mcHolder") as MovieClip).y = 11;
               }
               else
               {
                  (this.buyLifeBtn.getChildByName("mcHolder") as MovieClip).y = 17;
               }
               break;
            case ApplicationEvent.LIVES_LEFT_UPDATE:
               _loc4_ = _loc5_.getLivesLeft() >= 0 ? _loc5_.getLivesLeft() : 0;
               this.livesLeftLabel.text = BPLocale.getItemInCategory("galaxyGates","label_lives_left").replace(/%VALUE%/,_loc4_);
               break;
            case ApplicationEvent.WAVES_UPDATE:
               this.updateWaves();
               break;
            case ApplicationEvent.BUY_BUTTON_VISIBILITY:
               _loc9_ = _loc5_.getLifePrice();
               _loc10_ = _loc5_.getLivesLeft();
               if(this.livesLeftLabel != null && this.buyLifeBtn != null)
               {
                  if(_loc9_ == -1 || _loc10_ == -1)
                  {
                     this.wavesLabel.visible = this.livesLeftLabel.visible = false;
                     this.disableBuyLifeBtn();
                  }
                  else
                  {
                     this.wavesLabel.visible = this.livesLeftLabel.visible = true;
                     this.enableBuyLifeBtn();
                  }
               }
               break;
            case ApplicationEvent.JUMP_BUTTON_VISIBILITY:
               this.setProgress();
         }
      }
      
      private function drawGate(param1:int) : void
      {
         var _loc5_:Boolean = false;
         var _loc2_:GalaxyGateBuilderModel = this.model as GalaxyGateBuilderModel;
         var _loc3_:GateVO = _loc2_.getGateImages(param1);
         if(_loc3_)
         {
            _loc5_ = _loc2_.getHandleLastPart(param1);
            this.drawBackground(param1,_loc3_.gateImage.bitmapData,_loc3_.lastPartImage.bitmapData,_loc5_);
         }
         var _loc4_:GateBonusGGRewardVO = _loc2_.getGateBonusReward(param1);
         if(_loc4_ != null)
         {
            this.finishedLabel.y = 230;
         }
         else
         {
            this.finishedLabel.y = 60;
         }
         this.bonusGateView.setGate(param1);
      }
      
      private function drawBackground(param1:int, param2:BitmapData, param3:BitmapData, param4:Boolean = true) : void
      {
         var _loc9_:BitmapData = null;
         var _loc10_:Rectangle = null;
         var _loc11_:BitmapData = null;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:GlowFilter = null;
         TweenLite.killTweensOf(this.gateEffect);
         this.gateEffect.alpha = 0;
         if(!(BitmapUtils.isValidBitmapData(param2) && BitmapUtils.isValidBitmapData(param3)))
         {
            return;
         }
         var _loc5_:BitmapData = this.backgrounds[param1];
         this.gateBackgroundBitmap.copyPixels(_loc5_,this.gateBackgroundRect,this.gateBackgoundStubAnchor);
         _loc5_ = new BitmapData(this.gateBackgroundRect.width,this.gateBackgroundRect.height,true,0);
         this.gateBitmap.copyPixels(_loc5_,this.gateBackgroundRect,this.gateBackgoundStubAnchor);
         this.gateColorBitmap.copyPixels(_loc5_,this.gateBackgroundRect,this.gateBackgoundStubAnchor);
         if(param2)
         {
            this.gateBitmap.copyPixels(param2,this.gateBackgroundRect,this.gateBackgroundAnchor,param2,null,true);
         }
         var _loc6_:IGalaxyGateBuilderModel = this.model as IGalaxyGateBuilderModel;
         var _loc7_:Boolean = _loc6_.isGateComplete(this.currentGateID);
         var _loc8_:MovieClip = MovieClip(this.gateEffect.getChildByName("gate_" + this.currentGateID));
         if(_loc7_)
         {
            this.gateEffect.gotoAndStop(this.currentGateID);
            if(_loc8_ != null)
            {
               _loc8_.gotoAndPlay(1);
            }
            TweenLite.to(this.gateEffect,0.8,{"alpha":1});
         }
         else
         {
            if(Boolean(param3) && param4)
            {
               _loc9_ = param3.clone();
               _loc10_ = new Rectangle(0,0,_loc9_.width,_loc9_.height);
               _loc11_ = new BitmapData(_loc9_.width,_loc9_.height,true,16777215);
               _loc12_ = 0;
               _loc13_ = 4294953984;
               _loc11_.threshold(_loc9_,_loc10_,this.gateBackgoundStubAnchor,">",_loc12_,_loc13_);
               _loc14_ = new GlowFilter(_loc13_,1,1.8,1.8,2,BitmapFilterQuality.LOW,false,false);
               _loc11_.applyFilter(_loc11_,_loc10_,this.gateBackgoundStubAnchor,_loc14_);
               this.gateColorBitmap.copyPixels(_loc11_,this.gateBackgroundRect,this.gateBackgroundAnchor,_loc11_,null,true);
            }
            this.gateEffect.alpha = 0;
         }
      }
      
      private function init(param1:int = 1) : void
      {
         var _loc3_:SWFFinisher = null;
         var _loc6_:int = 0;
         var _loc8_:TextFormat = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:String = null;
         var _loc2_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         this.commonLib = SWFFinisher(_loc2_.getLib("common"));
         _loc3_ = SWFFinisher(_loc2_.getLib("gates"));
         var _loc4_:Number = 0;
         while(_loc4_ < GalaxyGateBuilderModel.MODE_GATES.length)
         {
            _loc11_ = GalaxyGateBuilderModel.MODE_GATES[_loc4_];
            _loc12_ = 0;
            while(_loc12_ < _loc11_.length)
            {
               _loc13_ = int(_loc11_[_loc12_]);
               _loc14_ = "";
               if(_loc13_ <= 9)
               {
                  _loc14_ += "0" + String(_loc13_);
               }
               else
               {
                  _loc14_ = String(_loc13_);
               }
               this.backgrounds[_loc13_] = this.commonLib.getEmbeddedBitmapData("space_bg_" + _loc14_);
               _loc12_++;
            }
            _loc4_++;
         }
         this.gateBackgroundRect = new Rectangle(0,0,(this.backgrounds[param1] as BitmapData).width,(this.backgrounds[param1] as BitmapData).height);
         this.gateBackgoundStubAnchor = new Point(0,0);
         this.gateBackgroundAnchor = new Point(50,0);
         this.gateBackgroundBitmap = new BitmapData(this.gateBackgroundRect.width,this.gateBackgroundRect.height,true,4294967295);
         this.gateBitmap = new BitmapData(this.gateBackgroundRect.width,this.gateBackgroundRect.height,true,0);
         this.gateColorBitmap = new BitmapData(this.gateBackgroundRect.width,this.gateBackgroundRect.height,true,0);
         var _loc5_:Bitmap = new Bitmap(this.gateBackgroundBitmap);
         _loc5_.x = 10;
         _loc5_.y = 54;
         this.addChild(_loc5_);
         _loc5_ = new Bitmap(this.gateBitmap);
         _loc5_.x = 10;
         _loc5_.y = 54;
         this.addChild(_loc5_);
         _loc5_ = new Bitmap(this.gateColorBitmap);
         _loc5_.blendMode = BlendMode.OVERLAY;
         _loc5_.x = 10;
         _loc5_.y = 54;
         this.addChild(_loc5_);
         this.gateEffect = _loc3_.getEmbeddedMovieClip("effect");
         this.gateEffect.gotoAndStop(1);
         this.gateEffect.alpha = 0;
         this.stopGateEffectAnimations();
         this.gateEffect.x = 60;
         this.gateEffect.y = 54;
         this.addChild(this.gateEffect);
         this.drawBackground(param1,null,null);
         this.bonusGateView = new BonusGateRewardView(getModel(),getProxy());
         this.bonusGateView.init(param1,this.gateBackgroundRect.width);
         addChild(this.bonusGateView);
         this.jumpBtn = this.commonLib.getEmbeddedMovieClip("PrepareJumpButton");
         this.jumpBtn.name = "prepareJumpBtn";
         var _loc7_:TextField = (this.jumpBtn.getChildByName("mcHolder") as MovieClip).getChildByName("txtLabel") as TextField;
         (this.jumpBtn.getChildByName("mcHolder") as MovieClip).gotoAndStop(1);
         _loc7_.defaultTextFormat = Styles.centeredSmallFmt;
         _loc7_.embedFonts = Styles.centeredSmallEmbed;
         _loc7_.text = BPLocale.getItemInCategory("galaxyGates","label_prepare_jump");
         _loc7_.autoSize = TextFieldAutoSize.CENTER;
         _loc6_ = _loc7_.height;
         if(_loc6_ > 20)
         {
            (this.jumpBtn.getChildByName("mcHolder") as MovieClip).y = (this.jumpBtn.getChildByName("mcHolder") as MovieClip).y - 6;
         }
         _loc7_.mouseEnabled = false;
         this.jumpBtn.x = 220;
         this.jumpBtn.y = 328;
         addChild(this.jumpBtn);
         this.titleLabel = new TextField();
         _loc8_ = Styles.ggBuilderH3Fmt;
         _loc8_.align = TextFormatAlign.CENTER;
         this.titleLabel.defaultTextFormat = _loc8_;
         this.titleLabel.embedFonts = Styles.ggBuilderH3Embed;
         this.titleLabel.height = Styles.ggBuilderPlainBigFontHeight + 6;
         this.titleLabel.width = 220;
         this.titleLabel.antiAliasType = AntiAliasType.ADVANCED;
         this.titleLabel.textColor = 12375011;
         this.titleLabel.selectable = false;
         this.titleLabel.text = "";
         this.titleLabel.x = 65;
         this.titleLabel.y = 14;
         addChild(this.titleLabel);
         this.progressLabel = new TextField();
         _loc8_ = Styles.h1Fmt;
         _loc8_.align = TextFormatAlign.RIGHT;
         this.progressLabel.defaultTextFormat = _loc8_;
         this.progressLabel.embedFonts = Styles.h1Embed;
         this.progressLabel.width = 120;
         this.progressLabel.height = Styles.h1FontHeight + 6;
         this.progressLabel.antiAliasType = AntiAliasType.ADVANCED;
         this.progressLabel.textColor = 13421772;
         this.progressLabel.selectable = false;
         this.progressLabel.text = "";
         this.progressLabel.x = 210;
         this.progressLabel.y = 300;
         addChild(this.progressLabel);
         this.finishedLabel = new TextField();
         _loc8_ = Styles.h1Fmt;
         _loc8_.align = TextFormatAlign.LEFT;
         this.finishedLabel.defaultTextFormat = _loc8_;
         this.finishedLabel.embedFonts = Styles.h1Embed;
         this.finishedLabel.width = 300;
         this.finishedLabel.height = Styles.h1FontHeight + 6;
         this.finishedLabel.antiAliasType = AntiAliasType.ADVANCED;
         this.finishedLabel.textColor = 13421772;
         this.finishedLabel.selectable = false;
         this.finishedLabel.text = "";
         this.finishedLabel.x = 18;
         this.finishedLabel.y = 60;
         addChild(this.finishedLabel);
         this.buyLifeBtn = this.commonLib.getEmbeddedMovieClip("buyButton");
         this.buyLifeBtn.buttonMode = true;
         var _loc9_:TextField = (this.buyLifeBtn.getChildByName("mcHolder") as MovieClip).getChildByName("txtLabel") as TextField;
         (this.buyLifeBtn.getChildByName("mcHolder") as MovieClip).gotoAndStop(1);
         _loc9_.defaultTextFormat = Styles.centeredSmallFmt;
         _loc9_.embedFonts = Styles.centeredSmallEmbed;
         _loc9_.mouseEnabled = false;
         _loc9_.autoSize = TextFieldAutoSize.CENTER;
         _loc9_.text = "";
         this.buyLifeBtn.x = 8;
         this.buyLifeBtn.y = 328;
         addChild(this.buyLifeBtn);
         this.livesLeftLabel = new TextField();
         this.livesLeftLabel.defaultTextFormat = Styles.ggBuilderH3Fmt;
         this.livesLeftLabel.autoSize = TextFieldAutoSize.LEFT;
         this.livesLeftLabel.embedFonts = Styles.ggBuilderH3Embed;
         this.livesLeftLabel.height = Styles.ggBuilderPlainBigFontHeight + 6;
         this.livesLeftLabel.x = 18;
         this.livesLeftLabel.y = 280;
         this.livesLeftLabel.textColor = 13421772;
         this.livesLeftLabel.antiAliasType = AntiAliasType.ADVANCED;
         this.livesLeftLabel.selectable = false;
         this.livesLeftLabel.visible = false;
         TooltipControl.getInstance().addToolTip(this.livesLeftLabel,BPLocale.getItemInCategory("galaxyGates","ttip_lives_left"));
         this.addChild(this.livesLeftLabel);
         this.wavesLabel = new TextField();
         this.wavesLabel.defaultTextFormat = Styles.ggBuilderH3Fmt;
         this.wavesLabel.autoSize = TextFieldAutoSize.LEFT;
         this.wavesLabel.embedFonts = Styles.ggBuilderH3Embed;
         this.wavesLabel.width = 120;
         this.wavesLabel.height = Styles.ggBuilderPlainBigFontHeight + 6;
         this.wavesLabel.x = 18;
         this.wavesLabel.y = 300;
         this.wavesLabel.textColor = 13421772;
         this.wavesLabel.antiAliasType = AntiAliasType.ADVANCED;
         this.wavesLabel.selectable = false;
         this.wavesLabel.text = "";
         this.wavesLabel.visible = false;
         this.addChild(this.wavesLabel);
         if(GalaxyGateBuilderModel.galaxyGateDay || GalaxyGateBuilderModel.bonusRewardsDay)
         {
            this._bonusSaleBackground = this.commonLib.getEmbeddedBitmapData("bonus_sale_frame");
            this._bonusSaleTop = this.commonLib.getEmbeddedBitmapData("bonus_sale_top");
            _loc5_ = new Bitmap(this._bonusSaleTop);
            _loc5_.x = 10;
            _loc5_.y = 54;
            this.addChild(_loc5_);
            this._bonusSaleLabel = new TextField();
            _loc8_ = Styles.h1Fmt;
            _loc8_.align = TextFormatAlign.LEFT;
            _loc8_.size = 13;
            this._bonusSaleLabel.defaultTextFormat = _loc8_;
            this._bonusSaleLabel.embedFonts = Styles.h1Embed;
            this._bonusSaleLabel.height = Styles.h1FontHeight + 6;
            this._bonusSaleLabel.width = width;
            this._bonusSaleLabel.antiAliasType = AntiAliasType.ADVANCED;
            this._bonusSaleLabel.textColor = 15584552;
            this._bonusSaleLabel.selectable = false;
            this._bonusSaleLabel.text = GalaxyGateBuilderModel.galaxyGateDay ? BPLocale.getItemInCategory("galaxyGates","galaxy_day_bonus_reward") : BPLocale.getItemInCategory("galaxyGates","bonus_reward_day");
            this._bonusSaleLabel.x = 20;
            this._bonusSaleLabel.y = 65;
            addChild(this._bonusSaleLabel);
            _loc5_ = new Bitmap(this._bonusSaleBackground);
            _loc5_.x = 10;
            _loc5_.y = 54;
            this.addChild(_loc5_);
         }
         var _loc10_:IGalaxyGateBuilderModel = this.model as IGalaxyGateBuilderModel;
         _loc10_.dispatchEvent(new ApplicationEvent(ApplicationEvent.WAVES_UPDATE));
         _loc10_.dispatchEvent(new ApplicationEvent(ApplicationEvent.LIFE_PRICE_UPDATE));
         _loc10_.dispatchEvent(new ApplicationEvent(ApplicationEvent.LIVES_LEFT_UPDATE));
         _loc10_.dispatchEvent(new ApplicationEvent(ApplicationEvent.BUY_BUTTON_VISIBILITY));
         _loc10_.dispatchEvent(new ApplicationEvent(ApplicationEvent.JUMP_BUTTON_VISIBILITY));
      }
      
      private function stopGateEffectAnimations() : void
      {
         var _loc1_:MovieClip = null;
         if(this.gateEffect == null)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < GalaxyGateBuilderModel.MAX_GATES_COUNT)
         {
            _loc1_ = MovieClip(this.gateEffect.getChildByName("gate_" + String(_loc2_)));
            if(_loc1_ != null)
            {
               _loc1_.gotoAndStop(1);
            }
            _loc2_++;
         }
      }
      
      private function handleBuyButtonMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.gotoAndStop("std");
      }
      
      private function handleBuyButtonMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.gotoAndStop("hover");
      }
      
      private function handleBuyButtonClick(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("click");
         (model as IGalaxyGateBuilderModel).initGateLifePurchase(this.currentGateID);
      }
      
      private function setProgress() : void
      {
         this.titleLabel.text = BPLocale.getItemInCategory("galaxyGates","gate_title_" + this.currentGateID);
         var _loc1_:IGalaxyGateBuilderModel = this.model as IGalaxyGateBuilderModel;
         this.progressLabel.text = _loc1_.getProgress();
         var _loc2_:Boolean = _loc1_.getGateState();
         if(_loc2_)
         {
            this.finishedLabel.text = BPLocale.getItemInCategory("galaxyGates","label_gate_finished").replace(/%GATE_NAME%/,BPLocale.getItemInCategory("galaxyGates","gate_name_" + this.currentGateID));
            this.enablePrepareBtn();
         }
         else
         {
            this.finishedLabel.text = "";
            this.disablePrepareBtn();
         }
      }
      
      private function updateWaves() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc1_:IGalaxyGateBuilderModel = this.model as IGalaxyGateBuilderModel;
         _loc3_ = uint(_loc1_.getCurrentWaveCount());
         _loc2_ = uint(_loc1_.getTotalWaveCount());
         if(_loc1_.isHadesGate())
         {
            _loc5_ = 0;
            switch(_loc3_)
            {
               case 0:
               case 1:
               case 2:
               case 3:
                  _loc5_ = 1;
                  break;
               case 4:
               case 5:
               case 6:
               case 7:
                  _loc5_ = 2;
                  break;
               case 8:
               case 9:
               case 10:
               case 11:
               case 12:
                  _loc5_ = 3;
            }
            _loc4_ = BPLocale.getItemInCategory("galaxyGates","label_stage").replace(/%VALUE%/,_loc5_ + "/3");
            this.wavesLabel.text = _loc4_;
         }
         else if(_loc2_ > 0)
         {
            _loc4_ = BPLocale.getItemInCategory("galaxyGates","label_wave").replace(/%VALUE%/,_loc3_ + "/" + _loc2_);
            this.wavesLabel.text = _loc4_;
         }
         else
         {
            this.wavesLabel.text = "";
         }
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("hover");
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("std");
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         switch((param1.currentTarget as MovieClip).name)
         {
            case "prepareJumpBtn":
               getProxy().prepareJumpHandler();
         }
      }
      
      public function enableBuyLifeBtn() : void
      {
         this.buyLifeBtn.addEventListener(MouseEvent.MOUSE_OVER,this.handleBuyButtonMouseOver);
         this.buyLifeBtn.addEventListener(MouseEvent.MOUSE_OUT,this.handleBuyButtonMouseOut);
         this.buyLifeBtn.addEventListener(MouseEvent.CLICK,this.handleBuyButtonClick);
         this.buyLifeBtn.buttonMode = true;
         var _loc1_:TextField = (this.buyLifeBtn.getChildByName("mcHolder") as MovieClip).getChildByName("txtLabel") as TextField;
         _loc1_.textColor = 16777215;
         this.buyLifeBtn.gotoAndStop("std");
      }
      
      public function disableBuyLifeBtn(param1:String = "disabled") : void
      {
         this.buyLifeBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.handleBuyButtonMouseOver);
         this.buyLifeBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.handleBuyButtonMouseOut);
         this.buyLifeBtn.removeEventListener(MouseEvent.CLICK,this.handleBuyButtonClick);
         this.buyLifeBtn.buttonMode = false;
         var _loc2_:TextField = (this.buyLifeBtn.getChildByName("mcHolder") as MovieClip).getChildByName("txtLabel") as TextField;
         _loc2_.textColor = 0;
         this.buyLifeBtn.gotoAndStop(param1);
      }
      
      public function enablePrepareBtn() : void
      {
         this.jumpBtn.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.jumpBtn.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.jumpBtn.addEventListener(MouseEvent.CLICK,this.handleMouseClick);
         this.jumpBtn.buttonMode = true;
         var _loc1_:TextField = (this.jumpBtn.getChildByName("mcHolder") as MovieClip).getChildByName("txtLabel") as TextField;
         _loc1_.textColor = 16777215;
         this.jumpBtn.gotoAndStop("std");
      }
      
      public function disablePrepareBtn(param1:String = "disabled") : void
      {
         this.jumpBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.jumpBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.jumpBtn.removeEventListener(MouseEvent.CLICK,this.handleMouseClick);
         this.jumpBtn.buttonMode = false;
         var _loc2_:TextField = (this.jumpBtn.getChildByName("mcHolder") as MovieClip).getChildByName("txtLabel") as TextField;
         _loc2_.textColor = 0;
         this.jumpBtn.gotoAndStop(param1);
      }
   }
}

