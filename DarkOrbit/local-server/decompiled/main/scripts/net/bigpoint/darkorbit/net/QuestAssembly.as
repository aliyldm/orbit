package net.bigpoint.darkorbit.net
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.com.module.QuestDefinitionModule;
   
   public class QuestAssembly
   {
      
      private var delegateDict:Dictionary;
      
      private var main:Main;
      
      public function QuestAssembly()
      {
         super();
         this.initDelegateDict();
      }
      
      private static function hidden() : void
      {
      }
      
      private function initDelegateDict() : void
      {
         this.delegateDict = new Dictionary();
         this.delegateDict[ServerCommands.QUESTFM_INIT] = this.assembleQuestInit;
         this.delegateDict[ServerCommands.QUESTFM_UPDATE] = this.assembleQuestUpdate;
         this.delegateDict[ServerCommands.QUESTFM_PRIVILEGE_QUEST] = this.assemblePrivilegedQuest;
         this.delegateDict[ServerCommands.QUESTFM_ACCOMPLISH_QUEST] = this.assembleQuestAccomplished;
         this.delegateDict[ServerCommands.QUESTFM_CANCEL_QUEST] = this.assembleQuestCancelled;
         this.delegateDict[ServerCommands.QUESTFM_FAIL_QUEST] = this.assembleQuestFailed;
      }
      
      public function assembleQuestFailed(param1:int) : void
      {
         this.main.getQuestManager().setQuestFailed(param1);
      }
      
      public function assembleQuestCancelled(param1:int) : void
      {
         this.main.getQuestManager().setQuestCancelled(param1);
      }
      
      public function assembleQuestAccomplished(param1:int) : void
      {
         this.main.getQuestManager().setQuestAccomplished(param1);
      }
      
      public function assemblePrivilegedQuest(param1:int) : void
      {
         this.main.getQuestManager().privilegeQuestByID(param1);
      }
      
      public function assembleQuestUpdate(param1:int, param2:int, param3:Number, param4:Boolean, param5:Boolean) : void
      {
         this.main.getQuestManager().updateCondition(param1,param2,param3,param5,param4);
      }
      
      private function assembleQuestInit(param1:Array) : void
      {
         var _loc2_:String = null;
         _loc2_ = param1[3];
      }
      
      public function assembleQuestInitialization(param1:QuestDefinitionModule) : void
      {
         this.main.getQuestManager().initQuestNetty(param1);
      }
      
      public function assembleCommand(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         if(this.delegateDict[_loc2_] != null)
         {
            this.delegateDict[_loc2_](param1);
         }
      }
      
      public function setMain(param1:Main) : void
      {
         if(this.main == null)
         {
            this.main = param1;
         }
      }
   }
}

