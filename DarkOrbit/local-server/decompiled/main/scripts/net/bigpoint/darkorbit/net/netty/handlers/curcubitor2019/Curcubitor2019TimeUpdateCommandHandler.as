package net.bigpoint.darkorbit.net.netty.handlers.curcubitor2019
{
   import net.bigpoint.darkorbit.com.module.Curcubitor2019TimeUpdateCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.curcubitor2019.model.Curcubitor2019UIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class Curcubitor2019TimeUpdateCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function Curcubitor2019TimeUpdateCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:Curcubitor2019UIWindowProxy = retrieveProxy(GuiConstants.CURCUBITOR_2019) as Curcubitor2019UIWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.CURCUBITOR_2019);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.CURCUBITOR_2019) as Curcubitor2019UIWindowProxy;
         }
         var _loc3_:Curcubitor2019TimeUpdateCommand = param1.getBody() as Curcubitor2019TimeUpdateCommand;
         _loc2_.updateTimer(_loc3_);
      }
   }
}

