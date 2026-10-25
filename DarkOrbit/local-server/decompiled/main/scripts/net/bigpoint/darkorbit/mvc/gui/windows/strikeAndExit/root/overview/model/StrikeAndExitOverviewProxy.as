package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.overview.model
{
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class StrikeAndExitOverviewProxy extends SimpleWindowProxy
   {
      
      public function StrikeAndExitOverviewProxy(param1:String)
      {
         super(param1,new StrikeAndExitOverviewData());
      }
      
      public function get viewData() : StrikeAndExitOverviewData
      {
         return data as StrikeAndExitOverviewData;
      }
   }
}

