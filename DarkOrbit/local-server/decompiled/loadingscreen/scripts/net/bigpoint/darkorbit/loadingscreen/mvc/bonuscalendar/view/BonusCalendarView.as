package net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.view
{
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.view.FlashLoadingBarView;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.model.vo.ItemVO;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.view.components.InfoButton;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.view.components.ItemList;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.view.components.PremiumItemPanel;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.view.components.TimerLabel;
   import net.bigpoint.darkorbit.loadingscreen.utils.Styles;
   import net.bigpoint.darkorbit.loadingscreen.utils.TooltipControl;
   
   public class BonusCalendarView extends Sprite
   {
      
      public static const WIDTH:uint = 778;
      
      public static const HEIGHT:uint = 637;
      
      public static var loadingFontHeight:int = 26;
      
      public static var loadingFmt:TextFormat = new TextFormat(Styles.boldFontName,loadingFontHeight,16434692);
      
      private var _uiLibrary:SWFFinisher;
      
      private var _timerLabel:TimerLabel;
      
      private var _itemList:ItemList;
      
      private var _premiumItemPanel:PremiumItemPanel;
      
      private var _backgroundContainer:Sprite;
      
      private var _loadingBarContainer:Sprite;
      
      private var _items:Vector.<ItemVO>;
      
      private var _loadingBar:FlashLoadingBarView;
      
      private var _initLoginBonusPanelTitlePos:int;
      
      private var _loadingBarHeightThreshold:int;
      
      private var _infoButton:InfoButton;
      
      public function BonusCalendarView()
      {
         super();
         this._loadingBar = new FlashLoadingBarView();
      }
      
      public function get loadingBarView() : FlashLoadingBarView
      {
         return this._loadingBar;
      }
      
      public function get loadingBarHeightThreshold() : int
      {
         return this._loadingBarHeightThreshold;
      }
      
      public function initializeComponents(param1:SWFFinisher) : void
      {
         this._uiLibrary = param1;
         this.drawBackground();
         this.drawTitle();
         this.createTimerLabel();
         this.createInfoButton();
         this.createLoadingBar();
      }
      
      private function createInfoButton() : void
      {
         this._infoButton = new InfoButton(this._uiLibrary,InfoButton.COLOR_STYLE_BLUE);
         this._infoButton.x = WIDTH - this._infoButton.width;
         var _loc1_:int = 13;
         this._infoButton.x -= _loc1_;
         var _loc2_:int = 35;
         this._infoButton.y += _loc2_;
         this._backgroundContainer.addChild(this._infoButton);
         var _loc3_:String = BPLocale.getItem("login_bonus_tooltip_info_items");
         TooltipControl.getInstance().addToolTip(this._infoButton,_loc3_);
      }
      
      private function createLoadingBar() : void
      {
         this._loadingBarContainer = new Sprite();
         this.addChild(this._loadingBarContainer);
         this._initLoginBonusPanelTitlePos = this._loadingBar.y = this.height;
         this._loadingBar.x = (this.width >> 1) - (this._loadingBar.width >> 1);
         this._loadingBarHeightThreshold = this._loadingBar.y + this._loadingBar.height;
         this._loadingBarContainer.addChild(this._loadingBar);
      }
      
      public function resetLoginBonusPanelTitlePos() : void
      {
         this._loadingBar.y = this._initLoginBonusPanelTitlePos;
      }
      
      private function drawTitle() : void
      {
         var _loc1_:TextField = new TextField();
         _loc1_.width = WIDTH;
         _loc1_.defaultTextFormat = loadingFmt;
         _loc1_.embedFonts = true;
         _loc1_.autoSize = TextFieldAutoSize.CENTER;
         _loc1_.antiAliasType = AntiAliasType.ADVANCED;
         _loc1_.selectable = false;
         _loc1_.mouseEnabled = false;
         _loc1_.y = 17;
         _loc1_.filters = [new GlowFilter(13369344,0.75,9,9,3,BitmapFilterQuality.HIGH)];
         _loc1_.text = BPLocale.getItem("login_bonus_panel_title");
         addChild(_loc1_);
      }
      
      private function drawBackground() : void
      {
         this._backgroundContainer = new Sprite();
         this._backgroundContainer.y = 0;
         this.addChild(this._backgroundContainer);
         var _loc1_:BitmapData = this._uiLibrary.getEmbeddedBitmapData("daily_login_bonus_bgnd");
         var _loc2_:Bitmap = new Bitmap(_loc1_);
         this._backgroundContainer.addChild(_loc2_);
         this.graphics.beginFill(0,0.1);
         this.graphics.drawRect(0,0,WIDTH,HEIGHT);
         this.graphics.endFill();
      }
      
      public function set list(param1:Vector.<ItemVO>) : void
      {
         this._items = param1;
         this._rebuildItemList();
      }
      
      public function set data(param1:Vector.<ItemVO>) : void
      {
         this._rebuildPremiumPanel();
         this._premiumItemPanel.data = param1;
      }
      
      private function createTimerLabel() : void
      {
         if(this._timerLabel == null)
         {
            this._timerLabel = new TimerLabel();
            this._timerLabel.w = WIDTH;
            this._timerLabel.y = HEIGHT - (this._timerLabel.height + 2);
            this._backgroundContainer.addChild(this._timerLabel);
         }
      }
      
      private function _rebuildItemList() : void
      {
         if(this._itemList == null)
         {
            this._itemList = new ItemList(this._uiLibrary);
            this._itemList.addEventListener(ItemList.EVENT_ALL_IMAGES_LOADED,this.handleAllItemsLoadedEvent);
            this._backgroundContainer.addChild(this._itemList);
         }
         this._itemList.list = this._items;
         this._itemList.x = WIDTH - this._itemList.width >> 1;
         this._itemList.y = 65;
      }
      
      private function _rebuildPremiumPanel() : void
      {
         if(this._premiumItemPanel == null)
         {
            this._premiumItemPanel = new PremiumItemPanel(this._uiLibrary,true);
            this._premiumItemPanel.alpha = 0;
            this._premiumItemPanel.y = this._itemList.y + this._itemList.height - 6;
            this._premiumItemPanel.x = (BonusCalendarView.WIDTH - PremiumItemPanel.WIDTH >> 1) + 4;
            this._backgroundContainer.addChild(this._premiumItemPanel);
         }
      }
      
      private function handleAllItemsLoadedEvent(param1:Event) : void
      {
         dispatchEvent(param1.clone());
      }
      
      public function showUI() : void
      {
         TweenMax.delayedCall(0.5,this._showUIDelayed);
      }
      
      private function _showUIDelayed() : void
      {
         this._itemList.showEm();
         this._premiumItemPanel.showIt();
      }
      
      public function updateTimer(param1:Number) : void
      {
         this._timerLabel.time = param1;
      }
      
      public function dispose() : void
      {
         this._timerLabel.dispose();
         this._premiumItemPanel.dispose();
         this._uiLibrary = null;
      }
   }
}

