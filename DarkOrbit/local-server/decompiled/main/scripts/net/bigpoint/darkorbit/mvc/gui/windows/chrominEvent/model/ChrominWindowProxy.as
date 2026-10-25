package net.bigpoint.darkorbit.mvc.gui.windows.chrominEvent.model
{
   import net.bigpoint.darkorbit.com.module.ChrominUpdateCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class ChrominWindowProxy extends SimpleWindowProxy
   {
      
      public function ChrominWindowProxy(param1:String)
      {
         super(param1,new ChrominUIData());
      }
      
      public function get viewData() : ChrominUIData
      {
         return data as ChrominUIData;
      }
      
      public function updateInfo(param1:ChrominUpdateCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
   }
}

