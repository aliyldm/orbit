package net.bigpoint.darkorbit.mvc.chatclient.view
{
   import flash.display.DisplayObject;
   import net.bigpoint.darkorbit.com.module.InvitationCreationRequest;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.chatclient.DOChatClientNotifications;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatModelVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatUserVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatWhisperMessageVO;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.ContactsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DOChatMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "DOChatMediator";
      
      private var _viewModelReference:DOChatModelVO;
      
      public function DOChatMediator(param1:IDOChatView, param2:DOChatModelVO)
      {
         super(NAME,param1);
         mapNotificationToMethod(DOChatClientNotifications.OPEN_REPORT,this.openReport);
         mapNotificationToMethod(DOChatClientNotifications.OPEN_WHISPER,this.openWhisper);
         this._viewModelReference = param2;
         param1.setData(param2);
      }
      
      private function get view() : IDOChatView
      {
         return viewComponent as IDOChatView;
      }
      
      override public function onRegister() : void
      {
         this._viewModelReference.unreadChanged.add(this.handleUnreadChanged);
         this.addListeners();
         this.handleUnreadChanged();
      }
      
      override public function onRemove() : void
      {
         this._viewModelReference.unreadChanged.remove(this.handleUnreadChanged);
         this.removeListeners();
      }
      
      private function handleUnreadChanged() : void
      {
         sendNotification(DOChatClientNotifications.UNREAD_CHANGED,this._viewModelReference.hasUnreadPublicChannelMessages ? 1 : 0);
      }
      
      private function openReport(... rest) : void
      {
         this.view.openReportView();
      }
      
      private function openWhisper(param1:INotification) : void
      {
         var _loc2_:DOChatFUIView = this.view as DOChatFUIView;
         var _loc3_:DOChatUserVO = param1.getBody() as DOChatUserVO;
         if(Boolean(_loc2_) && Boolean(_loc3_))
         {
            _loc2_.openWhisperView(_loc3_);
         }
      }
      
      private function addListeners() : void
      {
         this.view.addEventListener(DOChatEvent.SEND_MESSAGE,this.handleSendMessage);
         this.view.addEventListener(DOChatEvent.WHISPER_MESSAGE,this.handleWhisperMessage);
         this.view.addEventListener(DOChatEvent.WHISPER_VIEW_OPENED,this.handleWhisperViewOpened);
         this.view.addEventListener(DOChatEvent.ACTIVE_ROOM_SELECTION_CHANGED,this.handleActiveRoomSelectionChanged);
         this.view.addEventListener(DOChatEvent.ACCEPT_INVITE_CLICKED,this.handleRoomInvitationAccepted);
         this.view.addEventListener(DOChatEvent.RECONNECT_USER_REQUEST,this.handleReconnectRequested);
         this.view.addEventListener(DOChatEvent.REPORT,this.handleReportClicked);
         this.view.addEventListener(DOChatEvent.ADD_FRIEND_REQUESTED,this.handleAddFriendRequested);
         this.view.addEventListener(DOChatEvent.GROUP_INVITE_REQUESTED,this.handleGroupInviteRequested);
         this.view.addEventListener(DOChatEvent.ADD_TO_BLACKLIST_REQUESTED,this.handleAddToBlacklistRequested);
         Settings.displayChat.changed.add(this.handleDisplayChat);
         this.handleDisplayChat();
      }
      
      private function handleDisplayChat() : void
      {
         var _loc1_:SimpleWindow = null;
         if(Settings.displayChat.value)
         {
            _loc1_ = guiManager.getWindow(GuiConstants.CHAT_WINDOW) || guiManager.createWindow(GuiConstants.CHAT_WINDOW) as SimpleWindow;
            _loc1_.getRootContainer().addChild(this.view as DisplayObject);
         }
         else
         {
            guiManager.destroyWindow(GuiConstants.CHAT_WINDOW);
            guiManager.deleteWindow(GuiConstants.CHAT_WINDOW);
            MovieClipUtils.removeDisplayObject(this.view as DisplayObject);
         }
      }
      
      private function removeListeners() : void
      {
         Settings.displayChat.changed.remove(this.handleDisplayChat);
         this.view.removeEventListener(DOChatEvent.SEND_MESSAGE,this.handleSendMessage);
         this.view.removeEventListener(DOChatEvent.WHISPER_MESSAGE,this.handleWhisperMessage);
         this.view.removeEventListener(DOChatEvent.WHISPER_VIEW_OPENED,this.handleWhisperViewOpened);
         this.view.removeEventListener(DOChatEvent.ACTIVE_ROOM_SELECTION_CHANGED,this.handleActiveRoomSelectionChanged);
         this.view.removeEventListener(DOChatEvent.ACCEPT_INVITE_CLICKED,this.handleRoomInvitationAccepted);
         this.view.removeEventListener(DOChatEvent.RECONNECT_USER_REQUEST,this.handleReconnectRequested);
         this.view.removeEventListener(DOChatEvent.REPORT,this.handleReportClicked);
         this.view.removeEventListener(DOChatEvent.ADD_FRIEND_REQUESTED,this.handleAddFriendRequested);
         this.view.removeEventListener(DOChatEvent.GROUP_INVITE_REQUESTED,this.handleGroupInviteRequested);
         this.view.removeEventListener(DOChatEvent.ADD_TO_BLACKLIST_REQUESTED,this.handleAddToBlacklistRequested);
      }
      
      private function handleAddFriendRequested(param1:DOChatEvent) : void
      {
         var _loc2_:DOChatUserVO = param1.payload as DOChatUserVO;
         if(Boolean(_loc2_) && Boolean(_loc2_.username))
         {
            sendNotification(ContactsWindowNotifications.SEND_INVITE,_loc2_.username);
         }
      }
      
      private function handleGroupInviteRequested(param1:DOChatEvent) : void
      {
         var _loc2_:DOChatUserVO = param1.payload as DOChatUserVO;
         if(Boolean(_loc2_) && Boolean(_loc2_.username))
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new InvitationCreationRequest(_loc2_.username));
         }
      }
      
      private function handleAddToBlacklistRequested(param1:DOChatEvent) : void
      {
         var _loc2_:DOChatUserVO = param1.payload as DOChatUserVO;
         if(Boolean(_loc2_) && Boolean(_loc2_.username))
         {
            sendNotification(ContactsWindowNotifications.SEND_BLOCK,_loc2_.username);
         }
      }
      
      private function handleReportClicked(param1:DOChatEvent) : void
      {
         sendNotification(DOChatClientNotifications.REPORT_USER,param1.payload);
      }
      
      private function handleReconnectRequested(param1:DOChatEvent) : void
      {
         facade.sendNotification(DOChatClientNotifications.RECONNECT);
      }
      
      private function handleRoomInvitationAccepted(param1:DOChatEvent) : void
      {
         sendNotification(DOChatClientNotifications.INVITE_ACCEPTED,param1.payload);
      }
      
      private function handleActiveRoomSelectionChanged(param1:DOChatEvent) : void
      {
         sendNotification(DOChatClientNotifications.CHANGE_ACTIVE_ROOM,param1.payload);
      }
      
      private function handleSendMessage(param1:DOChatEvent) : void
      {
         sendNotification(DOChatClientNotifications.SEND_MESSAGE,param1.payload);
      }
      
      private function handleWhisperMessage(param1:DOChatEvent) : void
      {
         var _loc2_:DOChatWhisperMessageVO = param1.payload as DOChatWhisperMessageVO;
         if(!_loc2_)
         {
            _loc2_ = new DOChatWhisperMessageVO(String(param1.payload));
         }
         sendNotification(DOChatClientNotifications.WHISPER_MESSAGE,_loc2_);
      }
      
      private function handleWhisperViewOpened(param1:DOChatEvent) : void
      {
         var _loc2_:DOChatUserVO = param1.payload as DOChatUserVO;
         if(!_loc2_ || !_loc2_.username)
         {
            return;
         }
         var _loc3_:Number = Number(_loc2_.userId);
         sendNotification(ContactsWindowNotifications.CLEAR_WHISPER_UNREAD,[_loc2_.username,isNaN(_loc3_) || _loc3_ <= 0 ? -1 : int(_loc3_)]);
      }
   }
}

