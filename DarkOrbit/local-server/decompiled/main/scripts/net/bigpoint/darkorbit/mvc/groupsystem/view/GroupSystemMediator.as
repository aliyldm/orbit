package net.bigpoint.darkorbit.mvc.groupsystem.view
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.ChangeLeaderRequest;
   import net.bigpoint.darkorbit.com.module.FollowRequest;
   import net.bigpoint.darkorbit.com.module.GroupInvitationBlockToggleRequest;
   import net.bigpoint.darkorbit.com.module.GroupMemberSelectRequest;
   import net.bigpoint.darkorbit.com.module.InvitationAcceptRequest;
   import net.bigpoint.darkorbit.com.module.InvitationCancelRequest;
   import net.bigpoint.darkorbit.com.module.InvitationCreationRequest;
   import net.bigpoint.darkorbit.com.module.InvitationModeModule;
   import net.bigpoint.darkorbit.com.module.InvitationModeRequest;
   import net.bigpoint.darkorbit.com.module.InvitationRejectRequest;
   import net.bigpoint.darkorbit.com.module.KickMemberRequest;
   import net.bigpoint.darkorbit.com.module.LeaveGroupRequest;
   import net.bigpoint.darkorbit.com.module.PingMemberRequest;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.KeyboardNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.ContactsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.Group;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.Invitation;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.InvitationDeleteVo;
   import net.bigpoint.darkorbit.mvc.groupsystem.notification.GroupSystemNotification;
   import net.bigpoint.darkorbit.mvc.groupsystem.view.events.GroupSystemBehaviorEvent;
   import net.bigpoint.darkorbit.mvc.groupsystem.view.events.GroupSystemEvent;
   import net.bigpoint.darkorbit.mvc.groupsystem.view.events.GroupSystemInvitationEvent;
   import net.bigpoint.darkorbit.mvc.groupsystem.view.ui.GroupUI;
   import net.bigpoint.darkorbit.mvc.groupsystem.vo.InvitationUiVO;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class GroupSystemMediator extends Mediator
   {
      
      public static const NAME:String = "GroupSystemMediator";
      
      public function GroupSystemMediator(param1:Object = null)
      {
         super(NAME);
         this.setViewComponent(param1);
      }
      
      private function get groupUi() : GroupUI
      {
         return viewComponent as GroupUI;
      }
      
      override public function onRemove() : void
      {
         this.removeEventListeners();
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_ID,GuiConstants.GROUP_SYSTEM_WINDOW);
         super.onRemove();
      }
      
      private function removeEventListeners() : void
      {
         this.groupUi.removeEventListener(GroupSystemEvent.TOGGLE_PING_MODE_BUTTON_CLICKED,this.handlePingButtonToggled);
         this.groupUi.removeEventListener(GroupSystemEvent.CHANGE_LEADER,this.handleChangeLeader);
         this.groupUi.removeEventListener(GroupSystemEvent.FLY_TO_MEMBER,this.handleFlyToMember);
         this.groupUi.removeEventListener(GroupSystemBehaviorEvent.INVITATION_BEHAVIOR_TOGGLE,this.handleInvitationBehaviorChanged);
         this.groupUi.removeEventListener(GroupSystemEvent.INVITATION_BLOCK_TOGGLE,this.handleInvitationBlockChanged);
         this.groupUi.removeEventListener(GroupSystemEvent.KICK_MEMBER,this.handlekickMember);
         this.groupUi.removeEventListener(GroupSystemEvent.LEAVE_GROUP,this.handleleaveGroup);
         this.groupUi.removeEventListener(GroupSystemEvent.TRY_TO_SELECT_MAPASSET,this.handleTryToSelectMapAsset);
         this.groupUi.removeEventListener(GroupSystemBehaviorEvent.INVITATION_BEHAVIOR_TOGGLE,this.handleInvitationBehaviorChanged);
         this.groupUi.removeEventListener(GroupSystemInvitationEvent.ACCEPT,this.handleInvitationAccept);
         this.groupUi.removeEventListener(GroupSystemInvitationEvent.INVITE,this.handleInvite);
         this.groupUi.removeEventListener(GroupSystemInvitationEvent.REJECT,this.handleInvitationReject);
         this.groupUi.removeEventListener(GroupSystemInvitationEvent.REVOKE,this.handleInvitationRevoke);
         this.groupUi.removeEventListener(GroupSystemEvent.BLOCK_KEYBOARD,this.handleBlockKeyboard);
         this.groupUi.removeEventListener(GroupSystemEvent.UNBLOCK_KEYBOARD,this.handleUnblockKeyboard);
      }
      
      override public function setViewComponent(param1:Object) : void
      {
         super.setViewComponent(param1);
         this.addEventListeners();
      }
      
      private function addEventListeners() : void
      {
         this.groupUi.addEventListener(GroupSystemEvent.TOGGLE_PING_MODE_BUTTON_CLICKED,this.handlePingButtonToggled);
         this.groupUi.addEventListener(GroupSystemEvent.PING_MEMBER,this.handlePingMember);
         this.groupUi.addEventListener(GroupSystemEvent.CHANGE_LEADER,this.handleChangeLeader);
         this.groupUi.addEventListener(GroupSystemEvent.FLY_TO_MEMBER,this.handleFlyToMember);
         this.groupUi.addEventListener(GroupSystemEvent.INVITATION_BLOCK_TOGGLE,this.handleInvitationBlockChanged);
         this.groupUi.addEventListener(GroupSystemEvent.KICK_MEMBER,this.handlekickMember);
         this.groupUi.addEventListener(GroupSystemEvent.LEAVE_GROUP,this.handleleaveGroup);
         this.groupUi.addEventListener(GroupSystemEvent.TRY_TO_SELECT_MAPASSET,this.handleTryToSelectMapAsset);
         this.groupUi.addEventListener(GroupSystemBehaviorEvent.INVITATION_BEHAVIOR_TOGGLE,this.handleInvitationBehaviorChanged);
         this.groupUi.addEventListener(GroupSystemInvitationEvent.ACCEPT,this.handleInvitationAccept);
         this.groupUi.addEventListener(GroupSystemInvitationEvent.INVITE,this.handleInvite);
         this.groupUi.addEventListener(GroupSystemInvitationEvent.REJECT,this.handleInvitationReject);
         this.groupUi.addEventListener(GroupSystemInvitationEvent.REVOKE,this.handleInvitationRevoke);
         this.groupUi.addEventListener(GroupSystemEvent.BLOCK_KEYBOARD,this.handleBlockKeyboard);
         this.groupUi.addEventListener(GroupSystemEvent.UNBLOCK_KEYBOARD,this.handleUnblockKeyboard);
      }
      
      private function handleUnblockKeyboard(param1:GroupSystemEvent) : void
      {
         sendNotification(KeyboardNotifications.UNLOCK_KEYBOARD);
      }
      
      private function handleBlockKeyboard(param1:GroupSystemEvent) : void
      {
         sendNotification(KeyboardNotifications.LOCK_KEYBOARD);
      }
      
      private function handlePingMember(param1:GroupSystemEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new PingMemberRequest(param1.affectedMember.id));
      }
      
      private function handleInvitationRevoke(param1:GroupSystemInvitationEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new InvitationCancelRequest(param1.invitationId));
         sendNotification(GroupSystemNotification.REMOVE_INVITATION_BY_MEMBER_ID,new InvitationDeleteVo(param1.invitationId,InvitationDeleteVo.OUTGOING));
      }
      
      private function handleInvitationReject(param1:GroupSystemInvitationEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new InvitationRejectRequest(param1.invitationId));
         sendNotification(GroupSystemNotification.REMOVE_INVITATION_BY_MEMBER_ID,new InvitationDeleteVo(param1.invitationId,InvitationDeleteVo.INCOMMING));
      }
      
      private function handleInvite(param1:GroupSystemInvitationEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new InvitationCreationRequest(param1.candidateName));
      }
      
      private function handleInvitationAccept(param1:GroupSystemInvitationEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new InvitationAcceptRequest(param1.invitationId));
         sendNotification(GroupSystemNotification.REMOVE_INVITATION_BY_MEMBER_ID,new InvitationDeleteVo(param1.invitationId,InvitationDeleteVo.INCOMMING));
      }
      
      private function handleTryToSelectMapAsset(param1:GroupSystemEvent) : void
      {
         if(param1.affectedMember != null)
         {
            sendNotification(ContactsWindowNotifications.SHIP_SELECTED,[param1.affectedMember.id,param1.affectedMember.nickName]);
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new GroupMemberSelectRequest(param1.affectedMember.id));
         }
      }
      
      private function handleleaveGroup(param1:GroupSystemEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new LeaveGroupRequest());
      }
      
      private function handlekickMember(param1:GroupSystemEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new KickMemberRequest(param1.affectedMember.id));
      }
      
      private function handleInvitationBlockChanged(param1:GroupSystemEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new GroupInvitationBlockToggleRequest());
      }
      
      private function handleInvitationBehaviorChanged(param1:GroupSystemBehaviorEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new InvitationModeRequest(new InvitationModeModule(param1.mode)));
      }
      
      private function handleFlyToMember(param1:GroupSystemEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new FollowRequest(param1.affectedMember.id));
      }
      
      private function handleChangeLeader(param1:GroupSystemEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ChangeLeaderRequest(param1.affectedMember.id));
      }
      
      private function handlePingButtonToggled(param1:GroupSystemEvent) : void
      {
         sendNotification(GroupSystemNotification.UPDATE_MODEL_PING_STATE,this.groupUi.isInPingMode);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [GroupSystemNotification.CLEANUP_UI,GroupSystemNotification.PREPARE_USER,GroupSystemNotification.UPDATE_UI_PING_MODE,GroupSystemNotification.UPDATE_UI,GroupSystemNotification.REMOVE_MEMBER_CLIP,GroupSystemNotification.ADD_INVITATION,GroupSystemNotification.REMOVE_INVITATION_UI,GroupSystemNotification.UPDATE_BLOCK_INVITATION_STATE,GroupSystemNotification.RELATED_DATA_CHANGED];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:InvitationUiVO = null;
         switch(param1.getName())
         {
            case GroupSystemNotification.UPDATE_UI:
               this.groupUi.setGroup(param1.getBody() as Group);
               this.groupUi.update();
               break;
            case GroupSystemNotification.REMOVE_MEMBER_CLIP:
               this.groupUi.removeMemberClip(int(param1.getBody()));
               break;
            case GroupSystemNotification.ADD_INVITATION:
               this.addInvitation(param1.getBody() as Invitation);
               break;
            case GroupSystemNotification.REMOVE_INVITATION_UI:
               _loc2_ = param1.getBody() as InvitationUiVO;
               this.groupUi.removeInvitation(_loc2_.memberID,_loc2_.invitationType);
               break;
            case GroupSystemNotification.UPDATE_BLOCK_INVITATION_STATE:
               this.groupUi.updateBlockInvitationsState(Boolean(param1.getBody()));
               break;
            case GroupSystemNotification.UPDATE_UI_PING_MODE:
               this.groupUi.isInPingMode = Boolean(param1.getBody());
               break;
            case GroupSystemNotification.PREPARE_USER:
               this.groupUi.setCanditate(param1.getBody() as String);
               break;
            case GroupSystemNotification.CLEANUP_UI:
               this.cleanup();
               break;
            case GroupSystemNotification.RELATED_DATA_CHANGED:
               this.groupUi.relatedDataChanged();
         }
      }
      
      private function addInvitation(param1:Invitation) : void
      {
         this.groupUi.addInvitation(param1);
         if(param1.getInviter().id != Hero.userID)
         {
            facade.sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(BPLocale.getItem("label_grp_inv_from").replace(/%name%/,param1.getInviter().nickName)));
         }
      }
      
      public function cleanup() : void
      {
         this.groupUi.dispose();
         this.groupUi.update();
      }
   }
}

