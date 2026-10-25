package net.bigpoint.darkorbit.mvc.crafting.assembly.control
{
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CloseAssemblyExplanationWindowCommand extends DOAbstractSimpleCommand
   {
      
      public function CloseAssemblyExplanationWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:SimpleWindow = guiManager.getWindow(GuiConstants.ASSEMBLY_EXPLANATION_WINDOW);
         _loc2_.minimize(false);
      }
   }
}

