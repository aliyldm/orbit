package net.bigpoint.darkorbit.mvc.commandCenter.view.state
{
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.commandCenter.constants.CommandCenterConsts;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.CommandCenterCategory;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.CommandCenterModel;
   import net.bigpoint.darkorbit.mvc.gui.highlights.HighLightItemNotification;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   
   public class CommandCenterStateView
   {
      
      private var _window:SimpleWindow;
      
      private var _model:CommandCenterModel;
      
      private var _localHighlightState:int = 0;
      
      private var ttip:CommandCenterTTipController = new CommandCenterTTipController();
      
      private var _lastTryNotificationPointer:uint;
      
      public function CommandCenterStateView(param1:SimpleWindow, param2:CommandCenterModel)
      {
         super();
         this._window = param1;
         this._model = param2;
         this._model.state.changed.add(this.updateState);
         this._model.hasNews.changed.add(this.updateNews);
         this._window.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.handleMaximized);
         this._window.addEventListener(SimpleWindowEvent.ON_MINIMIZED,this.handleMinimized);
         this.updateNews();
      }
      
      public function updateState(param1:Boolean = false) : void
      {
         var _loc3_:CommandCenterCategory = null;
         var _loc2_:int = this._model.state.value;
         if(this._localHighlightState == _loc2_ && !param1)
         {
            return;
         }
         this.removeCurrentHighlights();
         this._localHighlightState = _loc2_;
         if(!param1 || this._localHighlightState == CommandCenterModel.UNREAD_DEALS_STATE)
         {
            this.addCurrentHighlights();
         }
         if(this._localHighlightState == CommandCenterModel.UNREAD_DEALS_STATE && !this._window.maximized)
         {
            _loc3_ = this._model.specialCategory;
            if(!_loc3_)
            {
               return;
            }
            this.ttip.show(_loc3_);
         }
         else
         {
            this.ttip.hide();
         }
         if(this._localHighlightState > 0)
         {
            this._lastTryNotificationPointer = setTimeout(this.lastTryNotification,CommandCenterConsts.REMINDER_DELAY);
         }
      }
      
      public function reUpdateState() : void
      {
         setTimeout(this.updateNews,1000,true);
      }
      
      private function updateNews(param1:Boolean = false) : void
      {
         if(param1)
         {
            GameFacade.getInstance().sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,CommandCenterConsts.RED_DOT);
         }
         if(this._model.hasNews.value)
         {
            GameFacade.getInstance().sendNotification(HighLightItemNotification.ADD_HIGHLIGHT,CommandCenterConsts.RED_DOT);
         }
         else
         {
            GameFacade.getInstance().sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,CommandCenterConsts.RED_DOT);
         }
         this.updateState(param1);
      }
      
      private function removeCurrentHighlights() : void
      {
         var _loc4_:HighlightItemVO = null;
         var _loc1_:Vector.<HighlightItemVO> = CommandCenterConsts.highlightLookup[this._localHighlightState];
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_[_loc3_];
            GameFacade.getInstance().sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,_loc4_);
            _loc3_++;
         }
      }
      
      private function addCurrentHighlights() : void
      {
         var _loc4_:HighlightItemVO = null;
         if(this._window.maximized)
         {
            return;
         }
         var _loc1_:Vector.<HighlightItemVO> = CommandCenterConsts.highlightLookup[this._localHighlightState];
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_[_loc3_];
            GameFacade.getInstance().sendNotification(HighLightItemNotification.ADD_HIGHLIGHT,_loc4_);
            _loc3_++;
         }
      }
      
      private function lastTryNotification() : void
      {
         GameFacade.getInstance().sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,CommandCenterConsts.FLASH);
         GameFacade.getInstance().sendNotification(HighLightItemNotification.ADD_HIGHLIGHT,CommandCenterConsts.FLASH);
      }
      
      private function handleMinimized(param1:SimpleWindowEvent) : void
      {
      }
      
      private function handleMaximized(param1:SimpleWindowEvent) : void
      {
         this.removeCurrentHighlights();
         clearTimeout(this._lastTryNotificationPointer);
         this.ttip.hide();
      }
   }
}

import com.bigpoint.utils.TimeFormatter;
import com.bigpoint.utils.ui.tooltip.StickyToolTipHook;
import com.bigpoint.utils.ui.tooltip.TooltipControl;
import flash.geom.Point;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;
import net.bigpoint.as3toolbox.bplocale.BPLocale;
import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractComponentDecorator;
import net.bigpoint.darkorbit.mvc.application.GameFacade;
import net.bigpoint.darkorbit.mvc.commandCenter.constants.CommandCenterConsts;
import net.bigpoint.darkorbit.mvc.commandCenter.model.CommandCenterCategory;
import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
import net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.FeaturesMenuMediator;

class CommandCenterTTipController
{
   
   private var _toolTip:StickyToolTipHook;
   
   private var _toolTip_text_base:String = BPLocale.getItem("ttip_commandCenterDeals");
   
   private var _timeoutPointer:uint;
   
   private var _specialCategory:CommandCenterCategory;
   
   public function CommandCenterTTipController()
   {
      super();
   }
   
   public function hide() : void
   {
      clearTimeout(this._timeoutPointer);
      this.removeListeners();
      this._specialCategory = null;
      if(this._toolTip)
      {
         this._toolTip.hideTooltip();
      }
   }
   
   public function show(param1:CommandCenterCategory) : void
   {
      var _loc2_:FeaturesMenuMediator = null;
      var _loc3_:DOAbstractComponentDecorator = null;
      var _loc4_:Point = null;
      this.removeListeners();
      this._specialCategory = param1;
      this.addListeners();
      if(!this._toolTip)
      {
         _loc2_ = GameFacade.getInstance().retrieveMediator(FeaturesMenuMediator.NAME) as FeaturesMenuMediator;
         _loc3_ = _loc2_.getGameFeatureBtnById(GuiConstants.COMMAND_CENTER) as DOAbstractComponentDecorator;
         _loc4_ = _loc3_.localToGlobal(new Point(0,_loc3_.height));
         this._toolTip = TooltipControl.getInstance().addStickyToolTip(_loc3_,"-",_loc4_.x,_loc4_.y + CommandCenterConsts.TOOLTIP_OFFSET_Y);
      }
      this.updateText();
      this._toolTip.showTooltip();
      clearTimeout(this._timeoutPointer);
      this._timeoutPointer = setTimeout(this.hide,CommandCenterConsts.TIMER_TIMEOUT_SEC);
   }
   
   private function addListeners() : void
   {
      if(this._specialCategory)
      {
         this._specialCategory.timer.changed.add(this.updateText);
      }
   }
   
   private function removeListeners() : void
   {
      if(this._specialCategory)
      {
         this._specialCategory.timer.changed.remove(this.updateText);
      }
   }
   
   private function updateText() : void
   {
      this._toolTip.updateText(this._toolTip_text_base.replace("%TIME%",TimeFormatter.getSmartFormatedTime(this._specialCategory.timer.value)));
   }
}
