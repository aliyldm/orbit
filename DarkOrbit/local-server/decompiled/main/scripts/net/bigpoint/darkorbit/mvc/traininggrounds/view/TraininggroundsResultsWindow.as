package net.bigpoint.darkorbit.mvc.traininggrounds.view
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.custom.ResultLabel;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollEvent;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.TraininggroundsResultsDataVO;
   import net.bigpoint.darkorbit.mvc.traininggrounds.view.list.TraininggroundsRewardsListItemDataAssigner;
   import net.bigpoint.darkorbit.mvc.traininggrounds.view.list.TraininggroundsStatsListItemDataAssigner;
   
   public class TraininggroundsResultsWindow extends Sprite
   {
      
      private const HEADER_CALL_LOOKUP:Dictionary = new Dictionary();
      
      private var _simpleWindow:IWindow;
      
      private var _windowContentContainer:DisplayObjectContainer;
      
      private var _scoreItemlist:ItemList;
      
      private var _rewardItemlist:ItemList;
      
      private var _rewardScrollbar:Scrollbar;
      
      private var _headerWinner:Label;
      
      private var _headerLoser:Label;
      
      private var _resultHeader:ResultLabel;
      
      public function TraininggroundsResultsWindow(param1:IWindow)
      {
         super();
         this.HEADER_CALL_LOOKUP[TraininggroundsResultsDataVO.WINNER] = this.handleWinner;
         this.HEADER_CALL_LOOKUP[TraininggroundsResultsDataVO.LOSER] = this.handleLoser;
         this.HEADER_CALL_LOOKUP[TraininggroundsResultsDataVO.DRAW] = this.handleDraw;
         this._simpleWindow = param1;
         this._simpleWindow.addEventListener(SimpleWindowEvent.ON_CLOSE,this.handleWindowClosed);
      }
      
      private function handleDraw() : void
      {
         this._resultHeader.background = ResourceManager.getBitmapData(TraininggroundsResultsConstants.TG_LIB,TraininggroundsResultsConstants.BG_DRAW);
         this._resultHeader.localizedText = "label_traininggrounds_results_draw";
         this._resultHeader.gradient = ResourceManager.getBitmapData(TraininggroundsResultsConstants.RESULT_LIB,TraininggroundsResultsConstants.DRAW_GRADIENT);
      }
      
      private function handleLoser() : void
      {
         this._resultHeader.background = ResourceManager.getBitmapData(TraininggroundsResultsConstants.TG_LIB,TraininggroundsResultsConstants.BG_LOSE);
         this._resultHeader.localizedText = "label_traininggrounds_results_defeat";
         this._resultHeader.gradient = ResourceManager.getBitmapData(TraininggroundsResultsConstants.RESULT_LIB,TraininggroundsResultsConstants.LOSER_GRADIENT);
         this._resultHeader.texture = ResourceManager.getBitmapData(TraininggroundsResultsConstants.RESULT_LIB,TraininggroundsResultsConstants.LOSER_TEXTURE);
      }
      
      private function handleWinner() : void
      {
         this._resultHeader.background = ResourceManager.getBitmapData(TraininggroundsResultsConstants.TG_LIB,TraininggroundsResultsConstants.BG_WIN);
         this._resultHeader.localizedText = "label_traininggrounds_results_victory";
         this._resultHeader.gradient = ResourceManager.getBitmapData(TraininggroundsResultsConstants.RESULT_LIB,TraininggroundsResultsConstants.WIN_GRADIENT);
         this._resultHeader.shine = ResourceManager.getBitmapData(TraininggroundsResultsConstants.RESULT_LIB,TraininggroundsResultsConstants.WIN_SHINE);
         this._resultHeader.flash = ResourceManager.getBitmapData(TraininggroundsResultsConstants.RESULT_LIB,TraininggroundsResultsConstants.WIN_FLASH);
      }
      
      public function handleWindowContentCreated() : void
      {
         var _loc1_:DisplayObject = null;
         this._windowContentContainer = this.getChildByName("windowContentContainer") as DisplayObjectContainer;
         if(this._windowContentContainer)
         {
            this._scoreItemlist = this._windowContentContainer.getChildByName("traininggroundsScoreItemlist") as ItemList;
            if(this._scoreItemlist)
            {
               this._scoreItemlist.itemDataAssigner = TraininggroundsStatsListItemDataAssigner;
            }
            this._rewardItemlist = this._windowContentContainer.getChildByName("traininggroundsRewardsItemlist") as ItemList;
            if(this._rewardItemlist)
            {
               this._rewardItemlist.itemDataAssigner = TraininggroundsRewardsListItemDataAssigner;
               this._rewardItemlist.addEventListener(ScrollEvent.SCROLLCONTAINER_VERTICAL_SIZE_CHANGED,this.handleRewardItemlistSizeChangeEvent);
            }
            this._rewardScrollbar = this._windowContentContainer.getChildByName("rewardScrollbar") as Scrollbar;
            this._rewardScrollbar.addEventListener(ScrollEvent.SCROLL_POSITION_CHANGED,this.handleRewardScrollbarPositionChangeEvent);
            this._headerWinner = this._windowContentContainer.getChildByName("headerWinner") as Label;
            this._headerLoser = this._windowContentContainer.getChildByName("headerLoser") as Label;
            _loc1_ = this._windowContentContainer.getChildByName("result");
            this._resultHeader = _loc1_ as ResultLabel;
         }
      }
      
      public function updateResultsWindowData(param1:uint, param2:Vector.<String>, param3:Vector.<Vector.<String>>, param4:Vector.<Vector.<String>>) : void
      {
         this._headerWinner.text = param2[0];
         this._headerLoser.text = param2[1];
         this.HEADER_CALL_LOOKUP[param1]();
         this._scoreItemlist.list = new VectorCollection(param3);
         this._rewardItemlist.list = new VectorCollection(param4);
      }
      
      private function handleRewardItemlistSizeChangeEvent(param1:ScrollEvent) : void
      {
         var _loc2_:Number = param1.viewSize;
         var _loc3_:Number = param1.contentSize;
         if(this._rewardScrollbar)
         {
            this._rewardScrollbar.updateBySizes(_loc2_,_loc3_);
         }
      }
      
      private function handleRewardScrollbarPositionChangeEvent(param1:ScrollEvent) : void
      {
         var _loc2_:Number = NaN;
         if(this._rewardScrollbar)
         {
            _loc2_ = this._rewardScrollbar.getScrollPositionInPercent();
            this._rewardItemlist.setScrollPositionInPercent(_loc2_);
         }
      }
      
      private function handleWindowClosed(param1:SimpleWindowEvent) : void
      {
         dispatchEvent(new TraininggroundsWindowEvent(TraininggroundsWindowEvent.RESULTS_CLOSED));
      }
   }
}

