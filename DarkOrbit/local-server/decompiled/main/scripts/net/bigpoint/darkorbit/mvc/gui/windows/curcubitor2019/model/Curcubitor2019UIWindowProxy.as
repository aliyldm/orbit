package net.bigpoint.darkorbit.mvc.gui.windows.curcubitor2019.model
{
   import net.bigpoint.darkorbit.com.module.Curcubitor2019Command;
   import net.bigpoint.darkorbit.com.module.Curcubitor2019TimeUpdateCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class Curcubitor2019UIWindowProxy extends SimpleWindowProxy
   {
      
      public function Curcubitor2019UIWindowProxy(param1:String)
      {
         super(param1,new Curcubitor2019UIData());
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      public function get viewData() : Curcubitor2019UIData
      {
         return data as Curcubitor2019UIData;
      }
      
      public function updateInfo(param1:Curcubitor2019Command) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateTimer(param1:Curcubitor2019TimeUpdateCommand) : void
      {
         this.viewData.updateTimer(param1);
      }
   }
}

