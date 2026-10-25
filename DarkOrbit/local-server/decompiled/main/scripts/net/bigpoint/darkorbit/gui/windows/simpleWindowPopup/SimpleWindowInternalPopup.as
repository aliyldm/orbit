package net.bigpoint.darkorbit.gui.windows.simpleWindowPopup
{
   import com.bigpoint.utils.ui.panels.HPanel;
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   
   public class SimpleWindowInternalPopup extends Sprite
   {
      
      private static const LEFT_MARGIN:int = 8;
      
      public static const FIXED_POPUP_HEIGHT:int = 140;
      
      private var _hPanel:HPanel;
      
      private var _uiResources:SWFFinisher;
      
      private var _btnsOptionsMap:Dictionary;
      
      private var _parentBackground:Sprite;
      
      private var _titleF:TextField;
      
      private var _messageF:TextField;
      
      private var _horizontalLineContainer:Sprite;
      
      public function SimpleWindowInternalPopup(param1:SWFFinisher, param2:Sprite)
      {
         super();
         this._uiResources = param1;
         this._parentBackground = param2;
         addChild(this._hPanel = new HPanel());
         addChild(this._horizontalLineContainer = new Sprite());
         this.initTextFields();
         alpha = 0;
         visible = false;
      }
      
      private function initTextFields() : void
      {
         addChild(this._titleF = new TextField());
         addChild(this._messageF = new TextField());
      }
      
      public function show(param1:String, param2:String, param3:Vector.<PopupOptionVO>, param4:int, param5:int) : void
      {
         var _loc6_:PopupOptionVO = null;
         var _loc7_:ButtonElement = null;
         this.setText(this._titleF,param1,Styles.h3Fmt,param4 - 2 * LEFT_MARGIN,Styles.h3FontHeight);
         this.setText(this._messageF,param2,Styles.plainStdFmt,param4 - 2 * LEFT_MARGIN,Styles.plainStdFontHeight);
         this._btnsOptionsMap = new Dictionary();
         this._hPanel.removeItems();
         for each(_loc6_ in param3)
         {
            _loc7_ = new ButtonElement(_loc6_.btnId,BPLocale.getItemInCategory(_loc6_.localLib,_loc6_.btnLabelTextKey),this._uiResources.getEmbeddedMovieClip("button1"));
            this._btnsOptionsMap[_loc7_] = _loc6_;
            this._hPanel.addItem(_loc7_,10,10);
            _loc7_.addEventListener(MouseEvent.CLICK,this.optionBtnClickHandler);
         }
         this.updateLayout(param4,param5);
         this.updateBgVisibility(true);
         this.tweenVisibility = true;
      }
      
      private function optionBtnClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:PopupOptionVO = this._btnsOptionsMap[param1.currentTarget];
         this.hide(false,_loc2_.showContentUnderPopupDelay);
         if(_loc2_.clickCallback != null)
         {
            _loc2_.clickCallback(_loc2_.clickCallbackParams);
         }
      }
      
      public function hide(param1:Boolean = true, param2:int = 0) : void
      {
         this.updateBgVisibility(false);
         if(param1)
         {
            this.tweenVisibility = false;
         }
         else
         {
            alpha = 0;
            visible = false;
         }
         setTimeout(dispatchEvent,param2,new SimpleWindowEvent(SimpleWindowEvent.HIDE_POPUP,false,true));
      }
      
      private function updateLayout(param1:int, param2:int) : void
      {
         this._hPanel.centerItems(param1);
         var _loc3_:int = param2 - (this._titleF.height + this._messageF.height + this._hPanel.height + 15) >> 1;
         this._titleF.y = _loc3_ - 5;
         this._titleF.x = LEFT_MARGIN + param1 - this._titleF.width >> 1;
         this.redrawHorizontalLine(this._titleF.y + this._titleF.height + 1,param1);
         this._messageF.y = this._horizontalLineContainer.y + 7;
         this._messageF.x = LEFT_MARGIN + param1 - this._messageF.width >> 1;
         this._hPanel.y = this._messageF.y + this._messageF.height + 20;
      }
      
      private function updateBgVisibility(param1:Boolean, param2:Boolean = false) : void
      {
         if(param2)
         {
            TweenLite.to(this._parentBackground,0.3,{"colorTransform":{
               "tint":0,
               "tintAmount":(param2 ? 0.8 : 0)
            }});
         }
         this._parentBackground.mouseChildren = this._parentBackground.mouseEnabled = !param1;
      }
      
      private function redrawHorizontalLine(param1:int, param2:int) : void
      {
         while(this._horizontalLineContainer.numChildren)
         {
            this._horizontalLineContainer.removeChildAt(0);
         }
         this._horizontalLineContainer.y = param1;
         var _loc3_:Sprite = new Sprite();
         _loc3_.graphics.lineStyle(1,8289918);
         _loc3_.graphics.moveTo(8,0);
         _loc3_.graphics.lineTo(param2 - 20,0);
         this._horizontalLineContainer.addChild(_loc3_);
      }
      
      private function setText(param1:TextField, param2:String, param3:TextFormat, param4:int, param5:int) : TextField
      {
         param3.align = TextFormatAlign.LEFT;
         param1.defaultTextFormat = param3;
         param1.width = param4;
         param1.embedFonts = Styles.windowTitleEmbed;
         param1.height = param5;
         param1.textColor = 15262143;
         param1.multiline = true;
         param1.wordWrap = true;
         param1.mouseEnabled = false;
         param1.antiAliasType = AntiAliasType.ADVANCED;
         param1.autoSize = TextFieldAutoSize.LEFT;
         param1.htmlText = param2;
         return param1;
      }
      
      private function set tweenVisibility(param1:Boolean) : void
      {
         TweenLite.to(this,0.3,{"autoAlpha":int(param1)});
      }
   }
}

