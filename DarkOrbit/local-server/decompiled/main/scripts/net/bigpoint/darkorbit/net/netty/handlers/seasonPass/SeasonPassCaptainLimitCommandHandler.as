package net.bigpoint.darkorbit.net.netty.handlers.seasonPass
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.system.utils.FuiPopUpUtils;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SeasonPassCaptainLimitCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function SeasonPassCaptainLimitCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         FuiPopUpUtils.createPopupOk(null,null,BPLocale.getItem("captain_error_roster_full"));
      }
   }
}

