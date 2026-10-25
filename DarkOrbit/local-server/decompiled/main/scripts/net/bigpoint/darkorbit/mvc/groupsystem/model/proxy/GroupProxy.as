package net.bigpoint.darkorbit.mvc.groupsystem.model.proxy
{
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.ActivityModule;
   import net.bigpoint.darkorbit.com.module.ClanModule;
   import net.bigpoint.darkorbit.com.module.CloakDeviceActivityModule;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.com.module.FightActivityModule;
   import net.bigpoint.darkorbit.com.module.HealthModule;
   import net.bigpoint.darkorbit.com.module.InvitationBlockModule;
   import net.bigpoint.darkorbit.com.module.InvitationRemovalCommand;
   import net.bigpoint.darkorbit.com.module.LevelModule;
   import net.bigpoint.darkorbit.com.module.LocationModule;
   import net.bigpoint.darkorbit.com.module.MemberLeaveCommand;
   import net.bigpoint.darkorbit.com.module.MemberLoggedOutModule;
   import net.bigpoint.darkorbit.com.module.PlayerAttributeModule;
   import net.bigpoint.darkorbit.com.module.RaidGateGameStageModule;
   import net.bigpoint.darkorbit.com.module.ShipIconModule;
   import net.bigpoint.darkorbit.com.module.TargetModule;
   import net.bigpoint.darkorbit.gui.InvitationClip;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.Group;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.GroupMember;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.Invitation;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.StubShip;
   import net.bigpoint.darkorbit.mvc.groupsystem.notification.GroupSystemNotification;
   import net.bigpoint.darkorbit.mvc.groupsystem.vo.InvitationUiVO;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class GroupProxy extends Proxy
   {
      
      private static const SEPARATOR:String = "/";
      
      public static const NAME:String = "GroupProxy";
      
      private var _pingMode:Boolean;
      
      private var _invitation:Dictionary = new Dictionary();
      
      public function GroupProxy(param1:Object = null)
      {
         super(NAME);
         setData(param1);
      }
      
      public static function log(param1:String) : void
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(param1));
      }
      
      public function get group() : net.bigpoint.darkorbit.mvc.groupsystem.model.Group
      {
         return data as net.bigpoint.darkorbit.mvc.groupsystem.model.Group;
      }
      
      public function isGroupMember(param1:int) : Boolean
      {
         return Boolean(this.group) && Boolean(this.group.members) && Boolean(this.group.getMemberByID(param1));
      }
      
      public function handleLeaderChange(param1:int) : void
      {
         var _loc2_:GroupMember = null;
         if(!this.isInGroup())
         {
            return;
         }
         for each(_loc2_ in this.group.members)
         {
            _loc2_.isLead = _loc2_.id == param1;
         }
         this.group.heroIsBoss = param1 == Hero.userID;
         sendNotification(GroupSystemNotification.UPDATE_UI,this.group);
      }
      
      public function handleInvitationBehaviourChange(param1:int) : void
      {
         if(this.group != null)
         {
            if(this.group.invitationBehavior != param1)
            {
               this.group.invitationBehavior = param1;
               sendNotification(GroupSystemNotification.UPDATE_UI,this.group);
            }
         }
      }
      
      public function isInGroup() : Boolean
      {
         if(this.group != null && this.group.members.length > 0)
         {
            return true;
         }
         return false;
      }
      
      public function onMemberLeft(param1:int, param2:int) : void
      {
         var _loc3_:GroupMember = null;
         var _loc4_:String = null;
         if(param1 != Hero.userID && Boolean(this.group))
         {
            _loc3_ = this.group.getMemberByID(param1);
            switch(param2)
            {
               case MemberLeaveCommand.LEAVEREASON_KICK:
                  _loc4_ = "msg_grp_leave_group_reason_kick";
                  break;
               case MemberLeaveCommand.LEAVEREASON_LEAVE:
                  _loc4_ = "msg_grp_leave_group_reason_leave";
                  break;
               case MemberLeaveCommand.LEAVEREASON_NONE:
                  _loc4_ = "msg_grp_leave_group_reason_none";
               default:
                  _loc4_ = "msg_grp_leave_group_reason_none";
            }
            if(_loc3_ != null)
            {
               log(BPLocale.getItem(_loc4_).replace(/%name%/,_loc3_.nickName));
            }
            this.removeMemberByID(param1);
            sendNotification(GroupSystemNotification.UPDATE_UI,this.group);
         }
         else
         {
            this.terminateGroup();
         }
      }
      
      public function terminateGroup(param1:Boolean = true) : void
      {
         var _loc2_:GroupMember = null;
         if(this.group)
         {
            for each(_loc2_ in this.group.members)
            {
               if(_loc2_.id != Hero.userID)
               {
                  this.group.removeMember(_loc2_.id);
                  sendNotification(GroupSystemNotification.CHANGE_SHIP_GROUP_STATE,_loc2_.id);
               }
            }
            if(param1)
            {
               sendNotification(GroupSystemNotification.TERMINATE_GROUP,this.group);
            }
         }
         setData(null);
         sendNotification(GroupSystemNotification.UPDATE_UI,this.group);
      }
      
      public function initGroup(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         this.terminateGroup(false);
         setData(new net.bigpoint.darkorbit.mvc.groupsystem.model.Group());
         this.group.init(param1,param2,param3,param4,param5);
         sendNotification(GroupSystemNotification.INIT_GROUP,this.group);
         sendNotification(GroupSystemNotification.UPDATE_UI,this.group);
      }
      
      public function addMember(param1:GroupMember) : void
      {
         this.group.addMember(param1);
         sendNotification(GroupSystemNotification.CHANGE_SHIP_GROUP_STATE,param1.id);
      }
      
      public function removeMemberByID(param1:int) : void
      {
         this.group.removeMember(param1);
         if(param1 != Hero.userID)
         {
            sendNotification(GroupSystemNotification.REMOVE_MEMBER_CLIP,param1);
         }
         this.group.removeMember(param1);
         sendNotification(GroupSystemNotification.CHANGE_SHIP_GROUP_STATE,param1);
      }
      
      public function updateMember(param1:int, param2:Vector.<PlayerAttributeModule>) : void
      {
         var _loc4_:PlayerAttributeModule = null;
         if(this.group == null)
         {
            return;
         }
         var _loc3_:GroupMember = this.group.getMemberByID(param1);
         if(_loc3_ == null)
         {
            return;
         }
         for each(_loc4_ in param2)
         {
            this.updateMemberProperty(_loc3_,_loc4_);
         }
         sendNotification(GroupSystemNotification.UPDATE_UI,this.group);
      }
      
      private function updateMemberProperty(param1:GroupMember, param2:PlayerAttributeModule) : void
      {
         switch(param2.getLibcomModuleId())
         {
            case ActivityModule.instance.getLibcomModuleId():
               param1.activity = (param2 as ActivityModule).active;
               break;
            case ClanModule.instance.getLibcomModuleId():
               param1.clanTag = (param2 as ClanModule).clanTag;
               break;
            case CloakDeviceActivityModule.instance.getLibcomModuleId():
               param1.isCloaked = (param2 as CloakDeviceActivityModule).active;
               break;
            case FactionModule.instance.getLibcomModuleId():
               param1.factionID = (param2 as FactionModule).faction;
               break;
            case FightActivityModule.instance.getLibcomModuleId():
               param1.fightState = (param2 as FightActivityModule).active;
               break;
            case HealthModule.instance.getLibcomModuleId():
               param1.memberObject.hitPointsCurrent = (param2 as HealthModule).hp;
               param1.memberObject.hitPointsMax = (param2 as HealthModule).hpMax;
               param1.memberObject.nanohullCurrent = (param2 as HealthModule).nanoHull;
               param1.memberObject.nanohullMax = (param2 as HealthModule).nanoHullMax;
               param1.memberObject.shieldCurrent = (param2 as HealthModule).shield;
               param1.memberObject.shieldMax = (param2 as HealthModule).shieldMax;
               break;
            case InvitationBlockModule.instance.getLibcomModuleId():
               break;
            case LevelModule.instance.getLibcomModuleId():
               param1.gameLevel = (param2 as LevelModule).level;
               break;
            case LocationModule.instance.getLibcomModuleId():
               param1.posX = (param2 as LocationModule).x;
               param1.posY = (param2 as LocationModule).y;
               param1.mapID = (param2 as LocationModule).mapId;
               break;
            case MemberLoggedOutModule.instance.getLibcomModuleId():
               param1.isOffline = (param2 as MemberLoggedOutModule).loggedOut;
               break;
            case ShipIconModule.instance.getLibcomModuleId():
               param1.memberObject.shipType = (param2 as ShipIconModule).shipIcon;
               break;
            case TargetModule.instance.getLibcomModuleId():
               param1.targetObject = new StubShip();
               param1.targetObject.nickname = (param2 as TargetModule).name;
               param1.targetObject.shipType = (param2 as TargetModule).shipType.shipIcon;
               param1.targetObject.hitPointsCurrent = (param2 as TargetModule).health.hp;
               param1.targetObject.hitPointsMax = (param2 as TargetModule).health.hpMax;
               param1.targetObject.shieldCurrent = (param2 as TargetModule).health.shield;
               param1.targetObject.shieldMax = (param2 as TargetModule).health.shieldMax;
               param1.targetObject.nanohullCurrent = (param2 as TargetModule).health.nanoHull;
               param1.targetObject.nanohullMax = (param2 as TargetModule).health.nanoHullMax;
               break;
            case RaidGateGameStageModule.instance.getLibcomModuleId():
               param1.raidGateStatus = (param2 as RaidGateGameStageModule).gameStage;
               param1.isInRaidGate = (param2 as RaidGateGameStageModule).isInGate;
         }
      }
      
      public function selectUser(param1:int, param2:String) : void
      {
         if(this.isInGroup())
         {
            this.group.selectGroupMember(param1);
            sendNotification(GroupSystemNotification.UPDATE_UI,this.group);
         }
         sendNotification(GroupSystemNotification.PREPARE_USER,param2);
      }
      
      public function handleInvitation(param1:Invitation) : void
      {
         var _loc2_:String = null;
         if(param1.getInviter().id != Hero.userID && param1.getCandidate().id != Hero.userID)
         {
            _loc2_ = BPLocale.getItem("msg_grp_inv_info_from_to").replace(/%inviter%/,param1.getInviter().nickName).replace(/%candidate%/,param1.getCandidate().nickName);
            log(_loc2_);
         }
         else if(Boolean(param1.getCandidate()) && Boolean(param1.getInviter()))
         {
            this.deleteInvitation(param1.getInviter().id,param1.getCandidate().id);
            this._invitation[this.getInvitationKey(param1.getCandidate().id,param1.getInviter().id)] = param1;
            sendNotification(GroupSystemNotification.ADD_INVITATION,param1);
            sendNotification(GroupSystemNotification.UPDATE_UI,this.group);
         }
      }
      
      private function getInvitationKey(param1:int, param2:int) : String
      {
         return param1.toString() + SEPARATOR + param2.toString();
      }
      
      public function deleteInvitation(param1:int, param2:int, param3:int = -1) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Boolean = false;
         var _loc11_:Invitation = null;
         var _loc6_:String = this.getInvitationKey(param2,param1);
         if(param1 == Hero.userID)
         {
            _loc4_ = param2;
            _loc5_ = InvitationClip.TYPE_OUTGOING;
         }
         else
         {
            _loc4_ = param1;
            _loc5_ = InvitationClip.TYPE_INCOMING;
         }
         if(param3 != -1)
         {
            _loc8_ = "%name%";
            _loc9_ = "";
            _loc10_ = true;
            _loc11_ = this._invitation[_loc6_];
            if(_loc11_)
            {
               switch(param3)
               {
                  case InvitationRemovalCommand.REASON_REVOKE:
                     _loc7_ = "msg_grp_inv_revoke_inviter";
                     if(_loc5_ == InvitationClip.TYPE_INCOMING)
                     {
                        _loc10_ = false;
                        _loc9_ = _loc11_.getInviter().nickName;
                     }
                     break;
                  case InvitationRemovalCommand.REASON_REJECT:
                     _loc7_ = "msg_grp_inv_invitation_rejected_candidate";
                     if(_loc5_ == InvitationClip.TYPE_OUTGOING)
                     {
                        _loc10_ = false;
                        _loc9_ = _loc11_.getCandidate().nickName;
                     }
                     break;
                  case InvitationRemovalCommand.REASON_TIMEOUT:
                     if(_loc5_ == InvitationClip.TYPE_OUTGOING)
                     {
                        _loc7_ = "msg_grp_inv_timeout_checked_inviter";
                        _loc8_ = "%invited%";
                        _loc9_ = _loc11_.getCandidate().nickName;
                        _loc10_ = false;
                        break;
                     }
                     if(_loc5_ == InvitationClip.TYPE_INCOMING)
                     {
                        _loc7_ = "msg_grp_inv_timeout_checked_candidate";
                        _loc8_ = "%inviter%";
                        _loc9_ = _loc11_.getInviter().nickName;
                        _loc10_ = false;
                     }
               }
            }
            if(!_loc10_)
            {
               log(BPLocale.getItem(_loc7_).replace(_loc8_,_loc9_));
            }
         }
         sendNotification(GroupSystemNotification.REMOVE_INVITATION_UI,new InvitationUiVO(_loc4_,_loc5_));
         sendNotification(GroupSystemNotification.UPDATE_UI,this.group);
         delete this._invitation[_loc6_];
      }
      
      public function get pingMode() : Boolean
      {
         return this._pingMode;
      }
      
      public function set pingMode(param1:Boolean) : void
      {
         this._pingMode = param1;
         sendNotification(GroupSystemNotification.UPDATE_UI_PING_MODE,this._pingMode);
      }
      
      public function cleanup() : void
      {
         setData(null);
      }
      
      public function deleteAllInvitations() : void
      {
         var _loc1_:Invitation = null;
         for each(_loc1_ in this._invitation)
         {
            this.deleteInvitation(_loc1_.getInviter().id,_loc1_.getCandidate().id);
         }
         this._invitation = new Dictionary();
      }
      
      public function relatedDataChanged() : void
      {
         sendNotification(GroupSystemNotification.RELATED_DATA_CHANGED);
      }
   }
}

