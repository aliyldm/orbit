package net.bigpoint.darkorbit.mvc.crafting.reroll.control
{
   import net.bigpoint.darkorbit.mvc.crafting.reroll.view.RerollWindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class ResetRerollPopupCommand extends SimpleCommand
   {
      
      public function ResetRerollPopupCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:RerollWindowMediator = facade.retrieveMediator(RerollWindowMediator.NAME) as RerollWindowMediator;
         if(_loc2_ != null)
         {
            _loc2_.handleCloseRerollPopup();
         }
      }
   }
}

