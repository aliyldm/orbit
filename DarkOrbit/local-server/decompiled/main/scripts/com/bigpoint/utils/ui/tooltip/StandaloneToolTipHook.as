package com.bigpoint.utils.ui.tooltip
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.Styles;
   
   public class StandaloneToolTipHook
   {
      
      private static const _instance:StandaloneToolTipHook = new StandaloneToolTipHook();
      
      private static const MAX_TOOLTIP_WIDTH:int = 300;
      
      private static const SHOW_DELAY:int = 500;
      
      private static const HIDE_DELAY:int = 100;
      
      private var _labelF:TextField;
      
      private var _container:DisplayObjectContainer;
      
      private var _timeoutId:int;
      
      public function StandaloneToolTipHook()
      {
         super();
      }
      
      public static function getInstance() : StandaloneToolTipHook
      {
         return _instance;
      }
      
      public function init(param1:DisplayObjectContainer) : void
      {
         this._container = param1;
      }
      
      public function show(param1:String, param2:Boolean = false, param3:Number = 500) : void
      {
         if(this._labelF == null)
         {
            this.createToolTipTextField();
         }
         if(param2)
         {
            this._labelF.htmlText = param1;
         }
         else
         {
            this._labelF.text = param1;
         }
         clearTimeout(this._timeoutId);
         if(param3 <= 0)
         {
            this.showTooltip();
         }
         else
         {
            this._timeoutId = setTimeout(this.showTooltip,param3);
         }
      }
      
      public function hide(param1:Number = 100) : void
      {
         clearTimeout(this._timeoutId);
         if(Boolean(this._labelF) && Boolean(this._labelF.parent))
         {
            if(param1 <= 0)
            {
               this.hideTooltip();
            }
            else
            {
               this._timeoutId = setTimeout(this.hideTooltip,param1);
            }
         }
      }
      
      private function showTooltip(param1:TimerEvent = null) : void
      {
         this.updateTextFieldWidth();
         this._labelF.x = this._container.mouseX + 10;
         this._labelF.y = this._container.mouseY - this._labelF.height - 10;
         var _loc2_:Rectangle = new Rectangle(0,0,this._container.stage.stageWidth,this._container.stage.stageHeight);
         if(this._labelF.x + this._labelF.width > _loc2_.width)
         {
            this._labelF.x = this._container.mouseX - this._labelF.width - 10;
         }
         if(this._labelF.y - this._labelF.height < 0)
         {
            this._labelF.y = this._container.mouseY + 10;
         }
         this._container.addChild(this._labelF);
      }
      
      private function hideTooltip(param1:TimerEvent = null) : void
      {
         clearTimeout(this._timeoutId);
         this._container.removeChild(this._labelF);
      }
      
      private function createToolTipTextField() : DisplayObject
      {
         this._labelF = new TextField();
         this._labelF.embedFonts = false;
         if(Styles.baseEmbed)
         {
            this._labelF.defaultTextFormat = Styles.tooltipFmt;
         }
         else
         {
            this._labelF.defaultTextFormat = Styles.tooltipFmtDeviceFonts;
         }
         this._labelF.autoSize = TextFieldAutoSize.LEFT;
         this._labelF.textColor = 13421772;
         this._labelF.backgroundColor = 0;
         this._labelF.background = true;
         this._labelF.border = true;
         this._labelF.borderColor = 1873341;
         this._labelF.antiAliasType = AntiAliasType.ADVANCED;
         this._labelF.selectable = false;
         this._labelF.mouseEnabled = false;
         return this._labelF;
      }
      
      private function updateTextFieldWidth() : void
      {
         this._labelF.wordWrap = false;
         this._labelF.multiline = false;
         this._labelF.autoSize = TextFieldAutoSize.LEFT;
         if(this._labelF.width > MAX_TOOLTIP_WIDTH)
         {
            this._labelF.width = MAX_TOOLTIP_WIDTH;
            this._labelF.wordWrap = true;
            this._labelF.multiline = true;
         }
      }
   }
}

