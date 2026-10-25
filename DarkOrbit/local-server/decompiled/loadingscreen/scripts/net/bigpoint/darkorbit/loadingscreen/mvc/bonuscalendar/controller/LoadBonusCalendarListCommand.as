package net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.controller
{
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.model.BonusCalendarProxy;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class LoadBonusCalendarListCommand extends SimpleCommand implements ICommand
   {
      
      public function LoadBonusCalendarListCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:BonusCalendarProxy = facade.retrieveProxy(BonusCalendarProxy.NAME) as BonusCalendarProxy;
         _loc2_.loadBonusCalendarList();
      }
   }
}

