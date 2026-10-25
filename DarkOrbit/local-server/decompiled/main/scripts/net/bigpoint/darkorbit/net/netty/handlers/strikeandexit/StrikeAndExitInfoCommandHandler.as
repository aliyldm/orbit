package net.bigpoint.darkorbit.net.netty.handlers.strikeandexit
{
   import net.bigpoint.darkorbit.com.module.porting.strikeandexit.StrikeAndExitInfoCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.overview.model.StrikeAndExitOverviewProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class StrikeAndExitInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function StrikeAndExitInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:StrikeAndExitInfoCommand = param1.getBody() as StrikeAndExitInfoCommand;
         var _loc3_:StrikeAndExitOverviewProxy = retrieveProxy(GuiConstants.STRIKE_AND_EXIT_OVERVIEW) as StrikeAndExitOverviewProxy;
         if(_loc3_)
         {
            _loc3_.viewData.updateData(_loc2_.inSession,_loc2_.nextOpenSeconds,_loc2_.StellarCoinLimit,_loc2_.currentGetStellarCoin,_loc2_.inDouble);
         }
      }
   }
}

