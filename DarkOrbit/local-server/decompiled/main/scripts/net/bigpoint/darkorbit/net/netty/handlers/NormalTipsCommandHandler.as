package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.NormalTipsCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.CreatePopupView;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class NormalTipsCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function NormalTipsCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:NormalTipsCommand = param1.getBody() as NormalTipsCommand;
         CreatePopupView.getInstance().createPopup(null,BPLocale.getItem(_loc2_.messageKey));
      }
   }
}

