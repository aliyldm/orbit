package net.bigpoint.darkorbit.mvc.chatclient.view.richtext
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatMessageVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatRoomVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatUserVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatWhisperHistoryStorage;
   import net.bigpoint.darkorbit.mvc.chatclient.view.DOChatEvent;
   import net.bigpoint.darkorbit.mvc.chatclient.view.IDOChatMessagesView;
   
   public class RichDOChatMessageTextArea extends Sprite implements IDOChatMessagesView
   {
      
      private static const DEFAULT_WIDTH:Number = 400;
      
      private static const DEFAULT_HEIGHT:Number = 180;
      
      private static const ROW_GAP:Number = 4;
      
      private static const WHEEL_STEP:Number = 28;
      
      private static const SCROLL_EASING:Number = 0.35;
      
      private static const SCROLL_SNAP_DISTANCE:Number = 0.5;
      
      private static const MAX_WHISPER_HISTORY:int = DOChatWhisperHistoryStorage.MAX_MESSAGES;
      
      private static const BOTTOM_EPSILON:Number = 1;
      
      private static const NEW_MESSAGE_MARGIN:Number = 8;
      
      private var _data:DOChatRoomVO;
      
      private var _content:Sprite = new Sprite();
      
      private var _viewportMask:Sprite = new Sprite();
      
      private var _standaloneMessages:Vector.<DOChatMessageVO> = new Vector.<DOChatMessageVO>(0);
      
      private var _viewWidth:Number = 400;
      
      private var _viewHeight:Number = 180;
      
      private var _scrollY:Number = 0;
      
      private var _autoScroll:Boolean = true;
      
      private var _userMenu:RichChatUserMenu;
      
      private var _whisperWindow:RichChatWhisperWindow;
      
      private var _knownWhisperMessages:Dictionary = new Dictionary();
      
      private var _whisperHistory:Vector.<DOChatMessageVO> = new Vector.<DOChatMessageVO>(0);
      
      private var _whisperSourceRooms:Vector.<DOChatRoomVO> = new Vector.<DOChatRoomVO>(0);
      
      private var _messageSourceRooms:Dictionary;
      
      private var _clearedMessages:Dictionary = new Dictionary(true);
      
      private var _newMessageButton:RichChatNewMessageButton = new RichChatNewMessageButton();
      
      private var _scrollTargetY:Number = NaN;
      
      public function RichDOChatMessageTextArea()
      {
         super();
         mouseEnabled = true;
         mouseChildren = true;
         addChild(this._content);
         addChild(this._viewportMask);
         this._content.mask = this._viewportMask;
         this._newMessageButton.visible = false;
         this._newMessageButton.addEventListener(MouseEvent.CLICK,this.handleNewMessageButtonClicked);
         addChild(this._newMessageButton);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel);
         addEventListener(RichChatUserMenuEvent.OPEN,this.handleUserMenuOpen);
         this.restoreCachedWhisperMessages();
         this.redrawMask();
         this.positionNewMessageButton();
      }
      
      override public function get width() : Number
      {
         return this._viewWidth;
      }
      
      override public function set width(param1:Number) : void
      {
         var _loc2_:Number = Math.max(20,param1);
         if(this._viewWidth == _loc2_)
         {
            return;
         }
         this._viewWidth = _loc2_;
         this.redrawMask();
         this.positionNewMessageButton();
         this.resizeRows();
      }
      
      override public function get height() : Number
      {
         return this._viewHeight;
      }
      
      override public function set height(param1:Number) : void
      {
         this._viewHeight = Math.max(20,param1);
         this.closeUserMenu();
         this.redrawMask();
         this.positionNewMessageButton();
         this.updateScrollAfterLayout();
      }
      
      private function get contentHeight() : Number
      {
         return this._content.height;
      }
      
      private function get maxScroll() : Number
      {
         return Math.max(0,this.contentHeight - this._viewHeight);
      }
      
      public function setData(param1:DOChatRoomVO) : void
      {
         var _loc2_:Boolean = this._data == null || param1 == null || this._data.path != param1.path;
         if(this._data)
         {
            this._data.messagesChanged.remove(this.updateRows);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.messagesChanged.add(this.updateRows);
         }
         if(_loc2_)
         {
            this.stopSmoothScroll();
            this._autoScroll = true;
            this.hideNewMessageButton();
         }
         this.updateRows(false);
      }
      
      public function clearMessages() : void
      {
         var _loc2_:DOChatMessageVO = null;
         this.stopSmoothScroll();
         var _loc1_:Vector.<DOChatMessageVO> = this._data ? this._data.messages : this._standaloneMessages;
         for each(_loc2_ in _loc1_)
         {
            this._clearedMessages[_loc2_] = true;
         }
         this._autoScroll = true;
         this.hideNewMessageButton();
         this.updateRows(false);
      }
      
      public function clearAllMessages() : void
      {
         this.stopSmoothScroll();
         this._standaloneMessages.length = 0;
         this._clearedMessages = new Dictionary(true);
         this.updateWhisperWindowMessages(this._whisperHistory);
         this._autoScroll = true;
         this.hideNewMessageButton();
         this.updateRows(false);
      }
      
      public function setMessageSourceRooms(param1:Dictionary) : void
      {
         if(this._messageSourceRooms == param1)
         {
            return;
         }
         this._messageSourceRooms = param1;
         this.updateRows(false);
      }
      
      public function setWhisperSourceRooms(param1:Vector.<DOChatRoomVO>) : void
      {
         var _loc2_:DOChatRoomVO = null;
         var _loc3_:DOChatRoomVO = null;
         for each(_loc2_ in this._whisperSourceRooms)
         {
            _loc2_.messagesChanged.remove(this.handleWhisperSourceMessagesChanged);
         }
         this._whisperSourceRooms = param1 ? param1.slice() : new Vector.<DOChatRoomVO>(0);
         for each(_loc3_ in this._whisperSourceRooms)
         {
            _loc3_.messagesChanged.add(this.handleWhisperSourceMessagesChanged);
         }
         this.handleWhisperSourceMessagesChanged();
      }
      
      public function writeText(param1:DOChatMessageVO) : void
      {
         if(!param1)
         {
            return;
         }
         if(!this._data)
         {
            this._standaloneMessages.push(param1);
            this.updateRows();
         }
      }
      
      public function setScrollPositionFraction(param1:Number) : void
      {
         this.closeUserMenu();
         this.stopSmoothScroll();
         this._scrollY = Math.max(0,Math.min(1,param1)) * this.maxScroll;
         this._autoScroll = this._scrollY >= this.maxScroll;
         this.applyScroll();
      }
      
      public function scrollToBottom() : void
      {
         this.setScrollPositionFraction(1);
      }
      
      public function getScrollPositionFraction() : Number
      {
         return this.maxScroll <= 0 ? 1 : this._scrollY / this.maxScroll;
      }
      
      public function scrollbarNeeded() : Boolean
      {
         return this.contentHeight > this._viewHeight;
      }
      
      public function openWhisper(param1:DOChatUserVO, param2:Boolean = true) : void
      {
         this.restoreCachedWhisperMessages();
         if(!this._whisperWindow)
         {
            this._whisperWindow = new RichChatWhisperWindow();
            this._whisperWindow.addEventListener(RichChatWhisperWindow.CLOSE,this.handleWhisperWindowClose);
            this._whisperWindow.addEventListener(DOChatEvent.WHISPER_MESSAGE,this.relayDOChatEvent);
            this._whisperWindow.addEventListener(DOChatEvent.USERNAME_CLICKED,this.relayDOChatEvent);
            this._whisperWindow.addEventListener(DOChatEvent.CMD_CLICKED,this.relayDOChatEvent);
            this._whisperWindow.addEventListener(DOChatEvent.ACCEPT_INVITE_CLICKED,this.relayDOChatEvent);
            this._whisperWindow.addEventListener(DOChatEvent.OPEN_REPORT_REQUESTED,this.relayDOChatEvent);
            this._whisperWindow.addEventListener(DOChatEvent.ADD_FRIEND_REQUESTED,this.relayDOChatEvent);
            this._whisperWindow.addEventListener(DOChatEvent.GROUP_INVITE_REQUESTED,this.relayDOChatEvent);
            this._whisperWindow.addEventListener(DOChatEvent.ADD_TO_BLACKLIST_REQUESTED,this.relayDOChatEvent);
            this._whisperWindow.addEventListener(DOChatEvent.WHISPER_VIEW_OPENED,this.relayDOChatEvent);
            this._whisperWindow.addEventListener(DOChatEvent.CLEAR_WHISPER_HISTORY_REQUESTED,this.handleClearWhisperHistoryRequested);
         }
         this._whisperWindow.openUser(param1,param2);
         this.rememberWhisperMessages(this._data ? this._data.messages : this._standaloneMessages);
         this.updateWhisperWindowMessages(this._whisperHistory);
         if(param2)
         {
            this._whisperWindow.focusInput();
         }
      }
      
      private function updateRows(param1:Boolean = true) : void
      {
         var _loc5_:int = 0;
         var _loc6_:RichChatMessageRow = null;
         var _loc11_:DOChatMessageVO = null;
         var _loc12_:DOChatRoomVO = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:RichChatMessageRow = null;
         this.closeUserMenu();
         var _loc2_:Boolean = !this._autoScroll && !this.isAtBottom();
         var _loc3_:Boolean = false;
         var _loc4_:Dictionary = new Dictionary();
         _loc5_ = 0;
         while(_loc5_ < this._content.numChildren)
         {
            _loc6_ = this._content.getChildAt(_loc5_) as RichChatMessageRow;
            if(_loc6_)
            {
               _loc4_[_loc6_.message] = _loc6_;
            }
            _loc5_++;
         }
         var _loc7_:Vector.<DOChatMessageVO> = this._data ? this._data.messages : this._standaloneMessages;
         var _loc8_:Vector.<DOChatMessageVO> = this.getChannelMessages(_loc7_);
         var _loc9_:Vector.<RichChatMessageRow> = new Vector.<RichChatMessageRow>(0);
         var _loc10_:String = this._data ? this._data.translatedName : "";
         for each(_loc11_ in _loc8_)
         {
            _loc12_ = this._messageSourceRooms ? this._messageSourceRooms[_loc11_] as DOChatRoomVO : null;
            _loc13_ = _loc12_ ? _loc12_.translatedName : _loc10_;
            _loc14_ = _loc12_ ? _loc12_.type : (this._data ? this._data.type : "");
            _loc15_ = _loc4_[_loc11_] as RichChatMessageRow;
            if(!_loc15_)
            {
               _loc3_ = true;
               _loc15_ = this.createRow(_loc11_,_loc13_,_loc14_);
            }
            else
            {
               _loc15_.channelName = _loc13_;
               _loc15_.channelType = _loc14_;
            }
            _loc9_.push(_loc15_);
         }
         this.removeContentChildren();
         for each(_loc15_ in _loc9_)
         {
            this._content.addChild(_loc15_);
         }
         this.layoutRows();
         this.syncWhisperWindow(_loc7_);
         this.updateScrollAfterLayout();
         if(param1 && _loc2_ && _loc3_)
         {
            this.showNewMessageButton();
         }
      }
      
      private function getChannelMessages(param1:Vector.<DOChatMessageVO>) : Vector.<DOChatMessageVO>
      {
         var _loc3_:DOChatMessageVO = null;
         var _loc2_:Vector.<DOChatMessageVO> = new Vector.<DOChatMessageVO>(0);
         for each(_loc3_ in param1)
         {
            if(!this._clearedMessages[_loc3_] && !this.isWhisperMessage(_loc3_))
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      private function isWhisperMessage(param1:DOChatMessageVO) : Boolean
      {
         return Boolean(param1) && (param1.whisperType == DOChatMessageVO.WHISPER_TYPE_THEY || param1.whisperType == DOChatMessageVO.WHISPER_TYPE_YOU);
      }
      
      private function createRow(param1:DOChatMessageVO, param2:String, param3:String) : RichChatMessageRow
      {
         var _loc4_:RichChatMessageRow = new RichChatMessageRow(param1,this._viewWidth,param2,false,param3);
         _loc4_.addEventListener(DOChatEvent.USERNAME_CLICKED,this.relayDOChatEvent);
         _loc4_.addEventListener(DOChatEvent.CMD_CLICKED,this.relayDOChatEvent);
         _loc4_.addEventListener(DOChatEvent.ACCEPT_INVITE_CLICKED,this.relayDOChatEvent);
         return _loc4_;
      }
      
      private function resizeRows() : void
      {
         var _loc2_:RichChatMessageRow = null;
         this.closeUserMenu();
         var _loc1_:int = 0;
         while(_loc1_ < this._content.numChildren)
         {
            _loc2_ = this._content.getChildAt(_loc1_) as RichChatMessageRow;
            if(_loc2_)
            {
               _loc2_.availableWidth = this._viewWidth;
            }
            _loc1_++;
         }
         this.layoutRows();
         this.updateScrollAfterLayout();
      }
      
      private function layoutRows() : void
      {
         var _loc3_:RichChatMessageRow = null;
         var _loc1_:Number = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._content.numChildren)
         {
            _loc3_ = this._content.getChildAt(_loc2_) as RichChatMessageRow;
            if(_loc3_)
            {
               _loc3_.y = _loc1_;
               _loc1_ += _loc3_.height + ROW_GAP;
            }
            _loc2_++;
         }
      }
      
      private function updateScrollAfterLayout() : void
      {
         if(this._autoScroll)
         {
            this._scrollY = this.maxScroll;
         }
         else
         {
            this._scrollY = Math.min(this._scrollY,this.maxScroll);
         }
         this.applyScroll();
      }
      
      private function applyScroll() : void
      {
         this._scrollY = Math.max(0,Math.min(this.maxScroll,this._scrollY));
         this._content.y = -this._scrollY;
         if(this.isAtBottom())
         {
            this._autoScroll = true;
            this.hideNewMessageButton();
         }
      }
      
      private function isAtBottom() : Boolean
      {
         return this.maxScroll <= 0 || this._scrollY >= this.maxScroll - BOTTOM_EPSILON;
      }
      
      private function showNewMessageButton() : void
      {
         this._newMessageButton.visible = !this._autoScroll && !this.isAtBottom();
      }
      
      private function hideNewMessageButton() : void
      {
         this._newMessageButton.visible = false;
      }
      
      private function positionNewMessageButton() : void
      {
         this._newMessageButton.x = Math.max(0,this._viewWidth - RichChatNewMessageButton.BUTTON_WIDTH - NEW_MESSAGE_MARGIN);
         this._newMessageButton.y = Math.max(0,this._viewHeight - RichChatNewMessageButton.BUTTON_HEIGHT - NEW_MESSAGE_MARGIN);
      }
      
      private function redrawMask() : void
      {
         graphics.clear();
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,this._viewWidth,this._viewHeight);
         graphics.endFill();
         this._viewportMask.graphics.clear();
         this._viewportMask.graphics.beginFill(16711935,1);
         this._viewportMask.graphics.drawRect(0,0,this._viewWidth,this._viewHeight);
         this._viewportMask.graphics.endFill();
      }
      
      private function removeContentChildren() : void
      {
         while(this._content.numChildren > 0)
         {
            this._content.removeChildAt(0);
         }
      }
      
      private function openWhisperWindow(param1:DOChatUserVO, param2:Boolean = true) : void
      {
         this.openWhisper(param1,param2);
      }
      
      private function updateWhisperWindowMessages(param1:Vector.<DOChatMessageVO>) : void
      {
         if(this._whisperWindow)
         {
            this._whisperWindow.updateMessages(param1);
         }
      }
      
      private function syncWhisperWindow(param1:Vector.<DOChatMessageVO>) : void
      {
         this.rememberWhisperMessages(param1);
         this.updateWhisperWindowMessages(this._whisperHistory);
      }
      
      private function rememberWhisperMessages(param1:Vector.<DOChatMessageVO>) : void
      {
         var _loc2_:DOChatMessageVO = null;
         var _loc3_:DOChatMessageVO = null;
         if(!param1)
         {
            return;
         }
         for each(_loc2_ in param1)
         {
            if(!(!this.isWhisperMessage(_loc2_) || Boolean(this._knownWhisperMessages[_loc2_])))
            {
               this._knownWhisperMessages[_loc2_] = true;
               this._whisperHistory.push(_loc2_);
            }
         }
         while(this._whisperHistory.length > MAX_WHISPER_HISTORY)
         {
            _loc3_ = this._whisperHistory.shift();
            delete this._knownWhisperMessages[_loc3_];
         }
      }
      
      private function clearWhisperConversation(param1:String) : void
      {
         var _loc5_:DOChatRoomVO = null;
         var _loc2_:String = param1.toLowerCase();
         this.removeWhisperMessagesForUser(this._whisperHistory,_loc2_,true);
         this.removeWhisperMessagesForUser(this._standaloneMessages,_loc2_,false);
         var _loc3_:Vector.<DOChatRoomVO> = new Vector.<DOChatRoomVO>(0);
         var _loc4_:Vector.<DOChatRoomVO> = this._whisperSourceRooms.slice();
         if(Boolean(this._data) && _loc4_.indexOf(this._data) == -1)
         {
            _loc4_.push(this._data);
         }
         for each(_loc5_ in _loc4_)
         {
            if(Boolean(_loc5_) && this.removeWhisperMessagesForUser(_loc5_.messages,_loc2_,false))
            {
               _loc3_.push(_loc5_);
            }
         }
         DOChatWhisperHistoryStorage.removeConversation(param1);
         this.updateWhisperWindowMessages(this._whisperHistory);
         for each(_loc5_ in _loc3_)
         {
            _loc5_.messagesChanged.dispatch();
         }
         this.updateRows(false);
      }
      
      private function removeWhisperMessagesForUser(param1:Vector.<DOChatMessageVO>, param2:String, param3:Boolean) : Boolean
      {
         var _loc6_:DOChatMessageVO = null;
         if(!param1)
         {
            return false;
         }
         var _loc4_:Boolean = false;
         var _loc5_:* = int(param1.length - 1);
         while(_loc5_ >= 0)
         {
            _loc6_ = param1[_loc5_];
            if(!(!this.isWhisperMessage(_loc6_) || !_loc6_.user || !_loc6_.user.username || _loc6_.user.username.toLowerCase() != param2))
            {
               param1.splice(_loc5_,1);
               if(param3)
               {
                  delete this._knownWhisperMessages[_loc6_];
               }
               _loc4_ = true;
            }
            _loc5_--;
         }
         return _loc4_;
      }
      
      private function restoreCachedWhisperMessages() : void
      {
         var _loc2_:DOChatMessageVO = null;
         var _loc3_:DOChatMessageVO = null;
         var _loc1_:Vector.<DOChatMessageVO> = DOChatWhisperHistoryStorage.getMessages();
         for each(_loc2_ in _loc1_)
         {
            if(!this._knownWhisperMessages[_loc2_])
            {
               this._knownWhisperMessages[_loc2_] = true;
               this._whisperHistory.push(_loc2_);
            }
         }
         while(this._whisperHistory.length > MAX_WHISPER_HISTORY)
         {
            _loc3_ = this._whisperHistory.shift();
            delete this._knownWhisperMessages[_loc3_];
         }
      }
      
      private function handleWhisperSourceMessagesChanged() : void
      {
         var _loc1_:DOChatRoomVO = null;
         this.restoreCachedWhisperMessages();
         for each(_loc1_ in this._whisperSourceRooms)
         {
            this.rememberWhisperMessages(_loc1_.messages);
         }
         this.updateWhisperWindowMessages(this._whisperHistory);
      }
      
      private function closeWhisperWindow() : void
      {
         if(!this._whisperWindow)
         {
            return;
         }
         this._whisperWindow.hide();
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
      
      private function stopSmoothScroll() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.handleSmoothScrollFrame);
         this._scrollTargetY = NaN;
      }
      
      private function handleClearWhisperHistoryRequested(param1:DOChatEvent) : void
      {
         var _loc2_:DOChatUserVO = param1.payload as DOChatUserVO;
         if(!_loc2_ || !_loc2_.username)
         {
            return;
         }
         this.clearWhisperConversation(_loc2_.username);
      }
      
      private function handleNewMessageButtonClicked(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         this.stopSmoothScroll();
         this._autoScroll = true;
         this._scrollY = this.maxScroll;
         this.applyScroll();
      }
      
      private function relayDOChatEvent(param1:DOChatEvent) : void
      {
         dispatchEvent(param1.clone());
      }
      
      private function handleUserMenuOpen(param1:RichChatUserMenuEvent) : void
      {
         var _loc2_:Point = null;
         if(param1.user.userId == Hero.userID.toString())
         {
            return;
         }
         param1.stopPropagation();
         this.closeUserMenu();
         this._userMenu = new RichChatUserMenu(param1.user);
         this._userMenu.addEventListener(RichChatUserMenuEvent.ACTION,this.handleUserMenuAction);
         addChild(this._userMenu);
         _loc2_ = globalToLocal(param1.anchor);
         this._userMenu.x = Math.max(0,Math.min(this._viewWidth - this._userMenu.width,_loc2_.x));
         this._userMenu.y = _loc2_.y + this._userMenu.height <= this._viewHeight ? _loc2_.y : _loc2_.y - this._userMenu.height - 32;
         this._userMenu.y = Math.max(0,Math.min(this._viewHeight - this._userMenu.height,this._userMenu.y));
         if(stage)
         {
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.handleStageMouseDown,false,0,true);
         }
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
               this.openWhisperWindow(_loc2_);
               break;
            case RichChatUserMenu.REPORT:
               dispatchEvent(new DOChatEvent(DOChatEvent.OPEN_REPORT_REQUESTED,_loc2_,true));
               break;
            case RichChatUserMenu.ADD_TO_BLACKLIST:
               dispatchEvent(new DOChatEvent(DOChatEvent.ADD_TO_BLACKLIST_REQUESTED,_loc2_,true));
         }
         this.closeUserMenu();
      }
      
      private function handleWhisperWindowClose(param1:Event) : void
      {
         this.closeWhisperWindow();
      }
      
      private function handleStageMouseDown(param1:MouseEvent) : void
      {
         if(Boolean(this._userMenu) && this._userMenu.hitTestPoint(param1.stageX,param1.stageY,true))
         {
            return;
         }
         this.closeUserMenu();
      }
      
      private function handleMouseWheel(param1:MouseEvent) : void
      {
         this.closeUserMenu();
         if(!this.scrollbarNeeded())
         {
            return;
         }
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
         this._autoScroll = this._scrollY >= this.maxScroll - BOTTOM_EPSILON;
         this.applyScroll();
      }
   }
}

