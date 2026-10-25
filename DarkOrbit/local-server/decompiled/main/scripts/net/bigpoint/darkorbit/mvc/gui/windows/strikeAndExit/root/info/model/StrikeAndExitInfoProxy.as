package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.info.model
{
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class StrikeAndExitInfoProxy extends SimpleWindowProxy
   {
      
      public function StrikeAndExitInfoProxy(param1:String)
      {
         super(param1,new StrikeAndExitInfoData());
      }
      
      public function get viewData() : StrikeAndExitInfoData
      {
         return data as StrikeAndExitInfoData;
      }
   }
}

