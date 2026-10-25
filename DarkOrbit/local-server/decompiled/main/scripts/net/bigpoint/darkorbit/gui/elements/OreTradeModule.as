package net.bigpoint.darkorbit.gui.elements
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.com.module.OreTypeModule;
   import net.bigpoint.darkorbit.com.module.TradeSellOreRequest;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.elements.numericstepper.NumericStepperEvent;
   import net.bigpoint.darkorbit.gui.elements.numericstepper.TradeModuleNumericStepper;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.pattern.OrePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class OreTradeModule extends SimpleElement
   {
      
      private var guiManager:GuiManager;
      
      private var type:int;
      
      private var languageKey:String;
      
      private var stepper:TradeModuleNumericStepper;
      
      private var ore_module:MovieClip;
      
      private var oreTarget:MovieClip;
      
      private var orePrice:int;
      
      private var sellButton:ButtonElement;
      
      private var priceTextField:TextField;
      
      private var priceTextFieldWidth:int;
      
      private var priceTextFieldX:Number;
      
      private var gainTextField:TextField;
      
      private var gainTextFieldWidth:int;
      
      private var gainTextFieldX:Number;
      
      private var pricetagLanguageKey:String;
      
      private var pricetagTooltipKey:String;
      
      private var gaintagLanguageKey:String;
      
      private var notavailableLanguageKey:String;
      
      private var gaintagTooltipKey:String;
      
      private var ratioValues:Array = null;
      
      private var displayRatioMode:Boolean = false;
      
      public function OreTradeModule(param1:GuiManager, param2:int, param3:String, param4:String, param5:String, param6:String, param7:String, param8:String, param9:Boolean = false)
      {
         super(SimpleElement.TYPE_ORE_MODULE);
         this.guiManager = param1;
         this.type = param2;
         this.languageKey = param3;
         this.pricetagLanguageKey = param4;
         this.pricetagTooltipKey = param6;
         this.notavailableLanguageKey = param8;
         if(param5 != "")
         {
            this.gaintagLanguageKey = param5;
         }
         else
         {
            this.gaintagLanguageKey = param4;
         }
         this.gaintagTooltipKey = param7;
         this.displayRatioMode = param9;
         if(this.displayRatioMode)
         {
            this.ratioValues = [];
            this.ratioValues[0] = 1;
            this.ratioValues[1] = 0;
         }
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this.ore_module = _loc1_.getEmbeddedMovieClip("trade_module_1");
         this.ore_module.mouseEnabled = Main.mouseEventsEnabled;
         this.priceTextField = this.ore_module["ore_price"];
         this.priceTextField.defaultTextFormat = Styles.strongStdFmt;
         this.priceTextField.embedFonts = Styles.baseEmbed;
         this.priceTextField.text = "";
         this.priceTextFieldWidth = this.priceTextField.width;
         this.priceTextFieldX = this.priceTextField.x;
         this.gainTextField = this.ore_module["ore_gain"];
         this.gainTextField.defaultTextFormat = Styles.strongStdFmt;
         this.gainTextField.embedFonts = Styles.baseEmbed;
         this.gainTextField.text = "";
         this.gainTextFieldWidth = this.gainTextField.width;
         this.gainTextFieldX = this.gainTextField.x;
         var _loc2_:MovieClip = new MovieClip();
         _loc2_.x = 8;
         _loc2_.y = 79;
         this.ore_module.addChild(_loc2_);
         this.stepper = new TradeModuleNumericStepper(this);
         this.stepper.setIncreaseStep(this.displayRatioMode ? int(this.ratioValues[1]) : 1);
         this.stepper.addEventListener(NumericStepperEvent.CHANGE,this.handleNumericStepperChange);
         _loc2_.addChild(this.stepper);
         addChild(this.ore_module);
         this.oreTarget = this.ore_module["_oreTarget"];
         var _loc3_:OrePattern = PatternManager.orePatterns[int(this.type)];
         var _loc4_:Bitmap = _loc1_.getEmbeddedBitmap(_loc3_.resKey);
         _loc4_.x = this.oreTarget.width / 2 - _loc4_.width / 2;
         _loc4_.y = this.oreTarget.height / 2 - _loc4_.height / 2;
         this.oreTarget.addChild(_loc4_);
         if(this.type == OreTypeModule.ORETYPE_PALLADIUM)
         {
            this.sellButton = new ButtonElement(ButtonElementTypes.TYPE_TRADE_ORE,BPLocale.getItem("out_trade"),_loc1_.getEmbeddedMovieClip("tradeButton"),Styles.tradeWindowButtonFmt);
            this.sellButton.addEventListener(MouseEvent.CLICK,this.handleTradeButtonClick);
         }
         else
         {
            this.sellButton = new ButtonElement(ButtonElementTypes.TYPE_SELL_ORE,BPLocale.getItem("out_verkaufen"),_loc1_.getEmbeddedMovieClip("sellButton"),Styles.tradeWindowButtonFmt);
            this.sellButton.addEventListener(MouseEvent.CLICK,this.handleSellButtonClick);
         }
         this.sellButton.y = 135;
         this.sellButton.x = 6;
         this.sellButton.width = 70;
         this.sellButton.height = 15;
         this.sellButton.setTextPosY(0);
         addChild(this.sellButton);
      }
      
      public function disableSellButton() : void
      {
         this.stepper.removeListeners();
         this.showSellButton(false);
      }
      
      public function enableSellButton() : void
      {
         this.stepper.addListeners();
         this.showSellButton(true);
      }
      
      public function showSellButton(param1:Boolean) : void
      {
         if(param1)
         {
            TweenMax.to(this,1,{"colorMatrixFilter":{"saturation":1}});
            this.sellButton.changeTextColour(16777215);
            this.sellButton.addButtonListeners();
            this.sellButton.setEnableStatus();
         }
         else
         {
            TweenMax.to(this,1,{"colorMatrixFilter":{"saturation":0}});
            this.sellButton.changeTextColour(10066329);
            this.sellButton.removeButtonListeners();
            this.sellButton.setDisableStatus();
         }
      }
      
      private function handleNumericStepperChange(param1:NumericStepperEvent) : void
      {
         var _loc2_:int = param1.value;
         this.updateOreGain();
      }
      
      public function setOrePrice(param1:int) : void
      {
         var _loc2_:String = null;
         this.orePrice = param1;
         this.prepareNumericStepper(param1);
         this.oreTarget.alpha = 1;
         if(!this.displayRatioMode)
         {
            _loc2_ = BPLocale.getItem(this.pricetagLanguageKey).replace(/%VALUE%/,param1);
            if(this.pricetagTooltipKey != "")
            {
               TooltipControl.getInstance().removeToolTip(this.priceTextField);
               TooltipControl.getInstance().removeToolTip(this.oreTarget);
               TooltipControl.getInstance().addToolTip(this.priceTextField,BPLocale.getItem(this.pricetagTooltipKey).replace(/%VALUE%/,param1));
               TooltipControl.getInstance().addToolTip(this.oreTarget,BPLocale.getItem(this.pricetagTooltipKey).replace(/%VALUE%/,param1));
            }
         }
         else
         {
            this.ratioValues[1] = this.orePrice;
            if(param1 == -1)
            {
               this.disableSellButton();
               TooltipControl.getInstance().removeToolTip(this.priceTextField);
               TooltipControl.getInstance().removeToolTip(this.oreTarget);
               if(this.notavailableLanguageKey != "")
               {
                  TooltipControl.getInstance().addToolTip(this.priceTextField,BPLocale.getItem(this.notavailableLanguageKey).replace(/%VALUE%/,param1));
                  TooltipControl.getInstance().addToolTip(this.oreTarget,BPLocale.getItem(this.notavailableLanguageKey).replace(/%VALUE%/,param1));
               }
               this.oreTarget.alpha = 0.5;
               _loc2_ = "";
            }
            else
            {
               this.enableSellButton();
               _loc2_ = BPLocale.getItem(this.pricetagLanguageKey).replace(/%VALUE_OUTPUT%/,this.ratioValues[0]).replace(/%VALUE_INPUT%/,this.ratioValues[1]);
               if(this.pricetagTooltipKey != "")
               {
                  TooltipControl.getInstance().removeToolTip(this.priceTextField);
                  TooltipControl.getInstance().removeToolTip(this.oreTarget);
                  TooltipControl.getInstance().addToolTip(this.priceTextField,BPLocale.getItem(this.pricetagTooltipKey).replace(/%VALUE_OUTPUT%/,this.ratioValues[0]).replace(/%VALUE_INPUT%/,this.ratioValues[1]));
                  TooltipControl.getInstance().addToolTip(this.oreTarget,BPLocale.getItem(this.pricetagTooltipKey).replace(/%VALUE_OUTPUT%/,this.ratioValues[0]).replace(/%VALUE_INPUT%/,this.ratioValues[1]));
               }
               this.stepper.setIncreaseStep(this.displayRatioMode ? int(this.ratioValues[1]) : 1);
            }
         }
         this.priceTextField.text = "";
         this.priceTextField.autoSize = TextFieldAutoSize.NONE;
         this.priceTextField.width = this.priceTextFieldWidth;
         this.priceTextField.x = this.priceTextFieldX;
         TextFormatter.distillAndWrite(_loc2_,this.priceTextField,TextFieldAutoSize.CENTER);
      }
      
      public function prepareNumericStepper(param1:int) : void
      {
         if(param1 < 0)
         {
            if(!this.displayRatioMode)
            {
               this.sellButton.visible = false;
               this.stepper.visible = false;
               this.stepper.removeListeners();
            }
            else
            {
               this.sellButton.visible = true;
               this.stepper.visible = true;
               this.stepper.addListeners();
            }
         }
         else
         {
            this.sellButton.visible = true;
            this.stepper.visible = true;
            this.stepper.addListeners();
         }
      }
      
      public function setOreCount(param1:int) : void
      {
         if(this.orePrice > 0 || this.displayRatioMode)
         {
            this.stepper.setOreAmount(param1,this.orePrice);
         }
         this.updateOreGain();
      }
      
      private function updateOreGain() : void
      {
         var _loc3_:String = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.displayRatioMode && int(this.ratioValues[1]) > 0)
         {
            _loc1_ = this.stepper.getValue();
            _loc2_ = this.getCorrectlyRoundedValue(this.stepper.getValue() / int(this.ratioValues[1]));
            _loc3_ = BPLocale.getItem(this.gaintagLanguageKey).replace(/%VALUE%/,TextFormatter.roundInteger(_loc2_));
            this.gainTextField.text = "";
            this.gainTextField.autoSize = TextFieldAutoSize.NONE;
            this.gainTextField.width = this.gainTextFieldWidth;
            this.gainTextField.x = this.gainTextFieldX;
            TextFormatter.distillAndWrite(_loc3_,this.gainTextField,TextFieldAutoSize.CENTER);
            if(this.gaintagTooltipKey != "")
            {
               TooltipControl.getInstance().removeToolTip(this.gainTextField);
               if(_loc2_ > 0)
               {
                  TooltipControl.getInstance().addToolTip(this.gainTextField,BPLocale.getItem(this.gaintagTooltipKey).replace(/%VALUE_OUTPUT%/,_loc2_).replace(/%VALUE_INPUT%/,_loc1_));
               }
            }
            return;
         }
         if(Boolean(this.ratioValues) && int(this.ratioValues[1]) < 0)
         {
            this.gainTextField.text = "";
            TooltipControl.getInstance().removeToolTip(this.gainTextField);
         }
         if(this.orePrice > 0)
         {
            _loc1_ = this.stepper.getValue();
            _loc2_ = this.orePrice * this.stepper.getValue();
            _loc3_ = BPLocale.getItem(this.gaintagLanguageKey).replace(/%VALUE%/,TextFormatter.roundInteger(_loc2_));
            this.gainTextField.text = "";
            this.gainTextField.autoSize = TextFieldAutoSize.NONE;
            this.gainTextField.width = this.gainTextFieldWidth;
            this.gainTextField.x = this.gainTextFieldX;
            TextFormatter.distillAndWrite(_loc3_,this.gainTextField,TextFieldAutoSize.CENTER);
            if(this.gaintagTooltipKey != "")
            {
               TooltipControl.getInstance().removeToolTip(this.gainTextField);
               if(_loc2_ > 0)
               {
                  TooltipControl.getInstance().addToolTip(this.gainTextField,BPLocale.getItem(this.gaintagTooltipKey).replace(/%VALUE_OUTPUT%/,_loc2_).replace(/%VALUE_INPUT%/,_loc1_));
               }
            }
         }
      }
      
      private function getCorrectlyRoundedValue(param1:Number) : int
      {
         if(param1 % 1 == 0)
         {
            return param1;
         }
         return Math.floor(param1);
      }
      
      private function handleSellButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this.stepper.getValue();
         if(_loc2_ < 1)
         {
            return;
         }
         var _loc3_:TradeSellOreRequest = new TradeSellOreRequest();
         _loc3_.toSell.oreType.typeValue = this.type;
         _loc3_.toSell.count = _loc2_;
         this.guiManager.getMain().getConnectionManager().sendRequest(_loc3_);
      }
      
      private function handleTradeButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this.stepper.getValue();
         if(_loc2_ < 1)
         {
            return;
         }
         this.guiManager.getMain().getConnectionManager().sendCommand(ServerCommands.EXCHANGE_PALLADIUM,[_loc2_]);
      }
      
      public function getType() : int
      {
         return this.type;
      }
      
      public function getMC() : MovieClip
      {
         return this.ore_module;
      }
      
      public function cleanup() : void
      {
         if(this.sellButton != null)
         {
            if(this.type == OreTypeModule.ORETYPE_PALLADIUM)
            {
               this.sellButton.removeEventListener(MouseEvent.CLICK,this.handleSellButtonClick);
            }
            else
            {
               this.sellButton.removeEventListener(MouseEvent.CLICK,this.handleTradeButtonClick);
            }
         }
         if(this.stepper != null)
         {
            this.stepper.removeListeners();
            this.stepper.removeEventListener(NumericStepperEvent.CHANGE,this.handleNumericStepperChange);
         }
      }
   }
}

