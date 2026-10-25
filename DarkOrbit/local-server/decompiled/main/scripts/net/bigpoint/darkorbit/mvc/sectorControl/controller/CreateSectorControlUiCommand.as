package net.bigpoint.darkorbit.mvc.sectorControl.controller
{
   import net.bigpoint.darkorbit.mvc.sectorControl.SectorControlNotifications;
   import net.bigpoint.darkorbit.mvc.sectorControl.view.SectorControlUiMediator;
   import net.bigpoint.darkorbit.mvc.sectorControl.view.components.SectorControlUi;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class CreateSectorControlUiCommand extends SimpleCommand implements ICommand
   {
      
      public function CreateSectorControlUiCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Boolean = this.createSectorControlUi();
         if(_loc2_)
         {
            this.removeThisCommand();
         }
      }
      
      private function removeThisCommand() : void
      {
         facade.removeCommand(SectorControlNotifications.INIT);
      }
      
      private function createSectorControlUi() : Boolean
      {
         var _loc1_:SectorControlUiMediator = null;
         var _loc2_:SectorControlUi = null;
         if(!facade.hasMediator(SectorControlUiMediator.NAME))
         {
            _loc2_ = new SectorControlUi();
            _loc1_ = new SectorControlUiMediator(_loc2_);
            facade.registerMediator(_loc1_);
            facade.registerCommand(SectorControlNotifications.UPDATE_FACTION_TICKETS_MODEL,UpdateSectorControlTicketsModelCommand);
            facade.registerCommand(SectorControlNotifications.UPDATE_FACTION_PLAYERS_MODEL,UpdateSectorControlPlayersModelCommand);
            facade.registerCommand(SectorControlNotifications.UPDATE_FACTION_CONTROL_POINT_BONUSSES_MODEL,UpdateSectorControlPointBonussesCommand);
            facade.registerCommand(SectorControlNotifications.RESET,SectorControlResetCommand);
            return false;
         }
         return true;
      }
   }
}

