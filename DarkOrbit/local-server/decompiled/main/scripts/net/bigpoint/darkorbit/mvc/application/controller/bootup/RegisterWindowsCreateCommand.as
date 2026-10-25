package net.bigpoint.darkorbit.mvc.application.controller.bootup
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.booster.BoosterNotifications;
   import net.bigpoint.darkorbit.mvc.booster.control.InitBoosterSystemCommand;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyNotifications;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.control.CreateAssemblyExplanationWindowCommand;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.control.InitAssemblySystemCommand;
   import net.bigpoint.darkorbit.mvc.dominationWindow.DominationNotificationNames;
   import net.bigpoint.darkorbit.mvc.dominationWindow.controller.init.InitDominationWindowMVCActorsAsyncCommand;
   import net.bigpoint.darkorbit.mvc.influenceWindow.InfluenceWindowNotifications;
   import net.bigpoint.darkorbit.mvc.influenceWindow.control.InitInfluenceSystemCommand;
   import net.bigpoint.darkorbit.mvc.plagueWindow.PlagueWindowNotifications;
   import net.bigpoint.darkorbit.mvc.plagueWindow.control.InitPlagueSystemCommand;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.RZoneNotifications;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.controller.RZoneInitCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RegisterWindowsCreateCommand extends DOAbstractSimpleCommand
   {
      
      public function RegisterWindowsCreateCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         registerCommand(AssemblyNotifications.OPEN_EXPLANATION_WINDOW,CreateAssemblyExplanationWindowCommand);
         registerCommand(AssemblyNotifications.INIT,InitAssemblySystemCommand);
         registerCommand(BoosterNotifications.CREATE,InitBoosterSystemCommand);
         registerCommand(RZoneNotifications.INIT,RZoneInitCommand);
         registerCommand(InfluenceWindowNotifications.INIT,InitInfluenceSystemCommand);
         registerCommand(PlagueWindowNotifications.INIT,InitPlagueSystemCommand);
         registerCommand(DominationNotificationNames.INIT,InitDominationWindowMVCActorsAsyncCommand);
      }
   }
}

