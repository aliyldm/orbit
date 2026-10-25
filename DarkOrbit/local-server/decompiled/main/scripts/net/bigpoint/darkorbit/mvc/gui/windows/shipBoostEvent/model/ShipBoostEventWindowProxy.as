package net.bigpoint.darkorbit.mvc.gui.windows.shipBoostEvent.model
{
   import net.bigpoint.darkorbit.com.module.ShipBoostEventBoostInfoCommand;
   import net.bigpoint.darkorbit.com.module.ShipBoostEventInfoCommand;
   import net.bigpoint.darkorbit.com.module.ShipBoostEventUpdateInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class ShipBoostEventWindowProxy extends SimpleWindowProxy
   {
      
      public function ShipBoostEventWindowProxy(param1:String)
      {
         super(param1,new ShipBoostEventUIData());
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      public function get viewData() : ShipBoostEventUIData
      {
         return data as ShipBoostEventUIData;
      }
      
      public function updateInfo(param1:ShipBoostEventInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateChange(param1:ShipBoostEventUpdateInfoCommand) : void
      {
         this.viewData.updateChange(param1);
      }
      
      public function updateBoost(param1:ShipBoostEventBoostInfoCommand) : void
      {
         this.viewData.updateBoost(param1);
      }
   }
}

