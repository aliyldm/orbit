package net.bigpoint.darkorbit.mvc.chatclient.view
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
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.dropupbox.DropUpBox;
   import net.bigpoint.darkorbit.fui.components.list.dropupbox.DropUpBoxEvent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollEvent;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.input.Input;
   import net.bigpoint.darkorbit.fui.components.text.input.InputSkin;
   import net.bigpoint.darkorbit.fui.system.utils.FuiPopUpUtils;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatMessageVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatModelVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatRoomVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatUserVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.backend.ChatSettings;
   import net.bigpoint.darkorbit.mvc.chatclient.view.report.ReportView;
   import net.bigpoint.darkorbit.mvc.chatclient.view.richtext.RichDOChatMessageTextArea;
   import net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji.RichChatEmojiCodec;
   import net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji.RichChatEmojiEvent;
   import net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji.RichChatEmojiInputPreview;
   import net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji.RichChatEmojiPanel;
   import net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji.RichChatEmojiRegistry;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   
   public class DOChatFUIView extends Sprite implements IDOChatView
   {
      
      private static const NORMAL_ROOM_NAME:String = "Normal";
      
      private static const NORMAL_ROOM_PATH:String = "__normal__";
      
      private static const NORMAL_ROOM_TYPE:String = "normal";
      
      private static const DEFAULT_MESSAGES_TOP:Number = 40;
      
      private static const ACTION_BUTTONS_BOTTOM_GAP:Number = 4;
      
      private var _container:Container;
      
      private var _topContainer:Container;
      
      private var _tabbarContainer:Container;
      
      private var _actionButtonsContainer:Container;
      
      private var _chatMessageView:IDOChatMessagesView;
      
      private var _data:DOChatModelVO;
      
      private var _roomItemList:ItemList;
      
      private var _roomItemListVectorCollection:VectorCollection = new VectorCollection(null);
      
      private var _roomListScrollLeftButton:Button;
      
      private var _roomListScrollRightButton:Button;
      
      private var _reconnectButton:Button;
      
      private var _clearMessagesButton:Button;
      
      private var _normalFilterButton:Button;
      
      private var _normalFilterPanel:DOChatNormalFilterPanel;
      
      private var _normalFilterButtonWidth:Number;
      
      private var _normalFilterButtonMarginLeft:Number;
      
      private var _messagesScrollbar:Scrollbar;
      
      private var _textMarginRight:Number = 0;
      
      private var _textMarginBottom:Number = 0;
      
      private var _lastActiveRoom:DOChatRoomVO;
      
      private var _userInput:Input;
      
      private var history:Vector.<String> = new Vector.<String>();
      
      private var currentHistoryIndex:int = 0;
      
      private var _reportView:ReportView;
      
      private var _scrollbarTimeoutID:uint;
      
      private var _chatRooms:DropUpBox;
      
      private var _isSyncingRoomSelection:Boolean;
      
      private var _pendingWhisperUser:DOChatUserVO;
      
      private var _normalRoom:DOChatRoomVO;
      
      private var _normalSelected:Boolean = true;
      
      private var _normalSourceRooms:Vector.<DOChatRoomVO> = new Vector.<DOChatRoomVO>();
      
      private var _normalSeenMessages:Dictionary = new Dictionary(true);
      
      private var _normalKnownMessages:Dictionary = new Dictionary(true);
      
      private var _normalMessageOrder:Vector.<DOChatMessageVO> = new Vector.<DOChatMessageVO>();
      
      private var _normalAllMessageSourceRooms:Dictionary = new Dictionary(true);
      
      private var _normalMessageSourceRooms:Dictionary = new Dictionary(true);
      
      private var _normalFilterSelections:Dictionary = new Dictionary();
      
      private var _emojiButton:Button;
      
      private var _emojiPanel:RichChatEmojiPanel;
      
      private var _emojiInputPreview:RichChatEmojiInputPreview;
      
      private var _emojiInsertionStart:int;
      
      private var _emojiInsertionEnd:int;
      
      private var _stageDismissListening:Boolean;
      
      private var _chatWindow:SimpleWindow;
      
      private var _scrollToBottomOnWindowOpen:Boolean;
      
      public function DOChatFUIView()
      {
         super();
         this.initNormalRoom();
         UISystem.getInstance().loadAndBuildWithResKey("chatWindowUI",this,this.assignChildern);
         if(this.stage)
         {
            this.addResizeListener();
         }
         else
         {
            this.addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         }
      }
      
      private function get inputTextField() : TextField
      {
         return (this._userInput.skin as InputSkin).textField;
      }
      
      public function setData(param1:DOChatModelVO) : void
      {
         var _loc2_:Boolean = this._data != param1;
         if(this._data)
         {
            this._data.roomsChanged.remove(this.tryApplyData);
            this._data.banned.changed.remove(this.handleBanned);
         }
         this.clearNormalRoomSources();
         if(_loc2_)
         {
            this._normalRoom.messages.length = 0;
            this._normalSeenMessages = new Dictionary(true);
            this._normalKnownMessages = new Dictionary(true);
            this._normalMessageOrder.length = 0;
            this._normalAllMessageSourceRooms = new Dictionary(true);
            this._normalMessageSourceRooms = new Dictionary(true);
            this._normalRoom.messagesChanged.dispatch();
         }
         this._data = param1;
         this.tryApplyData();
         this._data.roomsChanged.add(this.tryApplyData);
         this._data.banned.changed.add(this.handleBanned);
      }
      
      public function openReportView() : void
      {
         this.handleReportClicked();
      }
      
      public function openWhisperView(param1:DOChatUserVO) : void
      {
         if(!param1)
         {
            return;
         }
         if(this._chatMessageView is RichDOChatMessageTextArea)
         {
            RichDOChatMessageTextArea(this._chatMessageView).openWhisper(param1);
         }
         else
         {
            this._pendingWhisperUser = param1;
         }
      }
      
      private function assignChildern() : void
      {
         var _loc1_:Number = NaN;
         this._container = getChildByName("contentContainer") as Container;
         this._topContainer = this._container.getChildByName("topContainer") as Container;
         this._tabbarContainer = this._topContainer.getChildByName("chatroomTabbarContainer") as Container;
         this._roomItemList = this._tabbarContainer.getChildByName("chatTabsItemlist") as ItemList;
         this._roomItemList.itemDataAssigner = DOChatTabbarItemDataAssigner;
         this._roomItemList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleSelectedRoomsChanged);
         Hero.clanChanged.add(this._roomItemList.forceRedraws);
         this._roomListScrollLeftButton = this._tabbarContainer.getChildByName("scrollTabsLeft") as Button;
         this._roomListScrollRightButton = this._tabbarContainer.getChildByName("scrollTabsRight") as Button;
         this._roomListScrollLeftButton.addEventListener(MouseEvent.CLICK,this.handleScrollLeftClicked);
         this._roomListScrollRightButton.addEventListener(MouseEvent.CLICK,this.handleScrollRightClicked);
         this._actionButtonsContainer = this._topContainer.getChildByName("chatActionButtonsContainer") as Container;
         this._clearMessagesButton = this._actionButtonsContainer.getChildByName("clearMessagesButton") as Button;
         if(this._clearMessagesButton)
         {
            ChatUIIconSkinFactory.applyTo(this._clearMessagesButton,ChatUIIconSkinFactory.ICON_CLEAN);
            this._clearMessagesButton.addEventListener(MouseEvent.CLICK,this.handleClearMessagesButtonClicked);
         }
         this._normalFilterButton = this._actionButtonsContainer.getChildByName("normalFilterButton") as Button;
         if(this._normalFilterButton)
         {
            this._normalFilterButtonWidth = this._normalFilterButton.width;
            this._normalFilterButtonMarginLeft = this._normalFilterButton.marginLeft;
            ChatUIIconSkinFactory.applyTo(this._normalFilterButton,ChatUIIconSkinFactory.ICON_SETTING);
            this._normalFilterButton.addEventListener(MouseEvent.CLICK,this.handleNormalFilterButtonClicked);
            this._normalFilterPanel = new DOChatNormalFilterPanel();
            this._normalFilterPanel.visible = false;
            this._normalFilterPanel.selectionChanged.add(this.handleNormalFilterSelectionChanged);
         }
         this._reconnectButton = this._actionButtonsContainer.getChildByName("reconnectButton") as Button;
         if(this._reconnectButton)
         {
            if(ChatSettings.autoReconnectEnabled)
            {
               _loc1_ = this._reconnectButton.width + this._reconnectButton.marginLeft;
               this._actionButtonsContainer.removeChild(this._reconnectButton);
               this._actionButtonsContainer.width = Math.max(0,this._actionButtonsContainer.width - _loc1_);
               this._reconnectButton = null;
            }
            else
            {
               this._reconnectButton.addEventListener(MouseEvent.CLICK,this.handleReconnectButtonClicked);
            }
         }
         this._chatRooms = this._container.getChildByName("dropupbox_select") as DropUpBox;
         if(this._chatRooms)
         {
            this._chatRooms.useRawKeys = true;
            this._chatRooms.addEventListener(DropUpBoxEvent.SELECTED_ENTRY_CHANGED,this.roomBoxChange);
         }
         this._userInput = this._container.getChildByName("chatInput") as Input;
         this._userInput.addEventListener(KeyboardEvent.KEY_UP,this.handleInputKeyPressed);
         this._emojiInputPreview = new RichChatEmojiInputPreview(this._userInput);
         this._emojiButton = this._container.getChildByName("emojiButton") as Button;
         if(this._emojiButton)
         {
            this._emojiButton.visible = ChatSettings.isNew;
            ChatUIIconSkinFactory.applyTo(this._emojiButton,ChatUIIconSkinFactory.ICON_EMOJI);
            this._emojiButton.addEventListener(MouseEvent.CLICK,this.handleEmojiButtonClicked);
            this._emojiPanel = new RichChatEmojiPanel();
            this._emojiPanel.visible = false;
            this._emojiPanel.addEventListener(RichChatEmojiEvent.SELECTED,this.handleEmojiSelected);
         }
         this.initMessagesTextArea();
         this.tryApplyData();
         this.handleWindowResize(null);
      }
      
      private function initMessagesTextArea() : void
      {
         this._messagesScrollbar = this._topContainer.getChildByName("messagesScrollbar") as Scrollbar;
         this._messagesScrollbar.addEventListener(ScrollEvent.SCROLL_POSITION_CHANGED,this.handleScrollbarPositionChangeEvent);
         this.initDOChatMessageTextArea();
         this._chatMessageView.addEventListener(MouseEvent.MOUSE_WHEEL,this.updateScrollbar);
         this._chatMessageView.addEventListener(DOChatEvent.USERNAME_CLICKED,this.handleUsernameClicked);
         this._chatMessageView.addEventListener(DOChatEvent.CMD_CLICKED,this.handleCMDClicked);
         this._chatMessageView.addEventListener(DOChatEvent.OPEN_REPORT_REQUESTED,this.handleReportRequested);
         if(this._data)
         {
            this._chatMessageView.setData(this._normalSelected ? this._normalRoom : this._data.activeRoom);
         }
         this._container.addChild(this._chatMessageView as DisplayObject);
         this._container.setChildIndex(this._chatMessageView as DisplayObject,0);
      }
      
      private function initDOChatMessageItemList() : void
      {
         this._chatMessageView = this._topContainer.getChildByName("chatMessagesItemlist") as IDOChatMessagesView;
      }
      
      private function initDOChatMessageTextArea() : void
      {
         this._chatMessageView = new RichDOChatMessageTextArea();
         this._chatMessageView.x = 33;
         this._chatMessageView.y = DEFAULT_MESSAGES_TOP;
         this._textMarginRight = 48;
         this._textMarginBottom = this._userInput.marginBottom + this._userInput.height + 5;
         this._chatMessageView.width = this._container.width - this._chatMessageView.x - this._textMarginRight;
         this._chatMessageView.height = this._container.height - this._chatMessageView.y - this._textMarginBottom;
         this._chatMessageView.addEventListener(KeyboardEvent.KEY_UP,this.handleTextAreaKeyPressed);
         if(this._pendingWhisperUser)
         {
            RichDOChatMessageTextArea(this._chatMessageView).openWhisper(this._pendingWhisperUser);
            this._pendingWhisperUser = null;
         }
      }
      
      private function handleTextAreaScrollEvent() : void
      {
         clearTimeout(this._scrollbarTimeoutID);
         this._scrollbarTimeoutID = setTimeout(this.updateScrollbar,1000);
      }
      
      private function updateScrollbar(... rest) : void
      {
         var _loc2_:Number = this._chatMessageView.getScrollPositionFraction();
         this._messagesScrollbar.setScrollPositionInPercent(_loc2_);
      }
      
      private function addResizeListener() : void
      {
         var _loc1_:SimpleWindow = parent ? parent.parent as SimpleWindow : null;
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:Boolean = this._chatWindow != _loc1_;
         if(!_loc2_)
         {
            this.handleWindowResize(null);
            return;
         }
         this.removeChatWindowListeners(this._chatWindow);
         this._chatWindow = _loc1_;
         this._chatWindow.addEventListener(SimpleWindowEvent.ON_RESIZE,this.handleWindowResize);
         this._chatWindow.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.handleChatWindowMaximized);
         this._chatWindow.addEventListener(SimpleWindowEvent.ON_MINIMIZED,this.handleChatWindowMinimized);
         this._chatWindow.addEventListener(SimpleWindowEvent.ON_CLOSE,this.handleChatWindowClosed);
         this.handleWindowResize(null);
         if(_loc2_ && _loc1_.maximized)
         {
            this.requestScrollToBottomOnWindowOpen();
         }
      }
      
      private function removeChatWindowListeners(param1:SimpleWindow) : void
      {
         if(!param1)
         {
            return;
         }
         param1.removeEventListener(SimpleWindowEvent.ON_RESIZE,this.handleWindowResize);
         param1.removeEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.handleChatWindowMaximized);
         param1.removeEventListener(SimpleWindowEvent.ON_MINIMIZED,this.handleChatWindowMinimized);
         param1.removeEventListener(SimpleWindowEvent.ON_CLOSE,this.handleChatWindowClosed);
      }
      
      private function handleChatWindowMaximized(param1:SimpleWindowEvent) : void
      {
         if(param1.currentTarget != this._chatWindow)
         {
            return;
         }
         this.handleWindowResize(null);
         this.requestScrollToBottomOnWindowOpen();
      }
      
      private function handleChatWindowMinimized(param1:SimpleWindowEvent) : void
      {
         if(param1.currentTarget != this._chatWindow)
         {
            return;
         }
         this.selectNormalTab(true);
      }
      
      private function handleChatWindowClosed(param1:SimpleWindowEvent) : void
      {
         if(param1.currentTarget != this._chatWindow)
         {
            return;
         }
         this.removeChatWindowListeners(this._chatWindow);
         this._chatWindow = null;
      }
      
      private function requestScrollToBottomOnWindowOpen() : void
      {
         this._scrollToBottomOnWindowOpen = true;
         this.flushScrollToBottomOnWindowOpen();
      }
      
      private function flushScrollToBottomOnWindowOpen() : void
      {
         if(!this._scrollToBottomOnWindowOpen || !this._container || !this._chatMessageView || !this._messagesScrollbar)
         {
            return;
         }
         this.scrollMessagesToBottom();
         this._scrollToBottomOnWindowOpen = false;
      }
      
      private function scrollMessagesToBottom() : void
      {
         if(this._chatMessageView is RichDOChatMessageTextArea)
         {
            RichDOChatMessageTextArea(this._chatMessageView).scrollToBottom();
         }
         else
         {
            this._chatMessageView.setScrollPositionFraction(1);
         }
         this.checkScrollbar();
      }
      
      private function handleWindowResizeForTextArea() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         if(Boolean(this._actionButtonsContainer) && Boolean(this._actionButtonsContainer.stage))
         {
            _loc1_ = this._container.globalToLocal(this._actionButtonsContainer.localToGlobal(new Point(0,this._actionButtonsContainer.height)));
            this._chatMessageView.y = Math.max(DEFAULT_MESSAGES_TOP,Math.ceil(_loc1_.y + ACTION_BUTTONS_BOTTOM_GAP));
         }
         if(Boolean(this._messagesScrollbar) && Boolean(this._topContainer))
         {
            _loc2_ = this._topContainer.globalToLocal(this._container.localToGlobal(new Point(0,this._chatMessageView.y)));
            this._messagesScrollbar.marginTop = Math.ceil(_loc2_.y);
            this._messagesScrollbar.forceRedraws([InvalidationType.SIZE,InvalidationType.POSITION,InvalidationType.LAYOUT],true);
         }
         this._chatMessageView.width = this._container.width - this._chatMessageView.x - this._textMarginRight;
         this._chatMessageView.height = this._container.height - this._chatMessageView.y - this._textMarginBottom;
      }
      
      private function sendOrWhisperMessage() : void
      {
         if(GuiManager.instance.getWindow(GuiConstants.CONNECTION_LOST_WINDOW) != null)
         {
            return;
         }
         if(this._userInput.text == null)
         {
            return;
         }
         var _loc1_:String = RichChatEmojiCodec.toProtocolText(this._userInput.text);
         if(_loc1_.indexOf("/w") == 0)
         {
            dispatchEvent(new DOChatEvent(DOChatEvent.WHISPER_MESSAGE,_loc1_));
         }
         else
         {
            dispatchEvent(new DOChatEvent(DOChatEvent.SEND_MESSAGE,_loc1_));
         }
         this.history.push(_loc1_);
         if(this.history.length > 10)
         {
            this.history.shift();
         }
         this.currentHistoryIndex = this.history.length;
         this.setInputProtocolText("");
         this.closeEmojiPanel();
      }
      
      private function usePreviousHistoryEntry() : void
      {
         if(this.currentHistoryIndex > 0)
         {
            --this.currentHistoryIndex;
         }
         this.setInputProtocolText(this.history.length > this.currentHistoryIndex ? this.history[this.currentHistoryIndex] : "");
      }
      
      private function useNextHistoryEntry() : void
      {
         if(this.currentHistoryIndex < this.history.length)
         {
            ++this.currentHistoryIndex;
            this.setInputProtocolText(this.currentHistoryIndex == this.history.length ? "" : this.history[this.currentHistoryIndex]);
         }
         else
         {
            this.setInputProtocolText("");
         }
      }
      
      private function tryApplyData() : void
      {
         if(this.numChildren)
         {
            this.syncNormalRoomSources();
            this.appendNormalMessages();
            this.updateNormalFilterPanelRooms();
            this.updateTabSection(true);
            this.updateMessagesSection();
            this.handleBanned();
            this.setDropBoxData(this._data.getRoomsAsVector());
         }
      }
      
      private function updateTabSection(param1:Boolean = true) : void
      {
         var _loc2_:Vector.<DOChatRoomVO> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1)
         {
            _loc2_ = this.getTabRooms();
            _loc3_ = this.getActiveRoomIndex();
            _loc4_ = this._normalSelected ? 0 : int(_loc3_ + 1);
            if(!this._normalSelected && _loc3_ == ItemList.UNSELECTED_INDEX || _loc4_ < 0 || _loc4_ >= _loc2_.length)
            {
               this._normalSelected = true;
               this._normalRoom.active = true;
               _loc4_ = 0;
            }
            _loc5_ = this._roomItemList.selectedIndex;
            this._isSyncingRoomSelection = true;
            this._roomItemListVectorCollection.collection = _loc2_;
            this._roomItemList.list = this._roomItemListVectorCollection;
            this._roomItemList.selectedIndex = _loc4_;
            this._isSyncingRoomSelection = false;
            if(_loc5_ != _loc4_)
            {
               this._roomItemList.setScrollPositionInPercent(_loc4_ / Math.max(1,this._roomItemListVectorCollection.length));
            }
         }
         this._roomItemList.invalidate(InvalidationType.SIZE);
         this._roomItemList.invalidate(InvalidationType.POSITION);
         this._roomItemList.forceRedraw(InvalidationType.FILLITEMS);
         this._roomListScrollLeftButton.enabled = !this._roomItemList.allItemsDisplayed() && this._roomItemList.getScrollPositionInPercent() > 0;
         this._roomListScrollRightButton.enabled = !this._roomItemList.allItemsDisplayed() && this._roomItemList.getScrollPositionInPercent() < 1;
         if(this._roomItemList.allItemsDisplayed())
         {
            this._roomItemList.setScrollPositionInPercent(0);
         }
         this.updateNormalFilterButtonVisibility();
      }
      
      private function updateNormalFilterButtonVisibility() : void
      {
         if(!this._normalFilterButton)
         {
            return;
         }
         this._normalFilterButton.visible = this._normalSelected;
         this._normalFilterButton.mouseEnabled = this._normalSelected;
         this._normalFilterButton.width = this._normalSelected ? this._normalFilterButtonWidth : 0;
         this._normalFilterButton.marginLeft = this._normalSelected ? this._normalFilterButtonMarginLeft : 0;
         if(!this._normalSelected)
         {
            this.closeNormalFilterPanel();
         }
         if(this._actionButtonsContainer)
         {
            this._actionButtonsContainer.forceRedraws([InvalidationType.LAYOUT,InvalidationType.SIZE,InvalidationType.POSITION],true);
         }
      }
      
      private function updateMessagesSection() : void
      {
         var _loc1_:DOChatRoomVO = this._normalSelected ? this._normalRoom : this._data.activeRoom;
         if(this._chatMessageView is RichDOChatMessageTextArea)
         {
            RichDOChatMessageTextArea(this._chatMessageView).setMessageSourceRooms(this._normalSelected ? this._normalMessageSourceRooms : null);
         }
         if(this._lastActiveRoom == _loc1_)
         {
            return;
         }
         if(this._lastActiveRoom)
         {
            this._lastActiveRoom.messagesChanged.remove(this.checkScrollbar);
         }
         this._lastActiveRoom = _loc1_;
         if(this._lastActiveRoom)
         {
            this._lastActiveRoom.messagesChanged.add(this.checkScrollbar);
         }
         this._chatMessageView.setData(_loc1_);
         this.checkScrollbar();
      }
      
      private function handleActiveRoomChanged() : void
      {
         this.updateMessagesSection();
      }
      
      private function checkScrollbar() : void
      {
         this._messagesScrollbar.visible = this._chatMessageView.scrollbarNeeded();
         this.updateScrollbar();
      }
      
      private function setDropBoxData(param1:Vector.<DOChatRoomVO>) : void
      {
         var _loc2_:Vector.<String> = null;
         if(!this._chatRooms)
         {
            return;
         }
         if(!param1 || param1.length <= 0)
         {
            this._chatRooms.visible = false;
            return;
         }
         _loc2_ = new Vector.<String>();
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(param1[_loc3_].translatedName);
            _loc3_++;
         }
         if(_loc2_.length > 0)
         {
            this._chatRooms.visible = true;
            this._isSyncingRoomSelection = true;
            this._chatRooms.updateAvailableEntries(_loc2_);
            this._isSyncingRoomSelection = false;
            this.setChatRoomsCurrentEntry(this.getActiveRoomIndex());
         }
         else
         {
            this._chatRooms.visible = false;
         }
      }
      
      private function handleBanned() : void
      {
         if(Boolean(this._data.banned.value) && Boolean(this._data.getRoomsAsVector().length == 0) && Boolean(this._chatMessageView))
         {
            this._chatMessageView.writeText(new DOChatMessageVO(this._data.banned.value,DOChatUserVO.getDefaultSystemUser()));
         }
      }
      
      private function getActiveRoomIndex() : int
      {
         if(!this._data || !this._data.activeRoom)
         {
            return ItemList.UNSELECTED_INDEX;
         }
         return this._data.getRoomsAsVector().indexOf(this._data.activeRoom);
      }
      
      private function setChatRoomsCurrentEntry(param1:int) : void
      {
         if(!this._chatRooms || param1 == ItemList.UNSELECTED_INDEX || this._chatRooms.currentEntry == param1)
         {
            return;
         }
         this._isSyncingRoomSelection = true;
         this._chatRooms.currentEntry = param1;
         this._isSyncingRoomSelection = false;
      }
      
      private function cleanMessage() : void
      {
         if(!this._chatMessageView)
         {
            return;
         }
         if(this._normalSelected)
         {
            this.clearNormalMessages();
         }
         else
         {
            this.clearCurrentRoomMessages();
         }
         this.checkScrollbar();
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
         this.refreshStageDismissListener();
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
      
      private function handleNormalFilterSelectionChanged(param1:String, param2:Boolean) : void
      {
         this._normalFilterSelections[param1] = param2;
         this.rebuildNormalMessages();
         this.updateMessagesSection();
         this.checkScrollbar();
      }
      
      private function closeNormalFilterPanel() : void
      {
         if(this._normalFilterPanel)
         {
            this._normalFilterPanel.visible = false;
            if(this._normalFilterPanel.parent)
            {
               this._normalFilterPanel.parent.removeChild(this._normalFilterPanel);
            }
         }
         this.refreshStageDismissListener();
      }
      
      private function positionNormalFilterPanel() : void
      {
         if(!this._normalFilterPanel || !this._normalFilterButton || !this._normalFilterPanel.parent || !stage)
         {
            return;
         }
         var _loc1_:Point = this._normalFilterButton.localToGlobal(new Point());
         var _loc2_:Point = new Point(Math.max(0,Math.min(stage.stageWidth - this._normalFilterPanel.width,_loc1_.x + this._normalFilterButton.width - this._normalFilterPanel.width)),Math.max(0,Math.min(stage.stageHeight - this._normalFilterPanel.height,_loc1_.y + this._normalFilterButton.height + 2)));
         _loc2_ = this._normalFilterPanel.parent.globalToLocal(_loc2_);
         this._normalFilterPanel.x = _loc2_.x;
         this._normalFilterPanel.y = _loc2_.y;
      }
      
      private function refreshStageDismissListener() : void
      {
         if(!stage)
         {
            this._stageDismissListening = false;
            return;
         }
         var _loc1_:Boolean = this.isPanelOpen(this._emojiPanel) || this.isPanelOpen(this._normalFilterPanel);
         if(_loc1_ && !this._stageDismissListening)
         {
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.handleStageMouseDown,true);
            this._stageDismissListening = true;
         }
         else if(!_loc1_ && this._stageDismissListening)
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleStageMouseDown,true);
            this._stageDismissListening = false;
         }
      }
      
      private function isPanelOpen(param1:DisplayObject) : Boolean
      {
         return param1 != null && param1.visible && param1.parent != null;
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
      
      private function setInputProtocolText(param1:String) : void
      {
         var _loc2_:TextField = this.inputTextField;
         var _loc3_:String = RichChatEmojiCodec.toInputText(param1 || "");
         _loc2_.text = _loc3_;
         _loc2_.dispatchEvent(new Event(Event.CHANGE,true));
         _loc2_.setSelection(_loc3_.length,_loc3_.length);
         this._emojiInsertionStart = this._emojiInsertionEnd = _loc3_.length;
         if(this._emojiInputPreview)
         {
            this._emojiInputPreview.refresh();
         }
      }
      
      private function initNormalRoom() : void
      {
         this._normalRoom = new DOChatRoomVO(NORMAL_ROOM_NAME,NORMAL_ROOM_PATH,NORMAL_ROOM_TYPE,true,0,new Vector.<DOChatUserVO>(0),new Vector.<DOChatMessageVO>(0));
         this._normalRoom.messages.length = 0;
      }
      
      private function getTabRooms() : Vector.<DOChatRoomVO>
      {
         var _loc3_:DOChatRoomVO = null;
         var _loc1_:Vector.<DOChatRoomVO> = new <DOChatRoomVO>[this._normalRoom];
         var _loc2_:Vector.<DOChatRoomVO> = this._data.getRoomsAsVector();
         for each(_loc3_ in _loc2_)
         {
            _loc1_.push(_loc3_);
         }
         return _loc1_;
      }
      
      private function syncNormalRoomSources() : void
      {
         var _loc2_:DOChatRoomVO = null;
         this.clearNormalRoomSources();
         var _loc1_:Vector.<DOChatRoomVO> = this._data.getRoomsAsVector();
         for each(_loc2_ in _loc1_)
         {
            if(this._normalFilterSelections[_loc2_.path] === undefined)
            {
               this._normalFilterSelections[_loc2_.path] = true;
            }
            this._normalSourceRooms.push(_loc2_);
            _loc2_.messagesChanged.add(this.handleNormalSourceMessagesChanged);
         }
         if(this._chatMessageView is RichDOChatMessageTextArea)
         {
            RichDOChatMessageTextArea(this._chatMessageView).setWhisperSourceRooms(_loc1_);
         }
      }
      
      private function clearNormalRoomSources() : void
      {
         var _loc1_:DOChatRoomVO = null;
         for each(_loc1_ in this._normalSourceRooms)
         {
            _loc1_.messagesChanged.remove(this.handleNormalSourceMessagesChanged);
         }
         this._normalSourceRooms.length = 0;
         if(this._chatMessageView is RichDOChatMessageTextArea)
         {
            RichDOChatMessageTextArea(this._chatMessageView).setWhisperSourceRooms(null);
         }
      }
      
      private function handleNormalSourceMessagesChanged() : void
      {
         this.appendNormalMessages();
      }
      
      private function appendNormalMessages() : void
      {
         var _loc1_:DOChatRoomVO = null;
         var _loc2_:DOChatMessageVO = null;
         for each(_loc1_ in this._normalSourceRooms)
         {
            for each(_loc2_ in _loc1_.messages)
            {
               if(!(_loc2_ == _loc1_.joinMessage || _loc2_.whisperType != DOChatMessageVO.WHISPER_TYPE_NONE))
               {
                  if(!this._normalKnownMessages[_loc2_])
                  {
                     this._normalKnownMessages[_loc2_] = true;
                     this._normalMessageOrder.push(_loc2_);
                     this._normalAllMessageSourceRooms[_loc2_] = _loc1_;
                     if(this._normalSelected && this.isEligibleUnreadRoom(_loc1_) && this.isUnreadCandidate(_loc2_))
                     {
                        _loc1_.markUnread();
                     }
                  }
                  if(this.isNormalFilterRoomSelected(_loc1_) && !this._normalSeenMessages[_loc2_])
                  {
                     this.addNormalMessage(_loc2_,_loc1_);
                  }
               }
            }
         }
      }
      
      private function rebuildNormalMessages() : void
      {
         var _loc1_:DOChatMessageVO = null;
         var _loc2_:DOChatRoomVO = null;
         this._normalRoom.messages.length = 0;
         this._normalSeenMessages = new Dictionary(true);
         this._normalMessageSourceRooms = new Dictionary(true);
         for each(_loc1_ in this._normalMessageOrder)
         {
            _loc2_ = this._normalAllMessageSourceRooms[_loc1_] as DOChatRoomVO;
            if(this.isNormalFilterRoomSelected(_loc2_))
            {
               this.addNormalMessage(_loc1_,_loc2_);
            }
         }
         this._normalRoom.messagesChanged.dispatch();
      }
      
      private function clearNormalMessages() : void
      {
         var _loc2_:DOChatRoomVO = null;
         var _loc1_:Vector.<DOChatRoomVO> = new Vector.<DOChatRoomVO>();
         for each(_loc2_ in this._normalSourceRooms)
         {
            if(this.isNormalFilterRoomSelected(_loc2_) && this.removePublicRoomMessages(_loc2_))
            {
               _loc1_.push(_loc2_);
            }
         }
         this.rebuildNormalMessagesFromSources();
         for each(_loc2_ in _loc1_)
         {
            _loc2_.messagesChanged.dispatch();
         }
         this.updateMessagesSection();
      }
      
      private function clearCurrentRoomMessages() : void
      {
         var _loc1_:DOChatRoomVO = this._data ? this._data.activeRoom : null;
         if(!_loc1_ || !this.removePublicRoomMessages(_loc1_))
         {
            return;
         }
         this.rebuildNormalMessagesFromSources();
         _loc1_.messagesChanged.dispatch();
         this.updateMessagesSection();
      }
      
      private function removePublicRoomMessages(param1:DOChatRoomVO) : Boolean
      {
         var _loc4_:DOChatMessageVO = null;
         var _loc2_:Boolean = false;
         var _loc3_:* = int(param1.messages.length - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = param1.messages[_loc3_];
            if(_loc4_ != param1.joinMessage && _loc4_.whisperType == DOChatMessageVO.WHISPER_TYPE_NONE)
            {
               param1.messages.splice(_loc3_,1);
               _loc2_ = true;
            }
            _loc3_--;
         }
         return _loc2_;
      }
      
      private function rebuildNormalMessagesFromSources() : void
      {
         this._normalRoom.messages.length = 0;
         this._normalMessageOrder.length = 0;
         this._normalSeenMessages = new Dictionary(true);
         this._normalKnownMessages = new Dictionary(true);
         this._normalAllMessageSourceRooms = new Dictionary(true);
         this._normalMessageSourceRooms = new Dictionary(true);
         this.appendNormalMessages();
         this._normalRoom.messagesChanged.dispatch();
      }
      
      private function clearAllMessages() : void
      {
         var _loc2_:DOChatRoomVO = null;
         if(!this._data)
         {
            return;
         }
         var _loc1_:Vector.<DOChatRoomVO> = this._data.getRoomsAsVector();
         for each(_loc2_ in _loc1_)
         {
            this.removePublicRoomMessages(_loc2_);
         }
         this._normalRoom.messages.length = 0;
         this._normalMessageOrder.length = 0;
         this._normalSeenMessages = new Dictionary(true);
         this._normalKnownMessages = new Dictionary(true);
         this._normalAllMessageSourceRooms = new Dictionary(true);
         this._normalMessageSourceRooms = new Dictionary(true);
         this._normalRoom.messagesChanged.dispatch();
         this.updateMessagesSection();
         for each(_loc2_ in _loc1_)
         {
            _loc2_.messagesChanged.dispatch();
         }
         if(this._chatMessageView is RichDOChatMessageTextArea)
         {
            RichDOChatMessageTextArea(this._chatMessageView).clearAllMessages();
         }
         else if(this._chatMessageView)
         {
            this._chatMessageView.clearMessages();
         }
         this.checkScrollbar();
      }
      
      private function addNormalMessage(param1:DOChatMessageVO, param2:DOChatRoomVO) : void
      {
         this._normalSeenMessages[param1] = true;
         this._normalMessageSourceRooms[param1] = param2;
         this._normalRoom.addMessage(param1);
      }
      
      private function updateNormalFilterPanelRooms() : void
      {
         if(Boolean(this._normalFilterPanel) && Boolean(this._data))
         {
            this._normalFilterPanel.setRooms(this._data.getRoomsAsVector(),this._normalFilterSelections);
         }
      }
      
      private function isNormalFilterRoomSelected(param1:DOChatRoomVO) : Boolean
      {
         return param1 != null && this._normalFilterSelections[param1.path] !== false;
      }
      
      private function isEligibleUnreadRoom(param1:DOChatRoomVO) : Boolean
      {
         return param1 != null && (param1.type == DOChatRoomVO.TYPE_GLOBAL || param1.type == DOChatRoomVO.TYPE_GROUP || param1.type == DOChatRoomVO.TYPE_CLAN || param1.type == DOChatRoomVO.TYPE_FACTION);
      }
      
      private function isUnreadCandidate(param1:DOChatMessageVO) : Boolean
      {
         return param1 != null && param1.user != null && param1.whisperType == DOChatMessageVO.WHISPER_TYPE_NONE && param1.user.usertype != DOChatUserVO.TYPE_SYSTEM && (ChatSettings.userName == null || ChatSettings.userName == "" || param1.user.username != ChatSettings.userName);
      }
      
      private function handleReportClicked(param1:MouseEvent = null) : void
      {
         this._reportView = this._reportView || new ReportView();
         this._reportView.showReportView(this._data.activeRoom);
         this._reportView.view.addEventListener(DOChatEvent.REPORT,this.handleReportSend);
      }
      
      private function handleReportRequested(param1:DOChatEvent) : void
      {
         if(!this._data || !this._data.activeRoom)
         {
            return;
         }
         var _loc2_:DOChatUserVO = param1.payload as DOChatUserVO;
         this._reportView = this._reportView || new ReportView();
         this._reportView.showReportView(this._data.activeRoom,_loc2_ ? _loc2_.username : null);
         this._reportView.view.addEventListener(DOChatEvent.REPORT,this.handleReportSend);
      }
      
      private function handleReportSend(param1:DOChatEvent) : void
      {
         dispatchEvent(param1.clone());
         this._reportView.view.removeEventListener(DOChatEvent.REPORT,this.handleReportSend);
      }
      
      private function handleReconnectButtonClicked(param1:MouseEvent) : void
      {
         this.clearAllMessages();
         dispatchEvent(new DOChatEvent(DOChatEvent.RECONNECT_USER_REQUEST));
      }
      
      private function handleClearMessagesButtonClicked(param1:MouseEvent) : void
      {
         FuiPopUpUtils.createPopupOkCancel(this.cleanMessage,null,BPLocale.getItemInCategory("chat","chat_chat_clear_history"));
      }
      
      private function handleSelectedRoomsChanged(param1:ItemListEvent) : void
      {
         var _loc2_:DOChatRoomVO = null;
         var _loc3_:int = 0;
         if(this._isSyncingRoomSelection)
         {
            return;
         }
         if(param1.itemVO)
         {
            _loc2_ = param1.itemVO as DOChatRoomVO;
            if(_loc2_ == this._normalRoom)
            {
               this.selectNormalTab();
               return;
            }
            _loc3_ = this._data.getRoomsAsVector().indexOf(_loc2_);
            if(_loc3_ == ItemList.UNSELECTED_INDEX)
            {
               return;
            }
            this._normalSelected = false;
            this._normalRoom.active = false;
            this.updateNormalFilterButtonVisibility();
            this.setChatRoomsCurrentEntry(_loc3_);
            if(Boolean(this._data) && this._data.activeRoom == _loc2_)
            {
               _loc2_.active = true;
               this.handleActiveRoomChanged();
               return;
            }
            dispatchEvent(new DOChatEvent(DOChatEvent.ACTIVE_ROOM_SELECTION_CHANGED,_loc2_.path));
            this.handleActiveRoomChanged();
         }
      }
      
      private function selectNormalTab(param1:Boolean = false) : void
      {
         this._normalSelected = true;
         this._normalRoom.active = true;
         if(Boolean(param1) && Boolean(this._roomItemList) && Boolean(this._data))
         {
            this.updateTabSection(true);
         }
         else
         {
            this.updateNormalFilterButtonVisibility();
         }
         this.handleActiveRoomChanged();
      }
      
      private function handleTextAreaKeyPressed(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.UP || param1.keyCode == Keyboard.DOWN || param1.keyCode == Keyboard.PAGE_UP || param1.keyCode == Keyboard.PAGE_DOWN)
         {
            this.handleTextAreaScrollEvent();
         }
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         this.addResizeListener();
      }
      
      private function handleWindowResize(param1:SimpleWindowEvent) : void
      {
         if(Boolean(stage) && Boolean(this._container))
         {
            this._container.width = this.parent.parent.width - 4;
            this._container.height = this.parent.parent.height - 10;
            this._container.forceRedraws([InvalidationType.LAYOUT,InvalidationType.SIZE],true);
            this.handleWindowResizeForTextArea();
            this._userInput.width = Math.max(20,this._container.width - this._userInput.marginLeft - this._userInput.marginRight);
            this._userInput.forceRedraws([InvalidationType.SIZE,InvalidationType.POSITION,InvalidationType.TEXT],true);
            if(this._emojiButton)
            {
               this._emojiButton.forceRedraws([InvalidationType.SIZE,InvalidationType.POSITION,InvalidationType.TEXT],true);
            }
            this.positionEmojiPanel();
            this.positionNormalFilterPanel();
            if(this._emojiInputPreview)
            {
               this._emojiInputPreview.refresh();
            }
            this.updateTabSection(false);
            this.checkScrollbar();
            this.flushScrollToBottomOnWindowOpen();
         }
      }
      
      private function handleUsernameClicked(param1:DOChatEvent) : void
      {
         this.setInputProtocolText("/w " + param1.payload + " ");
         this._userInput.setFocus();
      }
      
      private function handleCMDClicked(param1:DOChatEvent) : void
      {
         this.setInputProtocolText(param1.payload + " ");
      }
      
      private function handleInputKeyPressed(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.NUMPAD_ENTER)
         {
            this.sendOrWhisperMessage();
         }
         if(param1.keyCode == Keyboard.UP)
         {
            this.usePreviousHistoryEntry();
         }
         if(param1.keyCode == Keyboard.DOWN && this.currentHistoryIndex < this.history.length)
         {
            this.useNextHistoryEntry();
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
         this.refreshStageDismissListener();
      }
      
      private function handleEmojiSelected(param1:RichChatEmojiEvent) : void
      {
         var _loc2_:String = RichChatEmojiRegistry.createMarker(param1.emojiId);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:TextField = this.inputTextField;
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
      
      private function handleStageMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         var _loc3_:Boolean = _loc2_ != null && (this.isPanelOpen(this._emojiPanel) && this._emojiPanel.contains(_loc2_) || this._emojiButton != null && this._emojiButton.contains(_loc2_));
         var _loc4_:Boolean = _loc2_ != null && (this.isPanelOpen(this._normalFilterPanel) && this._normalFilterPanel.contains(_loc2_) || this._normalFilterButton != null && this._normalFilterButton.contains(_loc2_));
         if(!_loc3_)
         {
            this.closeEmojiPanel();
         }
         if(!_loc4_)
         {
            this.closeNormalFilterPanel();
         }
      }
      
      private function handleNormalFilterButtonClicked(param1:MouseEvent) : void
      {
         if(!this._normalSelected || !this._normalFilterPanel)
         {
            return;
         }
         if(this.isPanelOpen(this._normalFilterPanel))
         {
            this.closeNormalFilterPanel();
            return;
         }
         this.updateNormalFilterPanelRooms();
         var _loc2_:DisplayObjectContainer = ScreenManager.getInstance().getWindowLayer2();
         if(!_loc2_)
         {
            return;
         }
         _loc2_.addChild(this._normalFilterPanel);
         _loc2_.setChildIndex(this._normalFilterPanel,_loc2_.numChildren - 1);
         this._normalFilterPanel.visible = true;
         this.positionNormalFilterPanel();
         this.refreshStageDismissListener();
      }
      
      private function handleScrollRightClicked(param1:MouseEvent) : void
      {
         this._roomItemList.setScrollPositionInPercent(Math.min(1,this._roomItemList.getScrollPositionInPercent() + this._roomItemList.getScrollOneItemAmount()));
         this.updateTabSection(false);
      }
      
      private function handleScrollLeftClicked(param1:MouseEvent) : void
      {
         this._roomItemList.setScrollPositionInPercent(Math.max(0,this._roomItemList.getScrollPositionInPercent() - this._roomItemList.getScrollOneItemAmount()));
         if(this._roomItemList.getScrollPositionInPercent() < this._roomItemList.getScrollOneItemAmount())
         {
            this._roomItemList.setScrollPositionInPercent(0);
         }
         this.updateTabSection(false);
      }
      
      private function handleScrollbarPositionChangeEvent(param1:ScrollEvent) : void
      {
         var _loc2_:Number = NaN;
         if(this._messagesScrollbar)
         {
            clearTimeout(this._scrollbarTimeoutID);
            _loc2_ = this._messagesScrollbar.getScrollPositionInPercent();
            this._chatMessageView.setScrollPositionFraction(_loc2_);
         }
      }
      
      private function roomBoxChange(param1:DropUpBoxEvent) : *
      {
         if(this._isSyncingRoomSelection || !this._data)
         {
            return;
         }
         var _loc2_:Vector.<DOChatRoomVO> = this._data.getRoomsAsVector();
         if(!_loc2_ || param1.index < 0 || param1.index >= _loc2_.length)
         {
            return;
         }
         var _loc3_:DOChatRoomVO = _loc2_[param1.index];
         this._normalSelected = false;
         this._normalRoom.active = false;
         this.updateNormalFilterButtonVisibility();
         this._isSyncingRoomSelection = true;
         this._roomItemList.selectedIndex = param1.index + 1;
         this._isSyncingRoomSelection = false;
         if(this._data.activeRoom != _loc3_)
         {
            dispatchEvent(new DOChatEvent(DOChatEvent.ACTIVE_ROOM_SELECTION_CHANGED,_loc3_.path));
         }
         this.handleActiveRoomChanged();
      }
   }
}

