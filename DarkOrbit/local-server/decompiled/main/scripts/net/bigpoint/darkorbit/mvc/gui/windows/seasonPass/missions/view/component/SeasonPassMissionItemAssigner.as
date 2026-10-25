package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.view.component
{
   import com.bigpoint.utils.TextFormatter;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.SeasonPassMissionStatusModule;
   import net.bigpoint.darkorbit.com.module.liveops.seasonpass.SeasonPassRefreshRequest;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.fui.system.utils.FuiPopUpUtils;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.model.vo.SeasonPassMissionVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.view.SeasonPassUIMissionsMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.refreshMissions.SeasonPassRefreshConfirmMediator;
   import net.bigpoint.darkorbit.mvc.questWindow.model.vo.RewardVO;
   import net.bigpoint.darkorbit.questfm.Case;
   import net.bigpoint.darkorbit.questfm.conditions.Condition;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class SeasonPassMissionItemAssigner extends DefaultItemDataAssigner
   {
      
      public const missionChanged:ISignal = new Signal();
      
      private var _bg:Coreponent;
      
      private var _check:Coreponent;
      
      private var _missionConditions:Label;
      
      private var _missionProgress:Label;
      
      private var _btnLocked:Button;
      
      private var _icon:Coreponent;
      
      private var _iconCompleted:Coreponent;
      
      private var _points:Label;
      
      private var _completeLocale:String;
      
      private var _tooltipLocale:String;
      
      public var _refresh:Button;
      
      public function SeasonPassMissionItemAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
         this._check = FuiComponentSelectorUtil.selectComponent("check",this) as Coreponent;
         this._missionConditions = FuiComponentSelectorUtil.selectComponent("objective",this) as Label;
         this._missionProgress = FuiComponentSelectorUtil.selectComponent("progress",this) as Label;
         this._btnLocked = FuiComponentSelectorUtil.selectComponent("btn_locked",this) as Button;
         this._icon = FuiComponentSelectorUtil.selectComponent("icon",this) as Coreponent;
         this._iconCompleted = FuiComponentSelectorUtil.selectComponent("icon_completed",this) as Coreponent;
         this._points = FuiComponentSelectorUtil.selectComponent("points",this) as Label;
         this._refresh = FuiComponentSelectorUtil.selectComponent("btn_refresh",this) as Button;
         this._completeLocale = BPLocale.getItem("label_quest_completed");
         this._tooltipLocale = BPLocale.getItem("ttip_sp_error_hover-gp-item");
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc3_:RewardVO = null;
         var _loc2_:SeasonPassMissionVO = param1 as SeasonPassMissionVO;
         if(!_loc2_)
         {
            visible = false;
            return;
         }
         this.removeListeners();
         super.data = param1;
         this.addListeners();
         visible = true;
         for each(_loc3_ in this.VO.quest.rewards)
         {
            if(_loc3_.lootId.indexOf("resource_season-pass-point") == 0)
            {
               this._points.text = TextFormatter.roundInteger(_loc3_.amount);
            }
         }
         this.updateMissionProgress();
      }
      
      private function addListeners() : void
      {
         if(this.VO)
         {
            this.VO.missionChanged.add(this.updateMissionProgress);
         }
      }
      
      private function removeListeners() : void
      {
         if(this.VO)
         {
            this.VO.missionChanged.remove(this.updateMissionProgress);
         }
      }
      
      public function get VO() : SeasonPassMissionVO
      {
         return data as SeasonPassMissionVO;
      }
      
      private function setLabel() : *
      {
         var _loc4_:String = null;
         var _loc5_:net.bigpoint.darkorbit.questfm.conditions.Condition = null;
         var _loc6_:String = null;
         var _loc7_:net.bigpoint.darkorbit.questfm.conditions.Condition = null;
         if(!this.VO)
         {
            return;
         }
         this._missionConditions.text = "";
         this._missionProgress.text = "";
         var _loc1_:Case = this.VO.quest.getCase();
         var _loc2_:Boolean = false;
         if(_loc1_.mandatory && _loc1_.mandatory_count < _loc1_.mandatory_child_count)
         {
            _loc4_ = BPLocale.getItem("q2_condition_CASE_mandatory");
            _loc4_ = _loc4_.replace(/%count%/,_loc1_.mandatory_count);
            this._missionConditions.text += _loc4_ + "\n";
            this._missionProgress.text = "\n";
            _loc2_ = true;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.VO.quest.getCase().conditions.length)
         {
            _loc5_ = net.bigpoint.darkorbit.questfm.conditions.Condition(this.VO.quest.getCase().conditions[_loc3_]);
            _loc6_ = _loc5_.description;
            this._missionConditions.text += (_loc2_ ? "• " : "") + _loc6_ + "\n";
            if(_loc5_.conditions)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc5_.conditions.length)
               {
                  _loc7_ = _loc5_.conditions[_loc3_];
                  _loc6_ = _loc7_.description;
                  this._missionConditions.text += "  - " + _loc6_ + "\n";
                  _loc3_++;
               }
            }
            this._missionProgress.text += "(" + _loc5_.currentVerbose + _loc5_.targetVerbose + ")\n";
            _loc3_++;
         }
      }
      
      private function setState() : *
      {
         if(!this.VO)
         {
            return;
         }
         switch(this.VO.missionStatus.type)
         {
            case SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_NORMAL_RUNNING:
               this._bg.registeredSkinName = "season_pass_mission_state_free";
               this._bg.setSkinState("incomplete");
               this._check.visible = false;
               this._btnLocked.visible = false;
               this._btnLocked.mouseEnabled = false;
               _tooltipData = null;
               this._icon.visible = true;
               this._iconCompleted.visible = false;
               this._missionConditions.registeredTextStyleName = "season_pass_mission_objective_info";
               this._missionProgress.registeredTextStyleName = "season_pass_mission_objective_info";
               this._points.registeredTextStyleName = "season_pass_mission_objective_info";
               this._refresh.visible = true;
               break;
            case SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_NORMAL_COMPLETED:
               this._bg.registeredSkinName = "season_pass_mission_state_free";
               this._bg.setSkinState("completed");
               this._check.visible = true;
               this._check.setSkinState("dark");
               this._btnLocked.visible = false;
               this._btnLocked.mouseEnabled = false;
               _tooltipData = null;
               this._icon.visible = false;
               this._iconCompleted.visible = true;
               this._missionConditions.registeredTextStyleName = "season_pass_mission_objective_info_completed";
               this._missionProgress.registeredTextStyleName = "season_pass_mission_objective_info_completed";
               this._points.registeredTextStyleName = "season_pass_mission_objective_info_completed";
               this._missionProgress.text = this._completeLocale;
               this._refresh.visible = false;
               break;
            case SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_GOLD_LOCKED_INCOMPLETE:
               this._bg.registeredSkinName = "season_pass_mission_state_gold";
               this._bg.setSkinState("incomplete");
               this._check.visible = false;
               this._btnLocked.visible = true;
               this._btnLocked.mouseEnabled = true;
               _tooltipData = this._tooltipLocale;
               this._icon.visible = false;
               this._iconCompleted.visible = false;
               this._missionConditions.registeredTextStyleName = "season_pass_mission_objective_info";
               this._missionProgress.registeredTextStyleName = "season_pass_mission_objective_info";
               this._points.registeredTextStyleName = "season_pass_mission_objective_info";
               this._refresh.visible = false;
               break;
            case SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_GOLD_LOCKED_COMPLETE:
               this._bg.registeredSkinName = "season_pass_mission_state_gold";
               this._bg.setSkinState("locked");
               this._check.visible = true;
               this._check.setSkinState("normal");
               this._btnLocked.visible = true;
               this._btnLocked.mouseEnabled = true;
               _tooltipData = this._tooltipLocale;
               this._icon.visible = false;
               this._iconCompleted.visible = false;
               this._missionConditions.registeredTextStyleName = "season_pass_mission_objective_info";
               this._missionProgress.registeredTextStyleName = "season_pass_mission_objective_info";
               this._points.registeredTextStyleName = "season_pass_mission_objective_info";
               this._missionProgress.text = this._completeLocale;
               this._refresh.visible = false;
               break;
            case SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_GOLD_RUNNING:
               this._bg.registeredSkinName = "season_pass_mission_state_gold";
               this._bg.setSkinState("incomplete");
               this._check.visible = false;
               this._btnLocked.visible = false;
               this._btnLocked.mouseEnabled = false;
               _tooltipData = null;
               this._icon.visible = true;
               this._iconCompleted.visible = false;
               this._missionConditions.registeredTextStyleName = "season_pass_mission_objective_info";
               this._missionProgress.registeredTextStyleName = "season_pass_mission_objective_info";
               this._points.registeredTextStyleName = "season_pass_mission_objective_info";
               this._refresh.visible = true;
               break;
            case SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_GOLD_COMPLETED:
               this._bg.registeredSkinName = "season_pass_mission_state_gold";
               this._bg.setSkinState("unlocked");
               this._check.visible = true;
               this._check.setSkinState("dark");
               this._btnLocked.visible = false;
               this._btnLocked.mouseEnabled = false;
               _tooltipData = null;
               this._icon.visible = false;
               this._iconCompleted.visible = true;
               this._missionConditions.registeredTextStyleName = "season_pass_mission_objective_info_completed";
               this._missionProgress.registeredTextStyleName = "season_pass_mission_objective_info_completed";
               this._points.registeredTextStyleName = "season_pass_mission_objective_info_completed";
               this._missionProgress.text = this._completeLocale;
               this._refresh.visible = false;
         }
         if(this.VO.oncePreMission)
         {
            this._refresh.visible = false;
         }
         if(this._refresh.visible)
         {
            this._refresh.addEventListener(MouseEvent.CLICK,this.onRefreshMission);
            this._refresh.mouseEnabled = true;
         }
         else
         {
            this._refresh.mouseEnabled = false;
            this._refresh.removeEventListener(MouseEvent.CLICK,this.onRefreshMission);
         }
      }
      
      private function onRefreshMission(param1:MouseEvent) : *
      {
         var uiname:String = null;
         var mediator:SeasonPassRefreshConfirmMediator = null;
         var vo:SimpleWindowCreationVO = null;
         var handleOk:Function = null;
         var confirmPrompt:String = null;
         var costPrompt:String = null;
         var prompt:String = null;
         var event:MouseEvent = param1;
         var seasonMissionMediator:SeasonPassUIMissionsMediator = GameFacade.getInstance().retrieveMediator(GuiConstants.SEASON_PASS_MISSIONS) as SeasonPassUIMissionsMediator;
         var freeChance:Boolean = seasonMissionMediator.data.CurUsedCount > 0;
         if(freeChance)
         {
            uiname = GuiConstants.SEASON_PASS_POPUP_CONFIRM_REFRESH;
            if(GuiManager.instance.getWindow(uiname))
            {
               mediator = GameFacade.getInstance().retrieveMediator(uiname) as SeasonPassRefreshConfirmMediator;
               mediator.data = this.data as SeasonPassMissionVO;
               GameFacade.getInstance().sendNotification(GuiNotifications.MAXIMIZE_WINDOW_BY_ID,uiname);
            }
            else
            {
               vo = SimpleWindowCreationMap.getById(GuiConstants.SEASON_PASS_POPUP_CONFIRM_REFRESH);
               GameFacade.getInstance().sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,vo);
               mediator = GameFacade.getInstance().retrieveMediator(uiname) as SeasonPassRefreshConfirmMediator;
               mediator.data = this.data as SeasonPassMissionVO;
            }
         }
         else
         {
            handleOk = function():void
            {
               var _loc1_:SeasonPassRefreshRequest = new SeasonPassRefreshRequest(SeasonPassRefreshRequest.COSTTYPE_URIDIUM,VO.quest.id);
               GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc1_);
            };
            confirmPrompt = BPLocale.getItem("window_mission_upgrade_confirm_hint");
            costPrompt = BPLocale.getItem("window_mission_upgrade_confirm_uridium_cost");
            if(!seasonMissionMediator.view.btnDaily.isEnabled())
            {
               costPrompt = costPrompt.replace("%VALUE%",seasonMissionMediator.data.dailyUridiumCost);
            }
            else if(!seasonMissionMediator.view.btnWeekly.isEnabled())
            {
               costPrompt = costPrompt.replace("%VALUE%",seasonMissionMediator.data.weeklyUridiumCost);
            }
            prompt = confirmPrompt + "\n" + costPrompt;
            FuiPopUpUtils.createPopupLoadSkin(GuiConstants.POPUP_GENERIC_ICON,handleOk,null,prompt,FuiPopUpUtils.POPUP_ICON_SKIN_QUESTION);
         }
      }
      
      private function updateMissionProgress() : void
      {
         if(!this.VO)
         {
            return;
         }
         this.setLabel();
         this.setState();
      }
   }
}

