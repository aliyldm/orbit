package net.bigpoint.darkorbit.mvc.gui.windows.uridiumbank.model
{
   import net.bigpoint.darkorbit.com.module.UridiumBankInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class UridiumBankWindowProxy extends SimpleWindowProxy
   {
      
      public function UridiumBankWindowProxy(param1:String)
      {
         super(param1,new UridiumBankUIData());
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      public function get viewData() : UridiumBankUIData
      {
         return data as UridiumBankUIData;
      }
      
      public function updateInfo(param1:UridiumBankInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
   }
}

