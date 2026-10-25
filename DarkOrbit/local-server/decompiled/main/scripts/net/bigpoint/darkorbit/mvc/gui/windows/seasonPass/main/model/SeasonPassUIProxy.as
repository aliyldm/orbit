package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.main.model
{
   import net.bigpoint.darkorbit.com.module.SeasonPassStatusCommand;
   import net.bigpoint.darkorbit.com.module.SeasonPointsInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class SeasonPassUIProxy extends SimpleWindowProxy
   {
      
      public function SeasonPassUIProxy(param1:String)
      {
         super(param1,new SeasonPassUIData());
      }
      
      public function get viewData() : SeasonPassUIData
      {
         return data as SeasonPassUIData;
      }
      
      public function updatePoints(param1:SeasonPointsInfoCommand) : void
      {
         this.viewData.updatePoints(param1);
      }
      
      public function updateStatus(param1:SeasonPassStatusCommand) : void
      {
         this.viewData.updateStatus(param1);
      }
   }
}

