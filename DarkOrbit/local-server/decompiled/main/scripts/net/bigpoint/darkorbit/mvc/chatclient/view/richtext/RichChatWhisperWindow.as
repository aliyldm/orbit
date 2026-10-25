package net.bigpoint.darkorbit.mvc.chatclient.view.richtext
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollEvent;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.input.Input;
   import net.bigpoint.darkorbit.fui.components.text.input.InputSkin;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.fui.system.utils.FuiPopUpUtils;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatMessageVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatUserVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatWhisperMessageVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.backend.ChatSettings;
   import net.bigpoint.darkorbit.mvc.chatclient.view.ChatUIIconSkinFactory;
   import net.bigpoint.darkorbit.mvc.chatclient.view.DOChatEvent;
   import net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji.RichChatEmojiCodec;
   import net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji.RichChatEmojiEvent;
   import net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji.RichChatEmojiInputPreview;
   import net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji.RichChatEmojiPanel;
   import net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji.RichChatEmojiRegistry;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   
   public class RichChatWhisperWindow extends Sprite
   {
      
      public static const CLOSE:String = "richChatWhisperWindowClose";
      
      private static const XML_RES_KEY:String = "chatWhisperUI";
      
      private static const MAX_TABS:int = 3;
      
      private static const DEFAULT_WIDTH:Number = 520;
      
      private static const DEFAULT_HEIGHT:Number = 300;
      
      private static const OUTER_MARGIN_X:Number = 12;
      
      private static const OUTER_MARGIN_Y:Number = 35;
      
      private static const SIDE_PADDING:Number = 12;
      
      private static const MESSAGE_PADDING:Number = 8;
      
      private static const ROW_GAP:Number = 6;
      
      private static const SCROLLBAR_GUTTER:Number = 16;
      
      private static const WHEEL_STEP:Number = 30;
      
      private static const SCROLL_EASING:Number = 0.35;
      
      private static const SCROLL_SNAP_DISTANCE:Number = 0.5;
      
      private static const BOTTOM_EPSILON:Number = 1;
      
      private var _users:Vector.<DOChatUserVO> = new Vector.<DOChatUserVO>(0);
      
      private var _messages:Vector.<DOChatMessageVO>;
      
      private var _drafts:Object = {};
      
      private var _rowCache:Dictionary = new Dictionary();
      
      private var _activeUsername:String;
      
      private var _windowWidth:Number;
      
      private var _windowHeight:Number;
      
      private var _window:SimpleWindow;
      
      private var _contentContainer:Container;
      
      private var _tabbarContainer:Container;
      
      private var _tabList:ItemList;
      
      private var _tabScrollLeftButton:Button;
      
      private var _tabScrollRightButton:Button;
      
      private var _messagesHost:Container;
      
      private var _messageLayer:Sprite = new Sprite();
      
      private var _messagesHitArea:Sprite = new Sprite();
      
      private var _messagesMask:Sprite = new Sprite();
      
      private var _newMessageButton:RichChatNewMessageButton = new RichChatNewMessageButton();
      
      private var _messagesScrollbar:Scrollbar;
      
      private var _clearMessagesButton:Button;
      
      private var _input:Input;
      
      private var _emojiButton:Button;
      
      private var _emojiPanel:RichChatEmojiPanel;
      
      private var _emojiInputPreview:RichChatEmojiInputPreview;
      
      private var _emojiInsertionStart:int;
      
      private var _emojiInsertionEnd:int;
      
      private var _userMenu:RichChatUserMenu;
      
      private var _ready:Boolean;
      
      private var _focusPending:Boolean;
      
      private var _suppressWindowCloseEvent:Boolean;
      
      private var _contentHeight:Number;
      
      private var _scrollY:Number;
      
      private var _autoScroll:Boolean = true;
      
      private var _scrollStates:Object = {};
      
      private var _newMessagePending:Object = {};
      
      private var _syncingScrollbar:Boolean;
      
      private var _messagesWheelListening:Boolean;
      
      private var _scrollTargetY:Number = NaN;
      
      private var _pendingClearUser:DOChatUserVO;
      
      public function RichChatWhisperWindow()
      {
         super();
         this._windowWidth = DEFAULT_WIDTH;
         this._windowHeight = DEFAULT_HEIGHT;
         mouseEnabled = true;
         mouseChildren = true;
         this._messagesMask.mouseEnabled = false;
         this._messagesMask.mouseChildren = false;
         addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         addEventListener(MouseEvent.MOUSE_DOWN,this.stopMouseEvent);
         addEventListener(RichChatUserMenuEvent.OPEN,this.handleUserMenuOpen);
         UISystem.getInstance().loadAndBuildWithResKey(XML_RES_KEY,this,this.handleBuildComplete);
      }
      
      override public function get width() : Number
      {
         return this._windowWidth;
      }
      
      override public function set width(param1:Number) : void
      {
         this.setSize(param1,this._windowHeight);
      }
      
      override public function get height() : Number
      {
         return this._windowHeight;
      }
      
      override public function set height(param1:Number) : void
      {
         this.setSize(this._windowWidth,param1);
      }
      
      private function get maxScroll() : Number
      {
         return Math.max(0,this._contentHeight - this.getMessagesViewHeight());
      }
      
      private function get activeUser() : DOChatUserVO
      {
         var _loc1_:int = this.getUserIndex(this._activeUsername);
         return _loc1_ == -1 ? null : this._users[_loc1_];
      }
      
      private function get inputTextField() : TextField
      {
         return Boolean(this._input) && Boolean(this._input.skin) ? (this._input.skin as InputSkin).textField : null;
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         this.rememberDraft();
         this._windowWidth = Math.max(1,param1);
         this._windowHeight = Math.max(1,param2);
         this.applySize();
         this.resizeRows();
         this.layoutRows();
         this.updateScrollAfterLayout();
      }
      
      public function openUser(param1:DOChatUserVO, param2:Boolean = true) : Boolean
      {
         if(!param1 || !param1.username)
         {
            return false;
         }
         this.rememberDraft();
         this.rememberScrollState();
         this._focusPending = param2;
         var _loc3_:int = this.getUserIndex(param1.username);
         if(_loc3_ == -1)
         {
            if(this._users.length >= MAX_TABS)
            {
               this.removeUserAt(0);
            }
            this._users.push(param1);
         }
         else
         {
            this._users[_loc3_] = param1;
         }
         this._activeUsername = param1.username;
         this.restoreScrollState();
         this.showWindow();
         this.redrawTabs();
         this.restoreDraft();
         this.redrawMessages(true);
         if(param2)
         {
            this.focusInput();
         }
         dispatchEvent(new DOChatEvent(DOChatEvent.WHISPER_VIEW_OPENED,param1,true));
         return true;
      }
      
      public function updateMessages(param1:Vector.<DOChatMessageVO>) : void
      {
         this.rememberDraft();
         this._messages = param1;
         this.redrawMessages(true);
         this.markActiveUserRead();
      }
      
      public function focusInput() : void
      {
         if(this._ready && Boolean(this._input))
         {
            this._input.setFocus();
            this._focusPending = false;
         }
         else
         {
            this._focusPending = true;
         }
      }
      
      public function hide(param1:Boolean = false) : void
      {
         var _loc2_:Boolean = false;
         this.rememberDraft();
         this.rememberScrollState();
         this.stopSmoothScroll();
         this.closeUserMenu();
         if(Boolean(this._window) && this._window.maximized)
         {
            _loc2_ = this._suppressWindowCloseEvent;
            this._suppressWindowCloseEvent = true;
            this._window.minimize(false);
            this._suppressWindowCloseEvent = _loc2_;
         }
         if(param1)
         {
            dispatchEvent(new Event(CLOSE));
         }
      }
      
      private function handleBuildComplete() : void
      {
         this._contentContainer = FuiComponentSelectorUtil.selectComponent("contentContainer",this) as Container;
         this._tabbarContainer = FuiComponentSelectorUtil.selectComponent("contentContainer.whisperTabbarContainer",this) as Container;
         this._tabList = FuiComponentSelectorUtil.selectComponent("contentContainer.whisperTabbarContainer.whisperTabs",this) as ItemList;
         this._tabScrollLeftButton = FuiComponentSelectorUtil.selectComponent("contentContainer.whisperTabbarContainer.scrollTabsLeft",this) as Button;
         this._tabScrollRightButton = FuiComponentSelectorUtil.selectComponent("contentContainer.whisperTabbarContainer.scrollTabsRight",this) as Button;
         this._messagesHost = FuiComponentSelectorUtil.selectComponent("contentContainer.messagesHost",this) as Container;
         this._messagesScrollbar = FuiComponentSelectorUtil.selectComponent("contentContainer.messagesScrollbar",this) as Scrollbar;
         this._clearMessagesButton = FuiComponentSelectorUtil.selectComponent("contentContainer.clearWhisperMessagesButton",this) as Button;
         this._input = FuiComponentSelectorUtil.selectComponent("contentContainer.whisperInput",this) as Input;
         this._emojiButton = FuiComponentSelectorUtil.selectComponent("contentContainer.whisperEmojiButton",this) as Button;
         if(this._tabList)
         {
            this._tabList.itemDataAssigner = RichChatWhisperTabDataAssigner;
            this._tabList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleTabSelectionChanged);
            this._tabList.addEventListener(RichChatWhisperTabEvent.CLOSE,this.handleTabClose);
         }
         if(this._tabScrollLeftButton)
         {
            this._tabScrollLeftButton.addEventListener(MouseEvent.CLICK,this.handleTabScrollLeftClicked);
         }
         if(this._tabScrollRightButton)
         {
            this._tabScrollRightButton.addEventListener(MouseEvent.CLICK,this.handleTabScrollRightClicked);
         }
         if(this._messagesHost)
         {
            this._messagesHost.mouseEnabled = true;
            this._messagesHitArea.mouseEnabled = true;
            this._messagesHitArea.mouseChildren = false;
            this._messagesHost.addChildAt(this._messagesHitArea,0);
            this._messagesHost.addChild(this._messageLayer);
            this._messagesHost.addChild(this._messagesMask);
            this._messageLayer.mask = this._messagesMask;
            this._newMessageButton.visible = false;
            this._newMessageButton.addEventListener(MouseEvent.CLICK,this.handleNewMessageButtonClicked);
            this._messagesHost.addChild(this._newMessageButton);
            this.setMessagesWheelListening(true);
         }
         if(this._messagesScrollbar)
         {
            this._messagesScrollbar.scrollPixelSpeed = WHEEL_STEP;
            this._messagesScrollbar.addEventListener(ScrollEvent.SCROLL_POSITION_CHANGED,this.handleMessagesScrollbarChanged);
         }
         if(this._clearMessagesButton)
         {
            ChatUIIconSkinFactory.applyTo(this._clearMessagesButton,ChatUIIconSkinFactory.ICON_CLEAN);
            this._clearMessagesButton.addEventListener(MouseEvent.CLICK,this.handleClearMessagesButtonClicked);
         }
         if(this._input)
         {
            this._input.addEventListener(KeyboardEvent.KEY_DOWN,this.handleInputKeyDown);
            this._emojiInputPreview = new RichChatEmojiInputPreview(this._input);
         }
         if(this._emojiButton)
         {
            this._emojiButton.visible = ChatSettings.isNew;
            ChatUIIconSkinFactory.applyTo(this._emojiButton,ChatUIIconSkinFactory.ICON_EMOJI);
            this._emojiButton.addEventListener(MouseEvent.CLICK,this.handleEmojiButtonClicked);
            this._emojiPanel = new RichChatEmojiPanel();
            this._emojiPanel.visible = false;
            this._emojiPanel.addEventListener(RichChatEmojiEvent.SELECTED,this.handleEmojiSelected);
         }
         this._ready = true;
         this.applySize();
         this.redrawTabs();
         this.restoreDraft();
         this.redrawMessages();
         if(this._focusPending)
         {
            this.focusInput();
         }
      }
      
      private function showWindow() : void
      {
         if(!this.ensureWindow())
         {
            return;
         }
         this._window.maximize(false);
         this.setMessagesWheelListening(true);
         this.applyWindowSize();
      }
      
      private function ensureWindow() : Boolean
      {
         if(this._window)
         {
            return true;
         }
         this._window = GuiManager.instance.getWindow(GuiConstants.CHAT_WHISPER) as SimpleWindow;
         if(!this._window)
         {
            GameFacade.getInstance().sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,SimpleWindowCreationMap.getById(GuiConstants.CHAT_WHISPER));
            this._window = GuiManager.instance.getWindow(GuiConstants.CHAT_WHISPER) as SimpleWindow;
         }
         if(!this._window)
         {
            return false;
         }
         this._window.addEventListener(SimpleWindowEvent.ON_RESIZE,this.handleWindowResize);
         this._window.addEventListener(SimpleWindowEvent.SIZE_CHANGED,this.handleWindowResize);
         this._window.addEventListener(SimpleWindowEvent.WIDTH_CHANGED,this.handleWindowResize);
         this._window.addEventListener(SimpleWindowEvent.HEIGHT_CHANGED,this.handleWindowResize);
         this._window.addEventListener(SimpleWindowEvent.ON_MINIMIZE,this.handleWindowHidden);
         this._window.addEventListener(SimpleWindowEvent.ON_CLOSE,this.handleWindowHidden);
         this._window.getUIContainer().addChild(this);
         this.applyWindowSize();
         return true;
      }
      
      private function detachWindow() : void
      {
         this.setMessagesWheelListening(false);
         if(!this._window)
         {
            return;
         }
         this._window.removeEventListener(SimpleWindowEvent.ON_RESIZE,this.handleWindowResize);
         this._window.removeEventListener(SimpleWindowEvent.SIZE_CHANGED,this.handleWindowResize);
         this._window.removeEventListener(SimpleWindowEvent.WIDTH_CHANGED,this.handleWindowResize);
         this._window.removeEventListener(SimpleWindowEvent.HEIGHT_CHANGED,this.handleWindowResize);
         this._window.removeEventListener(SimpleWindowEvent.ON_MINIMIZE,this.handleWindowHidden);
         this._window.removeEventListener(SimpleWindowEvent.ON_CLOSE,this.handleWindowHidden);
         this._window = null;
      }
      
      private function applyWindowSize() : void
      {
         if(!this._window)
         {
            return;
         }
         this.setSize(this._window.width - OUTER_MARGIN_X,this._window.height - OUTER_MARGIN_Y);
      }
      
      private function applySize() : void
      {
         if(!this._ready || !this._contentContainer)
         {
            return;
         }
         this._contentContainer.setSize(this._windowWidth,this._windowHeight);
         this._contentContainer.forceRedraws([InvalidationType.SIZE,InvalidationType.POSITION,InvalidationType.LAYOUT],true);
         if(this._tabbarContainer)
         {
            this._tabbarContainer.forceRedraws([InvalidationType.SIZE,InvalidationType.POSITION,InvalidationType.LAYOUT],true);
         }
         if(this._tabList)
         {
            this._tabList.forceRedraws([InvalidationType.SIZE,InvalidationType.POSITION,InvalidationType.LAYOUT,InvalidationType.FILLITEMS],true);
            this.updateTabScrollButtons();
         }
         if(this._messagesHost)
         {
            this._messagesHost.forceRedraws([InvalidationType.SIZE,InvalidationType.POSITION,InvalidationType.LAYOUT],true);
            this._messageLayer.x = MESSAGE_PADDING;
            this.drawMessagesMask();
            this.positionNewMessageButton();
         }
         if(this._messagesScrollbar)
         {
            this._messagesScrollbar.forceRedraws([InvalidationType.SIZE,InvalidationType.POSITION,InvalidationType.LAYOUT],true);
         }
         if(this._input)
         {
            this._input.forceRedraws([InvalidationType.SIZE,InvalidationType.POSITION,InvalidationType.TEXT],true);
            if(this._emojiInputPreview)
            {
               this._emojiInputPreview.refresh();
            }
         }
         if(this._emojiButton)
         {
            this._emojiButton.forceRedraws([InvalidationType.SIZE,InvalidationType.POSITION,InvalidationType.TEXT],true);
            this.positionEmojiPanel();
         }
      }
      
      private function redrawTabs() : void
      {
         if(!this._ready || !this._tabList)
         {
            return;
         }
         this._tabList.list = new VectorCollection(this._users);
         var _loc1_:int = this.getUserIndex(this._activeUsername);
         if(_loc1_ != ItemList.UNSELECTED_INDEX)
         {
            this._tabList.selectedIndex = _loc1_;
            this._tabList.setScrollPositionInPercent(_loc1_ / Math.max(1,this._users.length));
         }
         this._tabList.forceRedraws([InvalidationType.LAYOUT,InvalidationType.FILLITEMS],true);
         this.updateTabScrollButtons();
      }
      
      private function updateTabScrollButtons() : void
      {
         if(!this._tabList)
         {
            return;
         }
         var _loc1_:Boolean = this._tabList.allItemsDisplayed();
         if(_loc1_)
         {
            this._tabList.setScrollPositionInPercent(0);
         }
         var _loc2_:Number = this._tabList.getScrollPositionInPercent();
         if(this._tabScrollLeftButton)
         {
            this._tabScrollLeftButton.enabled = !_loc1_ && _loc2_ > 0;
         }
         if(this._tabScrollRightButton)
         {
            this._tabScrollRightButton.enabled = !_loc1_ && _loc2_ < 1;
         }
      }
      
      private function redrawMessages(param1:Boolean = false) : void
      {
         var _loc6_:Array = null;
         var _loc7_:DOChatMessageVO = null;
         if(!this._ready || !this._messageLayer)
         {
            return;
         }
         this.closeUserMenu();
         var _loc2_:Boolean = !this._autoScroll;
         var _loc3_:Boolean = false;
         if(param1 && _loc2_)
         {
            _loc6_ = this.getActiveMessages();
            for each(_loc7_ in _loc6_)
            {
               if(!this._rowCache[_loc7_])
               {
                  _loc3_ = true;
                  break;
               }
            }
         }
         this.removeMessageLayerChildren();
         var _loc4_:Vector.<RichChatMessageRow> = this.getActiveRows();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            this._messageLayer.addChild(_loc4_[_loc5_]);
            _loc5_++;
         }
         this.layoutRows();
         if(param1 && _loc2_ && _loc3_ && Boolean(this._activeUsername))
         {
            this._newMessagePending[this._activeUsername] = true;
         }
         this.updateScrollAfterLayout();
      }
      
      private function getActiveRows() : Vector.<RichChatMessageRow>
      {
         var _loc4_:DOChatMessageVO = null;
         var _loc5_:RichChatMessageRow = null;
         var _loc1_:Vector.<RichChatMessageRow> = new Vector.<RichChatMessageRow>(0);
         var _loc2_:Array = this.getActiveMessages();
         var _loc3_:Number = this.getRowWidth();
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = this._rowCache[_loc4_] as RichChatMessageRow;
            if(!_loc5_)
            {
               _loc5_ = this.createRow(_loc4_);
               this._rowCache[_loc4_] = _loc5_;
            }
            _loc5_.availableWidth = _loc3_;
            _loc1_.push(_loc5_);
         }
         return _loc1_;
      }
      
      private function createRow(param1:DOChatMessageVO) : RichChatMessageRow
      {
         var _loc2_:RichChatMessageRow = new RichChatMessageRow(param1,this.getRowWidth(),"",true);
         _loc2_.addEventListener(DOChatEvent.USERNAME_CLICKED,this.relayDOChatEvent);
         _loc2_.addEventListener(DOChatEvent.CMD_CLICKED,this.relayDOChatEvent);
         _loc2_.addEventListener(DOChatEvent.ACCEPT_INVITE_CLICKED,this.relayDOChatEvent);
         return _loc2_;
      }
      
      private function resizeRows() : void
      {
         var _loc2_:RichChatMessageRow = null;
         var _loc1_:Number = this.getRowWidth();
         for each(_loc2_ in this._rowCache)
         {
            _loc2_.availableWidth = _loc1_;
         }
      }
      
      private function layoutRows() : void
      {
         var _loc3_:DisplayObject = null;
         if(!this._messageLayer)
         {
            return;
         }
         var _loc1_:Number = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._messageLayer.numChildren)
         {
            _loc3_ = this._messageLayer.getChildAt(_loc2_);
            _loc3_.y = _loc1_;
            _loc1_ += _loc3_.height + ROW_GAP;
            _loc2_++;
         }
         this._contentHeight = _loc1_ > 0 ? _loc1_ - ROW_GAP : 0;
      }
      
      private function removeMessageLayerChildren() : void
      {
         while(this._messageLayer.numChildren > 0)
         {
            this._messageLayer.removeChildAt(0);
         }
      }
      
      private function getRowWidth() : Number
      {
         return Math.max(40,(this._messagesHost ? this._messagesHost.width : this._windowWidth) - MESSAGE_PADDING * 2 - SCROLLBAR_GUTTER);
      }
      
      private function getMessagesViewHeight() : Number
      {
         return Math.max(40,(this._messagesHost ? this._messagesHost.height : this._windowHeight) - MESSAGE_PADDING * 2);
      }
      
      private function drawMessagesMask() : void
      {
         this._messagesHitArea.graphics.clear();
         this._messagesHitArea.graphics.beginFill(0,0);
         this._messagesHitArea.graphics.drawRect(0,0,this._messagesHost.width,this._messagesHost.height);
         this._messagesHitArea.graphics.endFill();
         this._messagesMask.graphics.clear();
         this._messagesMask.graphics.beginFill(16777215,1);
         this._messagesMask.graphics.drawRect(MESSAGE_PADDING,MESSAGE_PADDING,this.getRowWidth(),this.getMessagesViewHeight());
         this._messagesMask.graphics.endFill();
      }
      
      private function updateScrollAfterLayout() : void
      {
         this._scrollY = this._autoScroll ? this.maxScroll : Math.max(0,Math.min(this.maxScroll,this._scrollY));
         if(this.isAtBottom())
         {
            this._autoScroll = true;
            this.clearNewMessagePending();
         }
         this.applyScroll();
         this.syncScrollbar();
         this.refreshNewMessageButton();
      }
      
      private function applyScroll() : void
      {
         this._messageLayer.y = MESSAGE_PADDING - this._scrollY;
      }
      
      private function setScrollY(param1:Number) : void
      {
         this.stopSmoothScroll();
         this.applyScrollY(param1);
      }
      
      private function applyScrollY(param1:Number, param2:Boolean = true) : void
      {
         this._scrollY = Math.max(0,Math.min(this.maxScroll,param1));
         this._autoScroll = this.isAtBottom();
         if(this._autoScroll)
         {
            this.clearNewMessagePending();
         }
         this.applyScroll();
         this.syncScrollbar(param2);
         this.rememberScrollState();
         this.refreshNewMessageButton();
      }
      
      private function isAtBottom() : Boolean
      {
         return this.maxScroll <= 0 || this._scrollY >= this.maxScroll - BOTTOM_EPSILON;
      }
      
      private function clearNewMessagePending() : void
      {
         if(this._activeUsername)
         {
            delete this._newMessagePending[this._activeUsername];
         }
         this._newMessageButton.visible = false;
      }
      
      private function refreshNewMessageButton() : void
      {
         this._newMessageButton.visible = Boolean(this._activeUsername && this._newMessagePending[this._activeUsername] && !this._autoScroll && !this.isAtBottom());
      }
      
      private function positionNewMessageButton() : void
      {
         if(!this._messagesHost)
         {
            return;
         }
         this._newMessageButton.x = Math.max(MESSAGE_PADDING,this._messagesHost.width - RichChatNewMessageButton.BUTTON_WIDTH - MESSAGE_PADDING - SCROLLBAR_GUTTER);
         this._newMessageButton.y = Math.max(MESSAGE_PADDING,this._messagesHost.height - RichChatNewMessageButton.BUTTON_HEIGHT - MESSAGE_PADDING);
      }
      
      private function syncScrollbar(param1:Boolean = true) : void
      {
         if(!this._messagesScrollbar)
         {
            return;
         }
         this._syncingScrollbar = true;
         var _loc2_:Number = this.getMessagesViewHeight();
         if(param1)
         {
            this._messagesScrollbar.updateBySizes(_loc2_,Math.max(_loc2_,this._contentHeight));
         }
         this._messagesScrollbar.setScrollPositionInPercent(this.maxScroll <= 0 ? 1 : this._scrollY / this.maxScroll);
         this._syncingScrollbar = false;
      }
      
      private function rememberScrollState() : void
      {
         if(this._activeUsername)
         {
            this._scrollStates[this._activeUsername] = {
               "position":this._scrollY,
               "autoScroll":this._autoScroll
            };
         }
      }
      
      private function restoreScrollState() : void
      {
         this.stopSmoothScroll();
         var _loc1_:Object = this._activeUsername ? this._scrollStates[this._activeUsername] : null;
         if(_loc1_)
         {
            this._scrollY = Number(_loc1_.position);
            this._autoScroll = Boolean(_loc1_.autoScroll);
         }
         else
         {
            this._scrollY = 0;
            this._autoScroll = true;
         }
      }
      
      private function getActiveMessages() : Array
      {
         var _loc2_:DOChatMessageVO = null;
         var _loc1_:Array = [];
         if(!this._messages || !this._activeUsername)
         {
            return _loc1_;
         }
         for each(_loc2_ in this._messages)
         {
            if(!(!_loc2_ || !_loc2_.user || _loc2_.user.username != this._activeUsername))
            {
               if(_loc2_.whisperType == DOChatMessageVO.WHISPER_TYPE_THEY || _loc2_.whisperType == DOChatMessageVO.WHISPER_TYPE_YOU)
               {
                  _loc1_.push(_loc2_);
               }
            }
         }
         return _loc1_;
      }
      
      private function getUserIndex(param1:String) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._users.length)
         {
            if(this._users[_loc2_].username == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function rememberDraft() : void
      {
         if(Boolean(this._input) && Boolean(this._activeUsername))
         {
            this._drafts[this._activeUsername] = this._input.text;
         }
      }
      
      private function restoreDraft() : void
      {
         if(!this._input)
         {
            return;
         }
         this._input.text = Boolean(this._activeUsername) && Boolean(this._drafts[this._activeUsername]) ? String(this._drafts[this._activeUsername]) : "";
         this._input.forceRedraw(InvalidationType.TEXT);
         if(this._emojiInputPreview)
         {
            this._emojiInputPreview.refresh();
         }
      }
      
      private function removeUserAt(param1:int) : DOChatUserVO
      {
         if(param1 < 0 || param1 >= this._users.length)
         {
            return null;
         }
         var _loc2_:DOChatUserVO = this._users[param1];
         delete this._drafts[_loc2_.username];
         delete this._scrollStates[_loc2_.username];
         delete this._newMessagePending[_loc2_.username];
         this._users.splice(param1,1);
         return _loc2_;
      }
      
      private function markActiveUserRead() : void
      {
         if(!this._window || !this._window.maximized || !this._activeUsername)
         {
            return;
         }
         var _loc1_:int = this.getUserIndex(this._activeUsername);
         if(_loc1_ != -1)
         {
            dispatchEvent(new DOChatEvent(DOChatEvent.WHISPER_VIEW_OPENED,this._users[_loc1_],true));
         }
      }
      
      private function closeEmojiPanel() : void
      {
         if(this._emojiPanel)
         {
            this._emojiPanel.visible = false;
            if(this._emojiPanel.parent)
            {
               this._emojiPanel.parent.removeChild(this._emojiPanel);
            }
         }
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleEmojiStageMouseDown,true);
         }
      }
      
      private function positionEmojiPanel() : void
      {
         if(!this._emojiPanel || !this._emojiButton || !this._emojiPanel.parent || !stage)
         {
            return;
         }
         var _loc1_:Point = this._emojiButton.localToGlobal(new Point());
         var _loc2_:Point = new Point(Math.max(0,Math.min(stage.stageWidth - this._emojiPanel.width,_loc1_.x - this._emojiPanel.width)),Math.max(0,Math.min(stage.stageHeight - this._emojiPanel.height,_loc1_.y - this._emojiPanel.height)));
         _loc2_ = this._emojiPanel.parent.globalToLocal(_loc2_);
         this._emojiPanel.x = _loc2_.x;
         this._emojiPanel.y = _loc2_.y;
      }
      
      private function captureEmojiInsertionRange() : void
      {
         var _loc1_:TextField = this.inputTextField;
         if(!_loc1_)
         {
            return;
         }
         this._emojiInsertionStart = _loc1_.selectionBeginIndex;
         this._emojiInsertionEnd = _loc1_.selectionEndIndex;
         if(this._emojiInsertionStart < 0 || this._emojiInsertionEnd < 0)
         {
            this._emojiInsertionStart = this._emojiInsertionEnd = _loc1_.text.length;
         }
      }
      
      private function stopSmoothScroll() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.handleSmoothScrollFrame);
         this._scrollTargetY = NaN;
      }
      
      private function closeUserMenu() : void
      {
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleStageMouseDown);
         }
         if(!this._userMenu)
         {
            return;
         }
         this._userMenu.removeEventListener(RichChatUserMenuEvent.ACTION,this.handleUserMenuAction);
         if(this._userMenu.parent)
         {
            this._userMenu.parent.removeChild(this._userMenu);
         }
         this._userMenu = null;
      }
      
      private function sendWhisper() : void
      {
         var _loc1_:DOChatUserVO = this.activeUser;
         if(!_loc1_ || !this._input)
         {
            return;
         }
         var _loc2_:String = this._input.text ? RichChatEmojiCodec.toProtocolText(this._input.text).replace(/^\s+|\s+$/g,"") : "";
         if(_loc2_ == "")
         {
            this.focusInput();
            return;
         }
         this._drafts[this._activeUsername] = "";
         dispatchEvent(new DOChatEvent(DOChatEvent.WHISPER_MESSAGE,new DOChatWhisperMessageVO("/w " + _loc1_.username + " " + _loc2_,_loc1_),true));
         this._input.text = "";
         this._input.forceRedraw(InvalidationType.TEXT);
         if(this._emojiInputPreview)
         {
            this._emojiInputPreview.refresh();
         }
         this.closeEmojiPanel();
         this.focusInput();
      }
      
      private function confirmClearConversation() : void
      {
         var _loc1_:DOChatUserVO = this._pendingClearUser;
         this._pendingClearUser = null;
         if(!_loc1_ || !_loc1_.username)
         {
            return;
         }
         this.clearCachedRowsForUser(_loc1_.username);
         if(this._activeUsername == _loc1_.username)
         {
            this.stopSmoothScroll();
            delete this._scrollStates[_loc1_.username];
            delete this._newMessagePending[_loc1_.username];
            this._scrollY = 0;
            this._autoScroll = true;
            this._newMessageButton.visible = false;
         }
         dispatchEvent(new DOChatEvent(DOChatEvent.CLEAR_WHISPER_HISTORY_REQUESTED,_loc1_,true));
         this.redrawMessages();
      }
      
      private function cancelClearConversation() : void
      {
         this._pendingClearUser = null;
      }
      
      private function clearCachedRowsForUser(param1:String) : void
      {
         var _loc3_:Object = null;
         var _loc4_:DOChatMessageVO = null;
         var _loc5_:RichChatMessageRow = null;
         var _loc2_:String = param1.toLowerCase();
         for(_loc3_ in this._rowCache)
         {
            _loc4_ = _loc3_ as DOChatMessageVO;
            if(!(!_loc4_ || !_loc4_.user || !_loc4_.user.username || _loc4_.user.username.toLowerCase() != _loc2_))
            {
               _loc5_ = this._rowCache[_loc3_] as RichChatMessageRow;
               if(_loc5_)
               {
                  _loc5_.removeEventListener(DOChatEvent.USERNAME_CLICKED,this.relayDOChatEvent);
                  _loc5_.removeEventListener(DOChatEvent.CMD_CLICKED,this.relayDOChatEvent);
                  _loc5_.removeEventListener(DOChatEvent.ACCEPT_INVITE_CLICKED,this.relayDOChatEvent);
               }
               delete this._rowCache[_loc3_];
            }
         }
      }
      
      private function close() : void
      {
         this.hide(true);
      }
      
      private function setMessagesWheelListening(param1:Boolean) : void
      {
         if(!this._messagesHost || this._messagesWheelListening == param1)
         {
            return;
         }
         if(param1)
         {
            this._messagesHost.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMessagesMouseWheel);
         }
         else
         {
            this._messagesHost.removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleMessagesMouseWheel);
         }
         this._messagesWheelListening = param1;
      }
      
      private function handleClearMessagesButtonClicked(param1:MouseEvent) : void
      {
         this._pendingClearUser = this.activeUser;
         if(!this._pendingClearUser)
         {
            return;
         }
         FuiPopUpUtils.createPopupOkCancel(this.confirmClearConversation,this.cancelClearConversation,BPLocale.getItemInCategory("chat","chat_chat_clear_history"));
         param1.stopPropagation();
      }
      
      private function handleNewMessageButtonClicked(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         this.setScrollY(this.maxScroll);
      }
      
      private function relayDOChatEvent(param1:DOChatEvent) : void
      {
         dispatchEvent(param1.clone());
      }
      
      private function handleTabSelectionChanged(param1:ItemListEvent) : void
      {
         var _loc2_:DOChatUserVO = param1.itemVO as DOChatUserVO;
         if(!_loc2_ && Boolean(this._tabList))
         {
            _loc2_ = this._tabList.selectedItemData as DOChatUserVO;
         }
         if(!_loc2_ || _loc2_.username == this._activeUsername)
         {
            return;
         }
         this.rememberDraft();
         this.rememberScrollState();
         this._activeUsername = _loc2_.username;
         this.restoreScrollState();
         this.restoreDraft();
         this.redrawMessages(true);
         this.focusInput();
         dispatchEvent(new DOChatEvent(DOChatEvent.WHISPER_VIEW_OPENED,_loc2_,true));
      }
      
      private function handleTabScrollLeftClicked(param1:MouseEvent) : void
      {
         if(!this._tabList)
         {
            return;
         }
         this._tabList.setScrollPositionInPercent(Math.max(0,this._tabList.getScrollPositionInPercent() - this._tabList.getScrollOneItemAmount()));
         if(this._tabList.getScrollPositionInPercent() < this._tabList.getScrollOneItemAmount())
         {
            this._tabList.setScrollPositionInPercent(0);
         }
         this.updateTabScrollButtons();
      }
      
      private function handleTabScrollRightClicked(param1:MouseEvent) : void
      {
         if(!this._tabList)
         {
            return;
         }
         this._tabList.setScrollPositionInPercent(Math.min(1,this._tabList.getScrollPositionInPercent() + this._tabList.getScrollOneItemAmount()));
         this.updateTabScrollButtons();
      }
      
      private function handleTabClose(param1:RichChatWhisperTabEvent) : void
      {
         var _loc2_:int = param1.user ? this.getUserIndex(param1.user.username) : -1;
         if(_loc2_ == -1)
         {
            return;
         }
         var _loc3_:Boolean = this._users[_loc2_].username == this._activeUsername;
         if(_loc3_)
         {
            this.rememberDraft();
            this.rememberScrollState();
         }
         this.removeUserAt(_loc2_);
         if(this._users.length == 0)
         {
            this._activeUsername = null;
            this.redrawTabs();
            this.redrawMessages(true);
            this.close();
         }
         else if(_loc3_)
         {
            this._activeUsername = this._users[Math.min(_loc2_,this._users.length - 1)].username;
            this.restoreScrollState();
            this.restoreDraft();
            this.redrawTabs();
            this.redrawMessages(true);
            this.focusInput();
            this.markActiveUserRead();
         }
         else
         {
            this.redrawTabs();
         }
         param1.stopPropagation();
      }
      
      private function handleInputKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.sendWhisper();
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            if(Boolean(this._emojiPanel) && this._emojiPanel.visible)
            {
               this.closeEmojiPanel();
            }
            else
            {
               this.close();
            }
            param1.stopPropagation();
         }
         this.captureEmojiInsertionRange();
      }
      
      private function handleEmojiButtonClicked(param1:MouseEvent) : void
      {
         if(!this._emojiPanel)
         {
            return;
         }
         if(this._emojiPanel.visible)
         {
            this.closeEmojiPanel();
            return;
         }
         this.captureEmojiInsertionRange();
         var _loc2_:DisplayObjectContainer = ScreenManager.getInstance().getWindowLayer2();
         if(!_loc2_)
         {
            return;
         }
         _loc2_.addChild(this._emojiPanel);
         _loc2_.setChildIndex(this._emojiPanel,_loc2_.numChildren - 1);
         this._emojiPanel.visible = true;
         this.positionEmojiPanel();
         if(stage)
         {
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.handleEmojiStageMouseDown,true);
         }
      }
      
      private function handleEmojiSelected(param1:RichChatEmojiEvent) : void
      {
         var _loc2_:String = RichChatEmojiRegistry.createMarker(param1.emojiId);
         var _loc3_:TextField = this.inputTextField;
         if(!_loc2_ || !_loc3_)
         {
            return;
         }
         var _loc4_:int = Math.max(0,Math.min(this._emojiInsertionStart,_loc3_.text.length));
         var _loc5_:int = Math.max(_loc4_,Math.min(this._emojiInsertionEnd,_loc3_.text.length));
         _loc3_.replaceText(_loc4_,_loc5_,_loc2_);
         _loc3_.dispatchEvent(new Event(Event.CHANGE,true));
         if(this._emojiInputPreview)
         {
            this._emojiInputPreview.refresh();
         }
         this.closeEmojiPanel();
         var _loc6_:int = _loc4_ + _loc2_.length;
         if(_loc3_.stage)
         {
            _loc3_.stage.focus = _loc3_;
         }
         _loc3_.setSelection(_loc6_,_loc6_);
         this._emojiInsertionStart = this._emojiInsertionEnd = _loc6_;
      }
      
      private function handleEmojiStageMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(Boolean(this._emojiPanel && _loc2_) && Boolean(this._emojiPanel.contains(_loc2_)) || Boolean(this._emojiButton && _loc2_) && Boolean(this._emojiButton.contains(_loc2_)))
         {
            return;
         }
         this.closeEmojiPanel();
      }
      
      private function handleMessagesMouseWheel(param1:MouseEvent) : void
      {
         if(this.maxScroll <= 0)
         {
            return;
         }
         this.closeUserMenu();
         var _loc2_:Number = isNaN(this._scrollTargetY) ? this._scrollY : this._scrollTargetY;
         this._scrollTargetY = Math.max(0,Math.min(this.maxScroll,_loc2_ - param1.delta * WHEEL_STEP));
         addEventListener(Event.ENTER_FRAME,this.handleSmoothScrollFrame);
         param1.stopPropagation();
      }
      
      private function handleSmoothScrollFrame(param1:Event) : void
      {
         this._scrollTargetY = Math.max(0,Math.min(this.maxScroll,this._scrollTargetY));
         var _loc2_:Number = this._scrollTargetY - this._scrollY;
         if(Math.abs(_loc2_) <= SCROLL_SNAP_DISTANCE)
         {
            this._scrollY = this._scrollTargetY;
            this.stopSmoothScroll();
         }
         else
         {
            this._scrollY += _loc2_ * SCROLL_EASING;
         }
         this.applyScrollY(this._scrollY,false);
      }
      
      private function handleMessagesScrollbarChanged(param1:ScrollEvent) : void
      {
         if(this._syncingScrollbar || this.maxScroll <= 0)
         {
            return;
         }
         this.closeUserMenu();
         this.setScrollY(this._messagesScrollbar.getScrollPositionInPercent() * this.maxScroll);
      }
      
      private function handleWindowResize(param1:SimpleWindowEvent) : void
      {
         this.applyWindowSize();
      }
      
      private function handleWindowHidden(param1:SimpleWindowEvent) : void
      {
         this.stopSmoothScroll();
         this.closeUserMenu();
         this.closeEmojiPanel();
         if(param1.type == SimpleWindowEvent.ON_CLOSE)
         {
            this.detachWindow();
         }
         if(!this._suppressWindowCloseEvent)
         {
            dispatchEvent(new Event(CLOSE));
         }
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         if(this._focusPending)
         {
            this.focusInput();
         }
      }
      
      private function handleUserMenuOpen(param1:RichChatUserMenuEvent) : void
      {
         this.closeUserMenu();
         this._userMenu = new RichChatUserMenu(param1.user);
         this._userMenu.addEventListener(RichChatUserMenuEvent.ACTION,this.handleUserMenuAction);
         addChild(this._userMenu);
         var _loc2_:Number = param1.anchor ? globalToLocal(param1.anchor).x : mouseX;
         var _loc3_:Number = param1.anchor ? globalToLocal(param1.anchor).y : mouseY;
         this._userMenu.x = Math.max(0,Math.min(this._windowWidth - this._userMenu.width,_loc2_));
         this._userMenu.y = _loc3_ + this._userMenu.height <= this._windowHeight ? _loc3_ : _loc3_ - this._userMenu.height - 32;
         if(stage)
         {
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.handleStageMouseDown);
         }
         param1.stopPropagation();
      }
      
      private function handleUserMenuAction(param1:RichChatUserMenuEvent) : void
      {
         var _loc2_:DOChatUserVO = param1.user;
         if(!_loc2_)
         {
            this.closeUserMenu();
            return;
         }
         switch(param1.action)
         {
            case RichChatUserMenu.ADD_FRIEND:
               dispatchEvent(new DOChatEvent(DOChatEvent.ADD_FRIEND_REQUESTED,_loc2_,true));
               break;
            case RichChatUserMenu.GROUP_INVITE:
               dispatchEvent(new DOChatEvent(DOChatEvent.GROUP_INVITE_REQUESTED,_loc2_,true));
               break;
            case RichChatUserMenu.WHISPER:
               this.openUser(_loc2_);
               break;
            case RichChatUserMenu.REPORT:
               dispatchEvent(new DOChatEvent(DOChatEvent.OPEN_REPORT_REQUESTED,_loc2_,true));
               break;
            case RichChatUserMenu.ADD_TO_BLACKLIST:
               dispatchEvent(new DOChatEvent(DOChatEvent.ADD_TO_BLACKLIST_REQUESTED,_loc2_,true));
         }
         this.closeUserMenu();
      }
      
      private function handleStageMouseDown(param1:MouseEvent) : void
      {
         if(Boolean(this._userMenu) && this._userMenu.hitTestPoint(param1.stageX,param1.stageY,true))
         {
            return;
         }
         this.closeUserMenu();
      }
      
      private function stopMouseEvent(param1:MouseEvent) : void
      {
         param1.stopPropagation();
      }
   }
}

