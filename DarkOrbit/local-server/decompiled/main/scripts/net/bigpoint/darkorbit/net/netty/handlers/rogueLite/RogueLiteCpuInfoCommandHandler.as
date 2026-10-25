package net.bigpoint.darkorbit.net.netty.handlers.rogueLite
{
   import net.bigpoint.darkorbit.com.module.RogueLiteCpuInfoCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.RogueLiteUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RogueLiteCpuInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function RogueLiteCpuInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:RogueLiteUIWindowProxy = retrieveProxy(GuiConstants.ROGUE_LITE) as RogueLiteUIWindowProxy;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:RogueLiteCpuInfoCommand = param1.getBody() as RogueLiteCpuInfoCommand;
         _loc2_.updateKeyCount(_loc3_);
      }
   }
}

