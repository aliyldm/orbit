package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement
{
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.countDownTimer.CountDownEvent;
   import com.bigpoint.utils.drag.DragEvent;
   import com.bigpoint.utils.drag.IDragablePreview;
   import com.bigpoint.utils.drag.IDraggable;
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.getTimer;
   import mx.utils.MatrixUtil;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.mvc.common.view.components.TextureAtlasBitmapFont;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.ItemVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.abstract.AbstractMenuElement;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.counterDots.CounterDots;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.dragPreview.DragPreview;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.dragPreview.DragPreviewRounded;
   
   public class SlotAndItemBarElement extends AbstractMenuElement implements IDraggable
   {
      
      private static const LINKAGE:String = "slotAndItemBarElement";
      
      private static const DRAG_DELAY:int = 60;
      
      public static const ITEM_CLICKED:String = "itemClicked";
      
      public static const ITEM_DOUBLECLICKED:String = "itemDoubleClicked";
      
      public static const DEFAULT_SIZE:int = 39;
      
      public static const NEW_GAME_BTN_POS_Y:* = 57;
      
      private static const COUNTER_FONT_CONTAINER:String = "counterFontContainer";
      
      private static const COUNTER_BAR:String = "counterBar";
      
      private static const COUNTER_DOTS:String = "counterDots";
      
      private static const ACTIVE_OVERLAY:String = "activeOverlay";
      
      private static const COOLDOWN_TIMER_OVERLAY:String = "cooldownTimerOverlay";
      
      private static const ACTIVE_TIME_COUNTER_F:String = "activeTimerCounterF";
      
      private static const BRIGHT_BACKGROUND:String = "brightBackground";
      
      private static const BLOCKED_STATE:String = "blockedState";
      
      private static const RED_BLINK:String = "noSwitchingAmmoWarn";
      
      private static const SELECTED_STATE_ROUND:String = "selectedStateRound";
      
      private static const ROLL_OVER_STATE_ROUND:String = "rollOverStateRound";
      
      private static const MOUSE_DOWN_STATE_ROUND:String = "mouseDownStateRound";
      
      private static const BACKGROUND_ROUND:String = "backgroundRound";
      
      private static const BRIGHT_BACKGROUND_ROUND:String = "brightBackgroundRound";
      
      private static const BLOCKED_STATE_ROUND:String = "blockedStateRound";
      
      private static const RED_BLINK_ROUND:String = "noSwitchingAmmoWarnRound";
      
      public var atlasBitmapFont:TextureAtlasBitmapFont;
      
      public var counterFontContainer:Sprite;
      
      public var counterBar:ProgressBar;
      
      public var counterDots:CounterDots;
      
      public var activeOverlay:Sprite;
      
      public var cooldownTimerOverlay:TimerOverlay;
      
      public var activeTimerCounterF:TextField;
      
      public var brightBackground:Sprite;
      
      public var blockedState:Sprite;
      
      public var noSwitchingAmmoWarn:Sprite;
      
      public var selectedStateRound:Sprite;
      
      public var rollOverStateRound:Sprite;
      
      public var mouseDownStateRound:Sprite;
      
      public var backgroundRound:Sprite;
      
      public var brightBackgroundRound:Sprite;
      
      public var blockedStateRound:Sprite;
      
      public var noSwitchingAmmoWarnRound:Sprite;
      
      private var _itemVO:ItemVO;
      
      private var _dragStartTime:Number;
      
      private var _tooltipHook:ToolTipHook;
      
      private var _tooltipText:String;
      
      private var _categoryMode:Boolean;
      
      public function SlotAndItemBarElement(param1:SWFFinisher, param2:ItemVO, param3:BitmapData, param4:String, param5:Boolean = false)
      {
         super(param1,this.symbolLinkage);
         this.updateMode(param5);
         setVisibilities(new <DisplayObject>[this.counterFontContainer,this.counterBar,this.counterDots,this.activeTimerCounterF,this.activeOverlay,this.cooldownTimerOverlay,this.blockedState,this.noSwitchingAmmoWarn],false);
         this.setData(param2,param3,param4);
         doubleClickEnabled = true;
         this.noSwitchingAmmoWarn.mouseEnabled = false;
         this.activeTimerCounterF.mouseEnabled = false;
         this.cooldownTimerOverlay.init(0,0.6);
      }
      
      override public function decorate() : void
      {
         addViewChild(this.brightBackground = getSpriteChild(BRIGHT_BACKGROUND));
         addViewChild(this.brightBackgroundRound = getSpriteChild(BRIGHT_BACKGROUND_ROUND));
         addViewChild(background = getSpriteChild(backgroundLinkage,true));
         addViewChild(this.backgroundRound = getSpriteChild(BACKGROUND_ROUND));
         super.decorate();
         addViewChild(rollOverState = getSpriteChild(rollOverStateLinkage));
         addViewChild(this.rollOverStateRound = getSpriteChild(ROLL_OVER_STATE_ROUND));
         addViewChild(mouseDownState = getSpriteChild(mouseDownStateLinkage));
         addViewChild(this.mouseDownStateRound = getSpriteChild(MOUSE_DOWN_STATE_ROUND));
         addViewChild(selectedState = getSpriteChild(selectedStateLinkage,true));
         addViewChild(this.selectedStateRound = getSpriteChild(SELECTED_STATE_ROUND));
         addViewChild(labelF = getTextFieldChild("labelF",true));
         addViewChild(this.counterFontContainer = getSpriteChild(COUNTER_FONT_CONTAINER));
         addViewChild(this.counterBar = new ProgressBar(getSpriteChild(COUNTER_BAR)));
         addViewChild(this.counterDots = new CounterDots(getSpriteChild(COUNTER_DOTS),_swfFinisher));
         addViewChild(this.activeOverlay = getSpriteChild(ACTIVE_OVERLAY));
         addViewChild(this.cooldownTimerOverlay = new TimerOverlay(getSpriteChild(COOLDOWN_TIMER_OVERLAY)));
         addViewChild(this.activeTimerCounterF = getTextFieldChild(ACTIVE_TIME_COUNTER_F));
         this.counterFontContainer.addChild(this.atlasBitmapFont = new TextureAtlasBitmapFont());
         addViewChild(this.blockedState = getSpriteChild(BLOCKED_STATE));
         addViewChild(this.blockedStateRound = getSpriteChild(BLOCKED_STATE_ROUND));
         addViewChild(this.noSwitchingAmmoWarn = getSpriteChild(RED_BLINK));
         addViewChild(this.noSwitchingAmmoWarnRound = getSpriteChild(RED_BLINK_ROUND));
      }
      
      public function setData(param1:ItemVO, param2:BitmapData, param3:String) : void
      {
         if(this._itemVO == null || Boolean(this._itemVO) && Boolean(this._itemVO.iconLootId != param1.iconLootId))
         {
            placeIcon(param2);
         }
         this._itemVO = param1;
         this.initCounter(this._itemVO.counterValue,this._itemVO.maxCounterValue,this._itemVO.counterType);
         if(!this._tooltipText)
         {
            this._tooltipHook = tooltipManager.addToolTip(this,this._tooltipText = param3,true);
         }
         else
         {
            this._tooltipHook.updateText(this._tooltipText = param3);
         }
         this.updateTimerAndActivatable();
         this.updateSelection();
         this.updateBuyable();
         this.updateBlockade();
      }
      
      private function updateBuyable() : void
      {
         this.brightBackground.visible = this._itemVO.buyable;
         background.visible = !this._itemVO.buyable;
         if(this._itemVO.buyable)
         {
            this.counterFontContainer.x = int((DEFAULT_SIZE - this.counterFontContainer.width) / 2) - 1;
            this.counterFontContainer.y = 3;
            this.atlasBitmapFont.setColor(ItemsControlMenuConstants.STYLE_YELLOW);
         }
      }
      
      public function updateTimerAndActivatable() : void
      {
         if(this._itemVO.hasCountDownTimer)
         {
            this.clearTimerListeners();
            if(this._itemVO.timerVO.timerState == ItemsControlMenuConstants.TIMER_STATE_COOLING_DOWN)
            {
               this._itemVO.timerVO.countDownTimer.addCountDownEventEventListener(CountDownEvent.COUNT_DOWN_TICK,this.cooldownTickHandler,false,0,true);
               this._itemVO.timerVO.countDownTimer.addEventListener(CountDownEvent.COUNT_DOWN_FINISH,this.cooldownOrActiveCoundDownFinishHandler,false,0,true);
            }
            else
            {
               this.activeTimerCounterF.visible = true;
               this._itemVO.timerVO.countDownTimer.addCountDownEventEventListener(CountDownEvent.COUNT_DOWN_TICK,this.activeTickHandler,false,0,true);
               this._itemVO.timerVO.countDownTimer.addEventListener(CountDownEvent.COUNT_DOWN_FINISH,this.cooldownOrActiveCoundDownFinishHandler,false,0,true);
            }
         }
         else
         {
            this.cooldownTimerOverlay.progress = 0;
            setVisibility(false,this.activeOverlay);
            this.activeTimerCounterF.visible = false;
         }
         this.updateActivatability();
      }
      
      private function updateActivatability() : void
      {
         var _loc1_:Boolean = false;
         if(!_duringHighlight)
         {
            _loc1_ = !this._itemVO.activatable || this._itemVO.hasCountDownTimer;
            setGreyness(this,_loc1_ ? 0.2 : 1,_loc1_ ? 0.8 : 1);
         }
         if(!this._itemVO.activatable)
         {
            setVisibility(false,rollOverState);
            this.counterBar.removeHighlight(ItemsControlMenuConstants.STYLE_BLUE);
         }
         this.atlasBitmapFont.setColor(this.itemVO.counterStyle);
         if(this._itemVO.counterType == ItemsControlMenuConstants.COUNTER_TYPE_COUNTER_DOTS)
         {
            setVisibility(this._itemVO.activatable,this.counterDots);
         }
      }
      
      private function updateBlockade() : void
      {
         this.blockedState.visible = this._itemVO.blocked;
      }
      
      private function cooldownTickHandler(param1:CountDownEvent) : void
      {
         this.activeTimerCounterF.visible = false;
         var _loc2_:int = Math.max(1,100 - Math.floor(param1.timeLeft / this._itemVO.timerVO.maxTime * 100));
         this.cooldownTimerOverlay.progress = _loc2_;
         this.updateTooltip(param1,BPLocale.getItem("cooldown_remaining"));
      }
      
      private function activeTickHandler(param1:CountDownEvent) : void
      {
         var _loc2_:int = Math.max(1,100 - Math.floor(param1.timeLeft / this._itemVO.timerVO.maxTime * 100));
         setVisibility(_loc2_ < 99,this.activeOverlay);
         var _loc3_:String = param1.timeLeftSec ? TimeFormatter.formatTime(param1.timeLeftSec) : "";
         this.activeTimerCounterF.text = _loc3_;
         this.updateTooltip(param1);
      }
      
      private function cooldownOrActiveCoundDownFinishHandler(param1:CountDownEvent) : void
      {
         this.updateActivatability();
         this.clearTimerListeners();
         this.updateTooltip(param1);
      }
      
      private function initCounter(param1:Number, param2:Number, param3:String) : void
      {
         var _loc4_:Number = NaN;
         switch(param3)
         {
            case ItemsControlMenuConstants.COUNTER_TYPE_COUNTER_BAR:
               _loc4_ = this._itemVO.activatable ? this._itemVO.counterStyle : ItemsControlMenuConstants.STYLE_BLUE;
               this.counterBar.setProgress(Math.min(param1,param2),param2,ItemsControlMenuConstants.STYLE_BLUE,_loc4_);
               this.atlasBitmapFont.setValue(param1.toString(),_loc4_);
               this.counterFontContainer.visible = true;
               break;
            case ItemsControlMenuConstants.COUNTER_TYPE_COUNTER_DOTS:
               this.counterDots.setProgress(Math.min(param1,param2),param2,this._itemVO.counterStyle,this._itemVO.activatable);
               break;
            case ItemsControlMenuConstants.COUNTER_TYPE_COUNTER_NUMBER:
               this.atlasBitmapFont.setValue(param1.toString(),ItemsControlMenuConstants.STYLE_BLUE);
               this.counterFontContainer.visible = true;
         }
      }
      
      private function updateSelection() : void
      {
         var _loc1_:Boolean = this._itemVO.actionStyle == ItemsControlMenuConstants.ACTION_SELECTION || this._itemVO.actionStyle == ItemsControlMenuConstants.ACTION_TOOGLE;
         setVisibility(_loc1_ && this._itemVO.selected,selectedState);
      }
      
      override protected function clickHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(ITEM_CLICKED,true));
      }
      
      override protected function doubleClickHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(ITEM_DOUBLECLICKED,true));
      }
      
      override public function mouseUpDownHandler(param1:MouseEvent) : void
      {
         super.mouseUpDownHandler(param1);
         if(param1.type == MouseEvent.MOUSE_DOWN)
         {
            this._dragStartTime = getTimer();
            addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         }
         if(param1.type == MouseEvent.MOUSE_UP)
         {
            removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         }
      }
      
      private function mouseMoveHandler(param1:MouseEvent) : void
      {
         var _loc2_:Number = getTimer() - this._dragStartTime;
         if(_loc2_ > DRAG_DELAY)
         {
            removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            dispatchEvent(new DragEvent(DragEvent.DRAG_START));
         }
      }
      
      override public function rollHandler(param1:MouseEvent) : void
      {
         if(this._itemVO.activatable)
         {
            super.rollHandler(param1);
            if(param1.type == MouseEvent.ROLL_OUT)
            {
               removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            }
         }
      }
      
      private function updateTooltip(param1:CountDownEvent, param2:String = null) : void
      {
         if(this._itemVO.showTooltipCooldownTimer)
         {
            if(param2)
            {
               param2 = param1.timeLeftSec ? "\n" + param2.replace("%TIME%",TimeFormatter.formatTime(param1.timeLeftSec)) : "";
            }
            else
            {
               param2 = param1.timeLeftSec ? "\n" + TimeFormatter.formatTime(param1.timeLeftSec) : "";
            }
            this._tooltipHook.updateText(this._tooltipText + (param2 ? param2 : ""));
         }
      }
      
      private function clearTimerListeners(param1:Event = null) : void
      {
         if(this._itemVO.timerVO.countDownTimer)
         {
            this._itemVO.timerVO.countDownTimer.removeEventListener(CountDownEvent.COUNT_DOWN_TICK,this.cooldownTickHandler);
            this._itemVO.timerVO.countDownTimer.removeEventListener(CountDownEvent.COUNT_DOWN_TICK,this.activeTickHandler);
            this._itemVO.timerVO.countDownTimer.removeEventListener(CountDownEvent.COUNT_DOWN_FINISH,this.cooldownOrActiveCoundDownFinishHandler);
         }
      }
      
      override protected function removeFromStageListener(param1:Event) : void
      {
         this.clearTimerListeners();
      }
      
      private function updateMode(param1:Boolean) : void
      {
         this._categoryMode = param1;
         this.selectedStateRound.visible = this.rollOverStateRound.visible = this.mouseDownStateRound.visible = this.blockedStateRound.visible = this.noSwitchingAmmoWarnRound.visible = this.backgroundRound.visible = this.brightBackgroundRound.visible = this._categoryMode;
         selectedState.visible = rollOverState.visible = mouseDownState.visible = this.blockedState.visible = this.noSwitchingAmmoWarn.visible = background.visible = this.brightBackground.visible = !this._categoryMode;
         if(this._categoryMode)
         {
            selectedState = this.selectedStateRound;
            rollOverState = this.rollOverStateRound;
            mouseDownState = this.mouseDownStateRound;
            this.blockedState = this.blockedStateRound;
            this.noSwitchingAmmoWarn = this.noSwitchingAmmoWarnRound;
            background = this.backgroundRound;
            this.brightBackground = this.brightBackgroundRound;
            hideUnusedStates();
         }
      }
      
      public function get preview() : IDragablePreview
      {
         setVisibilities(new <DisplayObject>[mouseDownState,selectedState,rollOverState,this.cooldownTimerOverlay,this.activeOverlay],false);
         var _loc1_:BitmapData = new BitmapData(DEFAULT_SIZE,DEFAULT_SIZE,true,0);
         _loc1_.draw(this,MatrixUtil.composeMatrix(-x));
         setVisibility(true,rollOverState,0);
         setVisibility(false,rollOverState);
         return this._categoryMode ? new DragPreviewRounded(_swfFinisher,new Bitmap(_loc1_)) : new DragPreview(_swfFinisher,new Bitmap(_loc1_));
      }
      
      override public function toString() : String
      {
         return "SlotAndItemElement, id: " + this._itemVO.id;
      }
      
      public function get data() : Object
      {
         return this._itemVO;
      }
      
      public function get asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      override public function get symbolLinkage() : String
      {
         return LINKAGE;
      }
      
      public function get dragOffset() : Point
      {
         return new Point();
      }
      
      public function get itemVO() : ItemVO
      {
         return this._itemVO;
      }
      
      override public function get width() : Number
      {
         return DEFAULT_SIZE;
      }
      
      override public function get height() : Number
      {
         return DEFAULT_SIZE;
      }
   }
}

