package net.bigpoint.darkorbit.gui.elements
{
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import mx.utils.StringUtil;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.BarState;
   import net.bigpoint.darkorbit.gui.BarStatesCollection;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.net.ClientCommands;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class InfoField extends SimpleElement
   {
      
      public static var FIELD_SEPERATOR:String = "|";
      
      public static var MODE_BAR:int = 0;
      
      public static var MODE_TEXT:int = 1;
      
      private var guiManager:GuiManager;
      
      private var icon:Bitmap;
      
      private var _textField:TextField;
      
      private var viewMode:int = MODE_BAR;
      
      public var languageKey:String;
      
      private var textFieldWidth:int;
      
      private var barKeys:Array;
      
      private var _counterBars:Array = [];
      
      private var _barMasks:Array;
      
      private var toolTipHook:ToolTipHook;
      
      private var bg:Bitmap;
      
      private var textColor:int;
      
      public var amountSearchPattern:RegExp;
      
      private var currentTimeInSeconds:int;
      
      private var genericTimer:Timer;
      
      private var localSecsElapsed:int;
      
      private var label:String;
      
      private var _lineCount:int;
      
      public function InfoField(param1:GuiManager, param2:int, param3:Bitmap, param4:int = -1, param5:Array = null, param6:String = null, param7:int = 0, param8:int = 1)
      {
         super(param2);
         this.guiManager = param1;
         this.icon = param3;
         if(param6 != null)
         {
            this.createTooltip(BPLocale.getItem(param6));
         }
         this.languageKey = param6;
         this.barKeys = param5;
         this.textFieldWidth = param4;
         this.viewMode = param7;
         this._lineCount = param8;
         this.init();
      }
      
      public function setCounterbarVisibility(param1:int, param2:Boolean) : void
      {
         var _loc3_:Bitmap = this._counterBars[param1];
         _loc3_.visible = param2;
      }
      
      public function createTooltip(param1:String) : void
      {
         this.toolTipHook = TooltipControl.getInstance().addToolTip(this,param1);
      }
      
      public function updateIcon(param1:Bitmap) : void
      {
         this.removeChild(this.icon);
         this.icon = param1;
         this.addChild(this.icon);
      }
      
      public function setTextfieldPulse(param1:Number) : void
      {
         TweenMax.to(this._textField,param1,{
            "yoyo":true,
            "repeat":-1,
            "alpha":1,
            "ease":Linear.easeNone,
            "startAt":{"alpha":0.2}
         });
      }
      
      public function removeTextfieldPulse() : void
      {
         TweenMax.killTweensOf(this._textField);
         this._textField.alpha = 1;
      }
      
      public function init() : void
      {
         var _loc1_:Bitmap = null;
         var _loc2_:String = null;
         var _loc3_:Bitmap = null;
         var _loc4_:Sprite = null;
         addChild(this.icon);
         if(id == TYPE_CLAN_RANKED_CLAN_POINTS)
         {
            _loc1_ = ResourceManager.getBitmap("ui","cbInfoIcon_timer");
            _loc1_.name = "CLOCK_ICON";
            _loc1_.x = this.icon.width + 5;
            _loc1_.visible = false;
            addChild(_loc1_);
         }
         this._textField = new TextField();
         this._textField.wordWrap = this._lineCount > 1;
         this._textField.defaultTextFormat = Styles.infoFieldFmt;
         this._textField.embedFonts = Styles.infoFieldEmbed;
         this._textField.antiAliasType = AntiAliasType.ADVANCED;
         this._textField.mouseEnabled = false;
         this._textField.selectable = false;
         this.textColor = int(Styles.infoFieldFmt.color);
         if(this.textFieldWidth == -1)
         {
            this._textField.autoSize = TextFieldAutoSize.LEFT;
         }
         else
         {
            this._textField.width = this.textFieldWidth;
            this._textField.defaultTextFormat = Styles.infoFieldFixedFmt;
         }
         this._textField.textColor = this.textColor;
         this._textField.height = 20 * this._lineCount;
         this._textField.x = this.icon.width + 5;
         this._textField.y = height * 0.1;
         if(this.barKeys != null)
         {
            this.bg = ResourceManager.getBitmap("ui","bar_background");
            this.bg.x = this.icon.width + 5;
            this.bg.y = this.icon.height / 2 - 13 / 2;
            addChild(this.bg);
            this._barMasks = new Array();
            for each(_loc2_ in this.barKeys)
            {
               _loc3_ = ResourceManager.getBitmap("ui",_loc2_);
               _loc3_.x = this.icon.width + 5;
               _loc3_.y = this.icon.height / 2 - _loc3_.height / 2;
               this._counterBars.push(_loc3_);
               _loc4_ = new Sprite();
               this._barMasks.push(_loc4_);
               _loc4_.graphics.beginFill(65535);
               _loc4_.graphics.drawRect(0,0,62,14);
               _loc4_.graphics.endFill();
               _loc4_.x = this.icon.width + 5;
               _loc4_.y = this.icon.height / 2 - 13 / 2;
               addChild(_loc4_);
            }
            addEventListener(MouseEvent.CLICK,this.onClick);
            buttonMode = true;
         }
         if(id == TYPE_CONFIGURATION)
         {
            this.addEventListener(MouseEvent.CLICK,this.handleConfigurationChange);
            this.buttonMode = true;
         }
         this.updateView();
      }
      
      public function cleanup() : void
      {
         if(this.id == TYPE_CONFIGURATION)
         {
            this.removeEventListener(MouseEvent.CLICK,this.handleConfigurationChange);
         }
         if(this.toolTipHook != null)
         {
            TooltipControl.getInstance().removeToolTip(this);
         }
      }
      
      private function handleConfigurationChange(param1:MouseEvent) : void
      {
         var _loc2_:int = Settings.selectedConfiguration;
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_COMMAND,[ClientCommands.SELECT,[ClientCommands.CONFIGURATION,(_loc2_ == 2 ? 1 : 2).toString(),Hero.userID.toString(),Hero.sessionID.toString()]]);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this.viewMode == MODE_BAR)
         {
            this.viewMode = MODE_TEXT;
         }
         else if(this.viewMode == MODE_TEXT)
         {
            this.viewMode = MODE_BAR;
         }
         this.updateView();
         var _loc2_:BarState = BarStatesCollection.getBarState(this.id);
         if(_loc2_ != null)
         {
            _loc2_.stateID = this.viewMode;
         }
         else
         {
            BarStatesCollection.addBarState(new BarState(this.id,this.viewMode));
         }
         GameFacade.getInstance().sendNotification(GuiNotifications.SAVE_BARS_SETTINGS);
      }
      
      public function getViewMode() : int
      {
         return this.viewMode;
      }
      
      public function setViewMode(param1:int) : void
      {
         if(this.viewMode != param1)
         {
            this.viewMode = param1;
            this.updateView();
         }
      }
      
      public function updateView() : void
      {
         var _loc1_:Bitmap = null;
         if(this.viewMode == MODE_BAR && this.barKeys != null)
         {
            for each(_loc1_ in this._counterBars)
            {
               this.addChild(_loc1_);
               _loc1_.alpha = 0;
               TweenLite.to(_loc1_,0.25,{"alpha":1});
            }
            if(this.bg != null)
            {
               if(!this.contains(this.bg))
               {
                  this.addChild(this.bg);
                  this.setChildIndex(this.bg,0);
               }
            }
            if(this.contains(this._textField))
            {
               this.removeChild(this._textField);
            }
         }
         else
         {
            for each(_loc1_ in this._counterBars)
            {
               if(_loc1_ != null && this.contains(_loc1_))
               {
                  this.removeChild(_loc1_);
               }
            }
            if(this.bg != null)
            {
               if(this.contains(this.bg))
               {
                  this.removeChild(this.bg);
               }
            }
            addChild(this._textField);
            this._textField.alpha = 0;
            TweenMax.to(this._textField,0.25,{"alpha":1});
         }
         if(this.textFieldWidth == -1)
         {
            this._textField.autoSize = TextFieldAutoSize.LEFT;
         }
      }
      
      public function setLabel(param1:String) : void
      {
         this._textField.text = StringUtil.trim(param1);
      }
      
      public function setColor(param1:int) : void
      {
         this.textColor = param1;
         this._textField.textColor = this.textColor;
      }
      
      public function setText(param1:String, param2:Boolean = true) : void
      {
         if(this.toolTipHook != null)
         {
            if(param2)
            {
               this.toolTipHook.updateText(BPLocale.getItem(this.languageKey) + "\n" + param1);
            }
            else if(this.amountSearchPattern != null)
            {
               this.toolTipHook.updateText(BPLocale.getItem(this.languageKey).replace(this.amountSearchPattern,param1));
            }
            else
            {
               this.toolTipHook.updateText(BPLocale.getItem(this.languageKey));
            }
         }
      }
      
      public function updateTooltip(param1:String) : void
      {
         if(this.toolTipHook != null)
         {
            this.toolTipHook.updateText(param1);
         }
      }
      
      public function setCounterbar(param1:int, param2:int, param3:Boolean = true, param4:int = 0) : void
      {
         var _loc7_:Number = NaN;
         var _loc5_:Bitmap = this._counterBars[param4];
         var _loc6_:Sprite = this._barMasks[param4];
         if(Boolean(_loc5_) && Boolean(_loc6_))
         {
            _loc5_.mask = _loc6_;
            if(param2 == 0)
            {
               _loc6_.width = 62;
               return;
            }
            _loc7_ = param1 * 62 / param2;
            if(param3)
            {
               TweenLite.to(_loc6_,0.5,{"width":_loc7_});
            }
            else
            {
               _loc6_.width = _loc7_;
            }
         }
      }
      
      public function setTimeInSec(param1:int, param2:String = "") : void
      {
         this.label = param2;
         this.currentTimeInSeconds = param1;
         if(this.genericTimer != null)
         {
            this.stopTimer();
         }
         this.genericTimer = new Timer(1000,0);
         this.genericTimer.addEventListener(TimerEvent.TIMER,this.handleTimerTick);
         this.genericTimer.start();
         this.localSecsElapsed = 1;
      }
      
      private function handleTimerTick(param1:TimerEvent) : void
      {
         var _loc2_:int = this.currentTimeInSeconds - this.localSecsElapsed++;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ == 0 && this.genericTimer != null)
         {
            this.stopTimer();
         }
         this.setTimer(_loc2_);
      }
      
      private function setTimer(param1:int) : void
      {
         this.setLabel(TimeFormatter.formatTime(param1));
      }
      
      private function stopTimer() : void
      {
         this.genericTimer.stop();
         this.genericTimer.removeEventListener(TimerEvent.TIMER,this.handleTimerTick);
      }
      
      public function get textField() : TextField
      {
         return this._textField;
      }
   }
}

