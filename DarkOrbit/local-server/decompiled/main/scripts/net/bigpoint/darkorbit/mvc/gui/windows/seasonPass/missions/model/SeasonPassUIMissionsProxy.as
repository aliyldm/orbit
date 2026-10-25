package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.model
{
   import net.bigpoint.darkorbit.com.module.SeasonPassMissionInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class SeasonPassUIMissionsProxy extends SimpleWindowProxy
   {
      
      public function SeasonPassUIMissionsProxy(param1:String)
      {
         super(param1,new SeasonPassUIMissionsData());
      }
      
      public function get viewData() : SeasonPassUIMissionsData
      {
         return data as SeasonPassUIMissionsData;
      }
      
      public function updateInfo(param1:SeasonPassMissionInfoCommand) : void
      {
         this.viewData.updateMissionInfo(param1);
      }
      
      public function updateQuestObjectives(param1:int, param2:Number, param3:Boolean, param4:Boolean) : void
      {
         this.viewData.updateMissionCondition(param1,param2,param3,param4);
      }
      
      public function completeMission(param1:int) : void
      {
         this.viewData.completeMission(param1);
      }
      
      public function updateGoldPassUnlockedStatus(param1:Boolean) : void
      {
         this.viewData.updateGoldPassStatus(param1);
      }
   }
}

