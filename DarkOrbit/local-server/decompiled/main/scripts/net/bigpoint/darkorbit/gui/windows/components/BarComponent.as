package net.bigpoint.darkorbit.gui.windows.components
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.utils.ColorUtils;
   
   public class BarComponent extends Sprite
   {
      
      private var backGroundContainer:Sprite;
      
      private var barContainer:Sprite;
      
      private var iconContainer:Sprite;
      
      private var currentBarWidth:int = 0;
      
      private var currentAmount:Number = 0;
      
      private var maxAmount:Number = 0;
      
      private var icon:Bitmap;
      
      private var overlayContainer:Sprite;
      
      private var textContainer:Sprite;
      
      private var barValue:TextField;
      
      public var toolTipHook:ToolTipHook;
      
      public var toolTipBase:String;
      
      private var barConfigVo:BarConfigVO;
      
      public var changeColorWithBarLength:Boolean = false;
      
      private var pulsing:Boolean = false;
      
      private var numberOfPulses:int;
      
      private var pulseFrequency:Number;
      
      private var currentPulse:int;
      
      private var currentTimeInSeconds:Number;
      
      private var genericTimer:Timer;
      
      private var localSecsElapsed:Number;
      
      private var updateInterval:Number = 0.1;
      
      public var flashBelowThreshold:Number;
      
      private var centraliseBarValue:Boolean = false;
      
      private var defaultPadding:Number = 5;
      
      public function BarComponent(param1:uint, param2:Bitmap = null, param3:BarConfigVO = null)
      {
         super();
         if(!param3)
         {
            this.barConfigVo = new BarConfigVO();
            this.barConfigVo.barColor = param1;
         }
         else
         {
            this.barConfigVo = param3;
         }
         this.icon = param2;
         this.init();
      }
      
      private function init() : void
      {
         this.backGroundContainer = new Sprite();
         this.barContainer = new Sprite();
         this.iconContainer = new Sprite();
         this.iconContainer.useHandCursor = true;
         this.iconContainer.buttonMode = true;
         this.textContainer = new Sprite();
         this.overlayContainer = new Sprite();
         this.backGroundContainer.addChild(this.barContainer);
         this.barValue = new TextField();
         this.barValue.antiAliasType = AntiAliasType.ADVANCED;
         this.barValue.embedFonts = Styles.baseEmbed;
         this.barValue.mouseEnabled = false;
         this.barValue.autoSize = TextFieldAutoSize.LEFT;
         this.barValue.multiline = this.barValue.wordWrap = false;
         var _loc1_:TextFormat = new TextFormat(Styles.plainBigFmt.font,10,16777215,false);
         this.barValue.defaultTextFormat = _loc1_;
         this.textContainer.addChild(this.barValue);
         this.overlayContainer.addEventListener(MouseEvent.CLICK,this.handleOverlayClick);
         this.overlayContainer.useHandCursor = true;
         this.overlayContainer.buttonMode = true;
         this.textContainer.visible = false;
         this.checkIcon();
         this.addChild(this.textContainer);
         this.addChild(this.backGroundContainer);
         this.addChild(this.iconContainer);
         this.addChild(this.overlayContainer);
         this.updateLayout();
         this.update(0,100);
      }
      
      private function checkIcon() : void
      {
         if(this.icon)
         {
            this.iconContainer.addChild(this.icon);
         }
      }
      
      private function updateLayout() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = this.defaultPadding;
         if(this.icon != null)
         {
            _loc1_ = this.iconContainer.width + _loc2_;
         }
         this.backGroundContainer.x = _loc1_;
         this.backGroundContainer.y = this.iconContainer.height * 0.5;
         this.redrawOverlayContainer(_loc1_);
         this.barValue.width = this.barConfigVo.totalbarWidth;
         this.barValue.x = this.iconContainer.width + _loc2_;
         this.barValue.y = -this.barValue.height * 0.5;
      }
      
      public function setBarValueOnTop() : void
      {
         this.setChildIndex(this.textContainer,this.numChildren - 1);
         this.textContainer.visible = true;
         this.centraliseBarValue = true;
      }
      
      public function removeBarClickability() : void
      {
         this.overlayContainer.removeEventListener(MouseEvent.CLICK,this.handleOverlayClick);
         this.overlayContainer.useHandCursor = false;
         this.overlayContainer.buttonMode = false;
         this.iconContainer.buttonMode = false;
         this.overlayContainer.buttonMode = false;
      }
      
      private function toggleTextVisibility() : void
      {
         var _loc1_:Boolean = this.backGroundContainer.visible;
         this.backGroundContainer.visible = !_loc1_;
         this.textContainer.visible = _loc1_;
         this.backGroundContainer.alpha = 0;
         this.textContainer.alpha = 0;
         TweenLite.to(this.backGroundContainer,0.5,{"alpha":int(this.backGroundContainer.visible)});
         TweenLite.to(this.textContainer,0.5,{"alpha":int(this.textContainer.visible)});
      }
      
      private function handleOverlayClick(param1:MouseEvent) : void
      {
         this.toggleTextVisibility();
      }
      
      private function updateComponent(param1:int) : void
      {
         this.backGroundContainer.graphics.clear();
         this.barContainer.graphics.clear();
         if(this.barConfigVo.solidBackground)
         {
            this.backGroundContainer.graphics.beginFill(this.barConfigVo.backgroundColor,1);
            this.backGroundContainer.graphics.drawRect(0,0,this.barConfigVo.totalbarWidth,this.barConfigVo.totalbarHeight);
            this.backGroundContainer.graphics.endFill();
         }
         else
         {
            this.backGroundContainer.graphics.lineStyle(1,this.barConfigVo.backgroundColor);
            this.backGroundContainer.graphics.moveTo(0,0);
            this.backGroundContainer.graphics.lineTo(this.barConfigVo.totalbarWidth,0);
            this.backGroundContainer.graphics.lineTo(this.barConfigVo.totalbarWidth,this.barConfigVo.totalbarHeight);
            this.backGroundContainer.graphics.lineTo(0,this.barConfigVo.totalbarHeight);
            this.backGroundContainer.graphics.lineTo(0,0);
         }
         if(this.barConfigVo.solidBackground)
         {
            this.barContainer.graphics.beginFill(this.barConfigVo.barColor,1);
            this.barContainer.graphics.drawRect(0,0,1,this.barConfigVo.totalbarHeight - this.barConfigVo.gap * 2);
            this.barContainer.graphics.endFill();
            this.barContainer.x = this.barContainer.y = this.barConfigVo.gap;
         }
         else
         {
            this.barContainer.graphics.beginFill(this.barConfigVo.barColor,1);
            this.barContainer.graphics.drawRect(0,0,1,this.barConfigVo.totalbarHeight - 1 - this.barConfigVo.gap);
            this.barContainer.graphics.endFill();
            this.barContainer.x = this.barContainer.y = this.barConfigVo.gap;
         }
         this.redrawOverlayContainer(this.backGroundContainer.x);
         switch(this.barConfigVo.textlayout)
         {
            case BarConfigVO.TEXTLAYOUT_VALUE_OF_TOTLA:
               this.barValue.text = TextFormatter.roundInteger(this.currentAmount) + "/" + TextFormatter.roundInteger(this.maxAmount);
               break;
            case BarConfigVO.TEXTLAYOUT_VALUE_ONLY:
            default:
               this.barValue.text = TextFormatter.roundInteger(this.currentAmount);
         }
         TweenLite.to(this.barContainer,0.5,{"width":param1});
      }
      
      private function redrawOverlayContainer(param1:int) : void
      {
         this.overlayContainer.graphics.clear();
         this.overlayContainer.graphics.beginFill(0,0);
         this.overlayContainer.graphics.drawRect(param1,0,this.barConfigVo.totalbarWidth,this.barConfigVo.totalbarHeight * 4);
         this.overlayContainer.graphics.endFill();
      }
      
      public function updateBarValueSeparately(param1:Number) : void
      {
         this.barValue.text = "x " + param1;
         if(this.centraliseBarValue)
         {
            this.barValue.x = this.barContainer.x + this.barConfigVo.totalbarWidth / 2 - this.barValue.width / 2;
            this.barValue.y = this.barContainer.y - 2;
         }
      }
      
      public function update(param1:Number, param2:Number) : void
      {
         if(param1 > param2)
         {
            param1 = param2;
         }
         this.currentAmount = param1;
         this.maxAmount = param2;
         this.currentBarWidth = (this.barConfigVo.totalbarWidth - 2 * this.barConfigVo.gap) * param1 / param2;
         this.updateComponent(this.currentBarWidth);
         if(this.toolTipHook != null)
         {
            if(param2 == 0)
            {
               this.toolTipHook.updateText(this.toolTipBase);
            }
            else
            {
               this.toolTipHook.updateText(this.toolTipBase + "\n" + TextFormatter.roundInteger(param1) + "|" + TextFormatter.roundInteger(param2));
            }
         }
         if(this.changeColorWithBarLength)
         {
            this.updateBarColor();
         }
      }
      
      public function setPadding(param1:Number) : void
      {
         this.defaultPadding = param1;
         this.updateLayout();
      }
      
      public function pulseTheBar(param1:int = -1, param2:Number = 0.2) : void
      {
         this.pulsing = true;
         this.currentPulse = 0;
         this.numberOfPulses = param1;
         this.pulseFrequency = param2;
         this.handlePulseUp();
      }
      
      private function handlePulseUp() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Sprite = null;
         if(this.pulsing)
         {
            if(this.numberOfPulses != -1)
            {
               ++this.currentPulse;
            }
            _loc1_ = 3;
            _loc2_ = this;
            if(this.barConfigVo.flashType == BarConfigVO.FLASH_TYPE_SECTOR_CONTROL)
            {
               _loc1_ = 1.5;
               _loc2_ = this.backGroundContainer;
            }
            TweenMax.to(_loc2_,this.pulseFrequency,{
               "colorMatrixFilter":{"brightness":_loc1_},
               "ease":Linear.easeNone,
               "onComplete":this.handlePulseDown
            });
         }
      }
      
      private function handlePulseDown() : void
      {
         var _loc1_:Sprite = this;
         if(this.barConfigVo.flashType == BarConfigVO.FLASH_TYPE_SECTOR_CONTROL)
         {
            _loc1_ = this.backGroundContainer;
         }
         if(this.pulsing)
         {
            if(this.numberOfPulses == -1 || this.currentPulse < this.numberOfPulses)
            {
               TweenMax.to(_loc1_,this.pulseFrequency + 0.2,{
                  "colorMatrixFilter":{"brightness":1},
                  "ease":Linear.easeNone,
                  "onComplete":this.handlePulseUp
               });
            }
            else
            {
               TweenMax.to(_loc1_,this.pulseFrequency + 0.2,{
                  "colorMatrixFilter":{"brightness":1},
                  "ease":Linear.easeNone
               });
               this.pulsing = false;
            }
         }
         else
         {
            TweenMax.to(this,this.pulseFrequency + 0.2,{
               "colorMatrixFilter":{"brightness":1},
               "ease":Linear.easeNone
            });
         }
      }
      
      public function setTimeInSec(param1:int) : void
      {
         this.currentTimeInSeconds = param1;
         if(this.genericTimer != null)
         {
            this.stopTimer();
         }
         var _loc2_:int = Math.round(10 * this.currentTimeInSeconds);
         this.genericTimer = new Timer(100,_loc2_);
         this.genericTimer.addEventListener(TimerEvent.TIMER,this.handleTimerTick);
         this.genericTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.handleTimerFinished);
         this.genericTimer.start();
         this.localSecsElapsed = 1;
      }
      
      private function handleTimerFinished(param1:TimerEvent) : void
      {
         this.stopTimer();
      }
      
      private function handleTimerTick(param1:TimerEvent) : void
      {
         this.localSecsElapsed += this.updateInterval;
         var _loc2_:Number = this.currentTimeInSeconds - this.localSecsElapsed;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ == 0 && this.genericTimer != null)
         {
            this.stopTimer();
         }
         if(_loc2_ <= this.flashBelowThreshold && _loc2_ > 0 && this.pulsing == false)
         {
            this.pulseTheBar();
         }
         this.setBarLengthToTimer(_loc2_);
      }
      
      private function setBarLengthToTimer(param1:Number) : void
      {
         this.update(param1,this.maxAmount);
      }
      
      private function stopTimer() : void
      {
         this.pulsing = false;
         this.genericTimer.stop();
         this.genericTimer.removeEventListener(TimerEvent.TIMER,this.handleTimerTick);
         this.genericTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.handleTimerFinished);
         this.genericTimer = null;
      }
      
      private function updateBarColor() : void
      {
         var _loc1_:Number = this.currentAmount / this.maxAmount;
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = ColorUtils.interpolate(this.barConfigVo.barColor,this.barConfigVo.borderColor,_loc1_);
         this.barContainer.transform.colorTransform = _loc2_;
      }
      
      public function setSize(param1:int, param2:int) : void
      {
         this.barConfigVo.totalbarWidth = param1;
         this.barConfigVo.totalbarHeight = param2;
         this.updateComponent(this.currentBarWidth);
      }
      
      public function setColor(param1:uint) : void
      {
         this.barConfigVo.barColor = param1;
         this.updateComponent(this.currentBarWidth);
      }
      
      public function setSecondaryColor(param1:uint) : void
      {
         this.barConfigVo.borderColor = param1;
         this.changeColorWithBarLength = true;
      }
      
      public function set maxBarColor(param1:uint) : void
      {
         this.barConfigVo.borderColor = param1;
      }
      
      public function updateIcon(param1:Bitmap) : void
      {
         if(Boolean(this.icon) && Boolean(this.icon.parent))
         {
            this.icon.parent.removeChild(this.icon);
         }
         this.icon = param1;
         this.checkIcon();
         this.updateLayout();
      }
   }
}

