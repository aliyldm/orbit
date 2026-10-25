package net.bigpoint.darkorbit.managers
{
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.QuestCancelRequest;
   import net.bigpoint.darkorbit.com.module.QuestDefinitionModule;
   import net.bigpoint.darkorbit.com.module.QuestPrivilegeRequest;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.ButtonElementTypes;
   import net.bigpoint.darkorbit.gui.events.QuestTabEvent;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindowPopup.PopupOptionVO;
   import net.bigpoint.darkorbit.gui.windows.simpleWindowPopup.SimpleWindowInternalPopup;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.mvc.questWindow.QuestGiverWindowNotification;
   import net.bigpoint.darkorbit.mvc.questWindow.model.QuestProxy;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.questfm.ICondition;
   import net.bigpoint.darkorbit.questfm.Quest;
   import net.bigpoint.darkorbit.questfm.QuestParser;
   import net.bigpoint.darkorbit.questfm.QuestStock;
   import net.bigpoint.darkorbit.questfm.QuestTreeContainer;
   import net.bigpoint.darkorbit.questfm.rewardsList.QuestRewardsListContainer;
   
   public class QuestManager
   {
      
      public static const QUESTFM_INI_FMT_XML:String = "XML";
      
      public static const QUESTFM_INI_FMT_HOMEBREW:String = "DOHB";
      
      private var _questStock:QuestStock;
      
      private var _privilegedQuest:Quest;
      
      private var main:Main;
      
      private var parser:QuestParser;
      
      public var iniFormat:String = "DOHB";
      
      public function QuestManager(param1:Main)
      {
         super();
         this.main = param1;
         this._questStock = new QuestStock();
         this.parser = QuestParser.instance;
      }
      
      public static function log(param1:String) : void
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(param1));
      }
      
      private function handleCancelButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:SimpleWindow = this.main.getGuiManager().getQuestWindow();
         var _loc3_:Vector.<PopupOptionVO> = new <PopupOptionVO>[new PopupOptionVO(-1,"btn_ok",this.cancelQuestCallback,[param1.target],"",200),new PopupOptionVO(-1,"btn_cancel")];
         _loc2_.shopPopup(BPLocale.getItem("quest_cancel_popup_title"),BPLocale.getItem("quest_cancel_popup_message"),_loc3_);
      }
      
      private function cancelQuestCallback(param1:Array) : void
      {
         var _loc2_:ButtonElement = param1[0] as ButtonElement;
         if(_loc2_)
         {
            _loc2_.removeEventListener(MouseEvent.CLICK,this.handleCancelButtonClicked);
            _loc2_.setDisableStatus();
         }
         var _loc3_:QuestCancelRequest = new QuestCancelRequest();
         if(this._privilegedQuest != null)
         {
            _loc3_.questId = this._privilegedQuest.id;
            this.main.getConnectionManager().sendRequest(_loc3_);
         }
      }
      
      public function setQuestAccomplished(param1:int) : void
      {
         var _loc2_:Quest = this._questStock.getQuestByID(param1);
         if(_loc2_ != null)
         {
            AudioManager.playSoundEffect(QuestProxy.QUEST_FINSIHED_SOUND);
            log(BPLocale.getItem("q2_accomplished_quest").replace(/%quest_name%/,_loc2_.title));
            JavascriptProxy.call(JavascriptProxy.FUNCTION_CLIENT_EVENT,[JavascriptProxy.QUEST_ACCOMPLISHED]);
            this.removeQuest(param1);
            GameFacade.getInstance().forwardNotification(QuestGiverWindowNotification.QUEST_ACCOMPLISED,[param1,_loc2_.getCase().id]);
         }
      }
      
      public function setQuestFailed(param1:int) : void
      {
         var _loc2_:Quest = this._questStock.getQuestByID(param1);
         var _loc3_:SimpleWindow = this.main.getGuiManager().getQuestWindow();
         SimpleWindowInternalPopup(_loc3_.internalPopupContainer.getChildAt(0)).hide(false);
         if(_loc2_ != null)
         {
            AudioManager.playSoundEffect(QuestProxy.QUEST_FAILED_SOUND);
            log(BPLocale.getItem("q2_failed_quest").replace(/%quest_name%/,_loc2_.title));
            this.removeQuest(param1);
         }
      }
      
      public function setQuestCancelled(param1:int) : void
      {
         var _loc2_:Quest = this._questStock.getQuestByID(param1);
         if(_loc2_ != null)
         {
            log(BPLocale.getItem("q2_cancelled_quest").replace(/%quest_name%/,_loc2_.title));
            this.removeQuest(param1);
         }
      }
      
      private function removeQuest(param1:int) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:QuestPrivilegeRequest = null;
         var _loc8_:QuestRewardsListContainer = null;
         var _loc2_:Quest = this._questStock.getQuestByID(param1);
         GameFacade.getInstance().forwardNotification(QuestGiverWindowNotification.SET_QUEST_INACTIVE,_loc2_.getCase().id);
         if(_loc2_ != null)
         {
            _loc5_ = false;
            if(this._privilegedQuest == null || this._privilegedQuest.id == param1)
            {
               _loc5_ = true;
               this._privilegedQuest = null;
            }
            _loc2_.running = false;
            this.resetQuest(_loc2_);
            this._questStock.deleteQuestByID(param1);
            --this._questStock.runningQuests;
            if(_loc5_)
            {
               this.main.getGuiManager().clearQuestWindow();
               this.main.getGuiManager().clearRewardsListWindow();
               _loc6_ = this._questStock.getNextQuestID();
               if(_loc6_ >= 0)
               {
                  _loc7_ = new QuestPrivilegeRequest();
                  _loc7_.questId = _loc6_;
                  this.main.getConnectionManager().sendRequest(_loc7_);
               }
            }
            _loc2_.notifyConditionsOfQuestsRunstate(false);
            this.main.getGuiManager().removeQuestDot(param1);
         }
         var _loc3_:int = this._questStock.runningQuests;
         var _loc4_:SimpleWindow = this.main.getGuiManager().getWindow(GuiConstants.QUEST_WINDOW);
         if(_loc3_ == 0)
         {
            if(_loc4_ != null)
            {
               QuestTreeContainer(_loc4_.getContainer(SimpleContainer.CLASS_QUEST_TREE)).isDefaultVisible = true;
               _loc8_ = QuestRewardsListContainer(_loc4_.getContainer(SimpleContainer.CLASS_QUEST_REWARDS));
               _loc8_.isDefaultVisible = true;
               _loc8_.dispatchEvent(new QuestTabEvent(QuestTabEvent.UNSELECT_TAB,ButtonElementTypes.TYPE_QUEST_TAB_OVERVIEW,true));
            }
         }
         else if(_loc4_ != null)
         {
            QuestTreeContainer(_loc4_.getContainer(SimpleContainer.CLASS_QUEST_TREE)).isDefaultVisible = false;
         }
      }
      
      private function resetQuest(param1:Quest) : void
      {
         var _loc3_:ICondition = null;
         var _loc2_:Array = param1.flatConditions;
         for each(_loc3_ in _loc2_)
         {
            _loc3_.completed = _loc3_.runstate = false;
            _loc3_.current = 0;
         }
      }
      
      public function initQuest(param1:String, param2:String) : void
      {
      }
      
      public function initQuestNetty(param1:QuestDefinitionModule) : void
      {
         var _loc2_:Quest = this.parser.parseDefinition(param1);
         _loc2_.running = true;
         this.setQuest(_loc2_,_loc2_.id);
         if(this._privilegedQuest == null)
         {
            this.privilegeQuestByID(_loc2_.id);
         }
         GameFacade.getInstance().forwardNotification(QuestGiverWindowNotification.SET_QUEST_ACTIVE,_loc2_);
         var _loc3_:Boolean = this.main.getGuiManager().addQuestDot(_loc2_.id);
         if(_loc3_)
         {
            ++this.questStock.runningQuests;
         }
         if(_loc2_.id == this._privilegedQuest.id)
         {
            this.main.getGuiManager().updateQuestTitle();
         }
      }
      
      public function setQuest(param1:Quest, param2:int) : void
      {
         param1.notifyConditionsOfQuestsRunstate(true);
         this._questStock.addQuest(param1,param2);
      }
      
      public function getQuest(param1:int) : Quest
      {
         return this._questStock.getQuestByID(param1);
      }
      
      public function get privilegedQuest() : Quest
      {
         return this._privilegedQuest;
      }
      
      public function privilegeQuestByID(param1:int) : void
      {
         var _loc3_:SimpleWindow = null;
         var _loc4_:SimpleContainer = null;
         var _loc5_:ButtonElement = null;
         var _loc2_:Quest = this._questStock.getQuestByID(param1);
         if(_loc2_ != null && this._privilegedQuest != _loc2_)
         {
            this._privilegedQuest = _loc2_;
            this.main.getGuiManager().updateQuestWindow();
            this.main.getGuiManager().updateQuestDotList();
            _loc3_ = this.main.getGuiManager().getQuestWindow();
            _loc4_ = _loc3_.getContainer(SimpleContainer.CLASS_QUEST_BUTTONS);
            for each(_loc5_ in _loc4_.getAllElements())
            {
               if(_loc5_.getType() == ButtonElementTypes.TYPE_CANCEL_QUEST)
               {
                  _loc5_.addEventListener(MouseEvent.CLICK,this.handleCancelButtonClicked);
                  _loc5_.setEnableStatus();
               }
            }
         }
      }
      
      public function updateQuest(param1:int, param2:int, param3:int, param4:Boolean, param5:Boolean) : void
      {
         var _loc6_:Quest = null;
         if(this._questStock != null)
         {
            _loc6_ = this._questStock.getQuestByID(param1);
            if(_loc6_ != null)
            {
               _loc6_.updateCondition(param2,param3,param4,param5);
            }
         }
      }
      
      public function updateCondition(param1:int, param2:int, param3:Number, param4:Boolean, param5:Boolean, param6:Boolean = false) : void
      {
         var _loc9_:int = 0;
         var _loc10_:ICondition = null;
         if(this._questStock == null)
         {
            return;
         }
         var _loc7_:Quest = this._questStock.getQuestByID(param1);
         if(_loc7_ == null)
         {
            this.main.getConnectionManager().sendCommand(ServerCommands.QUESTFM_INFO,["g"]);
            return;
         }
         if(_loc7_.flatConditions[param2] == null)
         {
            return;
         }
         var _loc8_:ICondition = ICondition(_loc7_.flatConditions[param2]);
         if(_loc8_ != null)
         {
            _loc8_.current = param3;
            _loc8_.runstate = param5;
            if(!_loc8_.completed && param4)
            {
               AudioManager.playSoundEffect(QuestProxy.QUEST_SUBQUEST_FINISHED_SOUND);
            }
            _loc8_.completed = param4;
            if(_loc8_.children.length > 0)
            {
               _loc9_ = 0;
               while(_loc9_ < _loc8_.children.length)
               {
                  _loc10_ = _loc8_.children[_loc9_] as ICondition;
                  _loc10_.runstate = param5;
                  _loc10_.completed = param4;
                  _loc9_++;
               }
            }
         }
         if(this._privilegedQuest != null && param1 == this._privilegedQuest.id)
         {
            this.main.getGuiManager().updateQuestConditionInWindow(param2,param6);
         }
      }
      
      public function get questStock() : QuestStock
      {
         return this._questStock;
      }
      
      public function getQuestIDByConditionID(param1:int) : int
      {
         return this._questStock.getQuestIDByConditionID(param1);
      }
   }
}

