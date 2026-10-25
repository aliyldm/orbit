package net.bigpoint.darkorbit.net.netty.handlers.birthdaygate2025
{
   import net.bigpoint.darkorbit.com.module.porting.birthday2025.Birthday2025PointRewardCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.model.BirthdayGate2025Proxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class Birthday2025PointRewardCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function Birthday2025PointRewardCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Birthday2025PointRewardCommand = param1.getBody() as Birthday2025PointRewardCommand;
         var _loc3_:BirthdayGate2025Proxy = BirthdayGate2025Proxy.getProxy(this.facade);
         _loc3_.rcvViewData(_loc2_);
      }
   }
}

