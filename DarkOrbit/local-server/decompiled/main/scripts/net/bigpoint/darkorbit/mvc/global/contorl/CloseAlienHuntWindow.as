package net.bigpoint.darkorbit.mvc.global.contorl
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CloseAlienHuntWindow extends DOAbstractSimpleCommand
   {
      
      public function CloseAlienHuntWindow()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         if(!param1.getBody())
         {
            sendNotification(GuiNotifications.DESTROY_SIMPLE_WINDOW,GuiConstants.ALIEN_HUNT_WINDOW);
         }
      }
   }
}

