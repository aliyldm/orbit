package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.windows
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.GalaxyGateBuilderDecorator;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.IGalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.core.CompositeView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.GateEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.MaterializeEvent;
   
   public class MessageWindowView extends CompositeView
   {
      
      private var btnList:Dictionary;
      
      private const DIALOG_MODE_MODAL:int = 1;
      
      private const DIALOG_MODE_STANDARD:int = 0;
      
      private const DIALOG_MODE_MODAL_LIFE_PURCHASE:int = 2;
      
      private const DIALOG_MODE_MODAL_URIDIUM_PURCHASE:int = 3;
      
      private var headLabel:TextField;
      
      private var msgLabel:TextField;
      
      private var viewContainer:Sprite;
      
      private var viewClip:Sprite;
      
      public var probabilityView:Sprite = new Sprite();
      
      private var mode:int;
      
      private var stop:Boolean;
      
      private var lightboxBackground:Sprite;
      
      private var msgWindow:Sprite;
      
      public function MessageWindowView(param1:Object, param2:Object = null)
      {
         super(param1,param2);
         this.stop = false;
      }
      
      override public function update(param1:Event = null) : void
      {
         var _loc2_:String = param1.type;
         switch(_loc2_)
         {
            case ApplicationEvent.HOLD:
               this.mode = this.DIALOG_MODE_MODAL;
               this.showMessage();
               break;
            case ApplicationEvent.STOP:
               this.stop = true;
               this.mode = this.DIALOG_MODE_MODAL;
               this.showMessage();
               break;
            case ApplicationEvent.INIT_COMPLETE:
               this.init();
               break;
            case MaterializeEvent.MATERIALIZE_DUPLICATE_PART:
               if((param1 as MaterializeEvent).showMessage)
               {
                  this.mode = this.DIALOG_MODE_STANDARD;
                  this.showMessage();
               }
               break;
            case MaterializeEvent.MATERIALIZE_MULTIPLE_PART_OUTPUT:
            case MaterializeEvent.MATERIALIZE_SHOW_MESSAGE:
            case GateEvent.GATE_SETUP:
               this.mode = this.DIALOG_MODE_STANDARD;
               this.showMessage();
               break;
            case MaterializeEvent.MATERIALIZE_NEW_OUTPUT:
               this.mode = this.DIALOG_MODE_STANDARD;
               this.hideMessage();
               break;
            case ApplicationEvent.RUN:
               this.mode = this.DIALOG_MODE_STANDARD;
               this.hideMessage();
               break;
            case GateEvent.GATE_LIFE_PURCHASE_INIT:
               this.mode = this.DIALOG_MODE_MODAL_LIFE_PURCHASE;
               this.showBuyGateLifePrompt((param1 as GateEvent).gateID);
               break;
            case GateEvent.GATE_LIFE_PURCHASE_COMPLETE:
               this.mode = this.DIALOG_MODE_STANDARD;
               this.hideMessage();
               break;
            case ApplicationEvent.URIDIUM_PURCHASE_INIT:
               this.mode = this.DIALOG_MODE_MODAL_URIDIUM_PURCHASE;
               this.showBuyUridiumPrompt();
               break;
            case ApplicationEvent.URIDIUM_PURCHASE_COMPLETE:
               this.mode = this.DIALOG_MODE_STANDARD;
               this.hideMessage();
               break;
            case GateEvent.GATE_SHOW_PROBABILITY:
               this.mode = this.DIALOG_MODE_STANDARD;
               this.showProbability((param1 as GateEvent).gateID);
         }
      }
      
      private function showMessage() : void
      {
         this.initBackground();
         this.createWindow();
      }
      
      private function createWindow() : void
      {
         var _loc2_:AssetsProxy = null;
         var _loc3_:SWFFinisher = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TextFormat = null;
         var _loc6_:MovieClip = null;
         var _loc7_:String = null;
         if(this.msgWindow == null)
         {
            _loc2_ = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
            _loc3_ = SWFFinisher(_loc2_.getLib("common"));
            this.msgWindow = new Sprite();
            _loc4_ = _loc3_.getEmbeddedMovieClip("popup_bg");
            this.msgWindow.addChild(_loc4_);
            this.msgWindow.x = GalaxyGateBuilderDecorator.STAGE_WIDTH / 2 - this.msgWindow.width / 2;
            this.msgWindow.y = GalaxyGateBuilderDecorator.STAGE_HEIGHT / 2 - this.msgWindow.height / 2;
            this.msgLabel = new TextField();
            _loc5_ = Styles.ggBuilderPlainBigFmt;
            _loc5_.align = TextFormatAlign.CENTER;
            this.msgLabel.defaultTextFormat = _loc5_;
            this.msgLabel.embedFonts = Styles.ggBuilderPlainBigEmbed;
            this.msgLabel.multiline = true;
            this.msgLabel.wordWrap = true;
            this.msgLabel.textColor = 14540253;
            this.msgLabel.x = 14;
            this.msgLabel.y = 45;
            this.msgLabel.width = 330;
            this.msgLabel.height = 150;
            this.msgLabel.antiAliasType = AntiAliasType.ADVANCED;
            this.msgLabel.text = "";
            this.msgWindow.addChild(this.msgLabel);
            this.headLabel = new TextField();
            _loc5_ = Styles.h1Fmt;
            _loc5_.align = TextFormatAlign.LEFT;
            this.headLabel.defaultTextFormat = _loc5_;
            this.headLabel.embedFonts = Styles.h1Embed;
            this.headLabel.height = Styles.h1FontHeight + 4;
            this.headLabel.width = 300;
            this.headLabel.textColor = 16777215;
            this.headLabel.x = 14;
            this.headLabel.y = 10;
            this.headLabel.antiAliasType = AntiAliasType.ADVANCED;
            this.headLabel.selectable = false;
            this.headLabel.text = "";
            this.msgWindow.addChild(this.headLabel);
            this.viewContainer = new Sprite();
            this.viewContainer.x = 14;
            this.viewContainer.y = 45;
            this.viewContainer.width = 330;
            this.viewContainer.height = 150;
            this.msgWindow.addChild(this.viewContainer);
            this.probabilityView.x = 48;
            this.probabilityView.y = 50;
            this.msgWindow.addChild(this.probabilityView);
            _loc6_ = _loc3_.getEmbeddedMovieClip("popup_close_btn");
            _loc6_.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
            _loc6_.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
            _loc6_.addEventListener(MouseEvent.CLICK,this.handleMouseClick);
            _loc6_.buttonMode = true;
            _loc6_.x = 330;
            _loc6_.y = 12;
            _loc6_.gotoAndStop("std");
            this.msgWindow.addChild(_loc6_);
         }
         if(!contains(this.msgWindow))
         {
            addChild(this.msgWindow);
         }
         var _loc1_:String = (model as IGalaxyGateBuilderModel).getErrorMessage().replace(/\\n/,"\n");
         if(this.stop)
         {
            _loc1_ = _loc1_.replace(/<i>/,"\"").replace(/<\/i>/,"\"");
         }
         else
         {
            _loc7_ = "\"" + BPLocale.getItemInCategory("galaxyGates","label_close") + "\"";
            _loc1_ = _loc1_.replace(/(<i>)(.*?)(<\/i>)/,_loc7_);
         }
         this.msgLabel.text = _loc1_;
         this.initContent();
         this.initButtons();
      }
      
      private function initBackground() : void
      {
         if(this.mode == this.DIALOG_MODE_MODAL || this.mode == this.DIALOG_MODE_MODAL_URIDIUM_PURCHASE)
         {
            if(this.lightboxBackground == null)
            {
               this.lightboxBackground = new Sprite();
               this.lightboxBackground.addChild(new Bitmap(new BitmapData(800,600,true,2281701376)));
            }
            if(!contains(this.lightboxBackground))
            {
               addChildAt(this.lightboxBackground,0);
            }
         }
         else if(this.mode == this.DIALOG_MODE_STANDARD && this.lightboxBackground != null && contains(this.lightboxBackground))
         {
            removeChild(this.lightboxBackground);
         }
      }
      
      private function initContent() : void
      {
         this.headLabel.visible = true;
         this.headLabel.text = "";
         this.msgLabel.visible = true;
         if(this.viewClip != null)
         {
            if(this.viewContainer.contains(this.viewClip))
            {
               this.viewContainer.removeChild(this.viewClip);
               this.viewClip = null;
            }
         }
         this.viewContainer.visible = false;
         this.probabilityView.visible = false;
      }
      
      private function showBuyGateLifePrompt(param1:int) : void
      {
         this.initBackground();
         this.createWindow();
         this.msgLabel.text = BPLocale.getItemInCategory("galaxyGates","msg_buy_life_confirmation").replace(/%GATE_NAME%/,BPLocale.getItemInCategory("galaxyGates","gate_name_" + param1)).replace(/%AMOUNT%/,BPLocale.formatNumber((model as IGalaxyGateBuilderModel).getLifePrice()));
      }
      
      private function showBuyUridiumPrompt() : void
      {
         this.initBackground();
         this.createWindow();
         this.msgLabel.text = BPLocale.getItemInCategory("galaxyGates","msg_not_enough_uridium");
      }
      
      private function showProbability(param1:int) : void
      {
         this.initBackground();
         this.createWindow();
         this.headLabel.visible = true;
         this.headLabel.text = BPLocale.getItemInCategory("galaxyGates","label_probabilities");
         this.msgLabel.visible = false;
         this.probabilityView.visible = true;
      }
      
      private function initButtons() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TextField = null;
         var _loc5_:TextField = null;
         var _loc6_:TextField = null;
         var _loc7_:AssetsProxy = null;
         if(this.btnList == null)
         {
            this.btnList = new Dictionary();
            _loc7_ = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
            _loc1_ = _loc7_.getMovieClip("common","popup_cancel_btn");
            _loc1_.y = 220;
            this.msgWindow.addChild(_loc1_);
            _loc4_ = _loc1_.getChildByName("btnText") as TextField;
            _loc4_.defaultTextFormat = Styles.centeredHeavyFmt;
            _loc4_.embedFonts = Styles.centeredHeavyEmbed;
            _loc4_.height = Styles.centeredHeavyFontHeight + 4;
            _loc4_.mouseEnabled = false;
            _loc1_.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
            _loc1_.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
            _loc1_.addEventListener(MouseEvent.CLICK,this.handleMouseClick);
            _loc1_.buttonMode = true;
            _loc1_.gotoAndStop("std");
            this.btnList["discardBtn"] = _loc1_;
            _loc2_ = _loc7_.getMovieClip("common","popup_confirm_btn");
            _loc2_.y = 220;
            _loc5_ = _loc2_.getChildByName("btnText") as TextField;
            _loc5_.defaultTextFormat = Styles.centeredHeavyFmt;
            _loc5_.embedFonts = Styles.centeredHeavyEmbed;
            _loc5_.height = Styles.centeredHeavyFontHeight + 4;
            _loc5_.mouseEnabled = false;
            _loc2_.buttonMode = true;
            _loc2_.gotoAndStop("std");
            this.btnList["confirmBuyGateLifeBtn"] = _loc2_;
            _loc3_ = _loc7_.getMovieClip("common","popup_confirm_btn");
            _loc3_.y = 220;
            _loc6_ = _loc3_.getChildByName("btnText") as TextField;
            _loc6_.defaultTextFormat = Styles.centeredHeavyFmt;
            _loc6_.embedFonts = Styles.centeredHeavyEmbed;
            _loc6_.height = Styles.centeredHeavyFontHeight + 4;
            _loc6_.mouseEnabled = false;
            _loc3_.buttonMode = true;
            _loc3_.gotoAndStop("std");
            this.btnList["confirmBuyUridiumBtn"] = _loc3_;
         }
         _loc1_ = this.btnList["discardBtn"] as MovieClip;
         _loc4_ = _loc1_.getChildByName("btnText") as TextField;
         _loc2_ = this.btnList["confirmBuyGateLifeBtn"] as MovieClip;
         _loc3_ = this.btnList["confirmBuyUridiumBtn"] as MovieClip;
         switch(this.mode)
         {
            case this.DIALOG_MODE_MODAL_LIFE_PURCHASE:
               if(!this.msgWindow.contains(_loc2_))
               {
                  this.msgWindow.addChild(_loc2_);
               }
               if(this.msgWindow.contains(_loc3_))
               {
                  this.msgWindow.removeChild(_loc3_);
               }
               _loc2_.removeEventListener(MouseEvent.CLICK,this.handleGateLifePurchaseConfirmBtnClick);
               _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
               _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOver);
               _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
               _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
               _loc2_.addEventListener(MouseEvent.CLICK,this.handleGateLifePurchaseConfirmBtnClick);
               _loc5_ = _loc2_.getChildByName("btnText") as TextField;
               _loc5_.text = BPLocale.getItemInCategory("galaxyGates","label_buy");
               _loc4_.text = BPLocale.getItemInCategory("galaxyGates","label_abort");
               _loc2_.x = this.msgWindow.width / 2 - (_loc1_.width + _loc2_.width + 8) / 2;
               _loc1_.x = _loc2_.x + _loc2_.width + 8;
               break;
            case this.DIALOG_MODE_MODAL_URIDIUM_PURCHASE:
               if(this.msgWindow.contains(_loc2_))
               {
                  this.msgWindow.removeChild(_loc2_);
               }
               if(!this.msgWindow.contains(_loc3_))
               {
                  this.msgWindow.addChild(_loc3_);
               }
               _loc3_.removeEventListener(MouseEvent.CLICK,this.handleUridiumPurchaseConfirmBtnClick);
               _loc3_.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
               _loc3_.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOver);
               _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
               _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
               _loc3_.addEventListener(MouseEvent.CLICK,this.handleUridiumPurchaseConfirmBtnClick);
               _loc6_ = _loc3_.getChildByName("btnText") as TextField;
               _loc6_.text = BPLocale.getItemInCategory("galaxyGates","label_uridium");
               _loc4_.text = BPLocale.getItemInCategory("galaxyGates","label_abort");
               _loc3_.x = this.msgWindow.width / 2 - (_loc1_.width + _loc3_.width + 8) / 2;
               _loc1_.x = _loc3_.x + _loc3_.width + 8;
               break;
            case this.DIALOG_MODE_MODAL:
               if(this.msgWindow.contains(_loc2_))
               {
                  this.msgWindow.removeChild(_loc2_);
               }
               if(this.msgWindow.contains(_loc3_))
               {
                  this.msgWindow.removeChild(_loc3_);
               }
               if(this.stop)
               {
                  _loc4_.text = BPLocale.getItemInCategory("galaxyGates","label_restart");
               }
               else
               {
                  _loc4_.text = BPLocale.getItemInCategory("galaxyGates","label_close");
               }
               _loc1_.x = this.msgWindow.width / 2 - _loc1_.width / 2;
               break;
            case this.DIALOG_MODE_STANDARD:
               if(this.msgWindow.contains(_loc2_))
               {
                  this.msgWindow.removeChild(_loc2_);
               }
               if(this.msgWindow.contains(_loc3_))
               {
                  this.msgWindow.removeChild(_loc3_);
               }
               _loc4_.text = BPLocale.getItemInCategory("galaxyGates","label_resume");
               _loc1_.x = this.msgWindow.width / 2 - _loc1_.width / 2;
         }
      }
      
      private function hideMessage() : void
      {
         if(this.lightboxBackground != null && contains(this.lightboxBackground))
         {
            removeChild(this.lightboxBackground);
         }
         if(this.msgWindow != null && contains(this.msgWindow))
         {
            removeChild(this.msgWindow);
         }
      }
      
      public function init() : void
      {
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         getProxy().setAppRunningHandler();
      }
      
      private function handleGateLifePurchaseConfirmBtnClick(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).removeEventListener(MouseEvent.CLICK,this.handleGateLifePurchaseConfirmBtnClick);
         (param1.currentTarget as MovieClip).removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         (param1.currentTarget as MovieClip).removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOver);
         getProxy().confirmGateLifePurchase();
      }
      
      private function handleUridiumPurchaseConfirmBtnClick(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).removeEventListener(MouseEvent.CLICK,this.handleUridiumPurchaseConfirmBtnClick);
         (param1.currentTarget as MovieClip).removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         (param1.currentTarget as MovieClip).removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOver);
         getProxy().confirmUridiumPurchase();
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("hover");
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("std");
      }
   }
}

