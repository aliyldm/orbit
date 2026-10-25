package net.bigpoint.darkorbit.net.netty.handlers.warpControls
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipMoveItemsCommand;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class WarpControlsShipMoveItemsHandler extends DOAbstractSimpleCommand
   {
      
      public function WarpControlsShipMoveItemsHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:RegExp = null;
         var _loc4_:RegExp = null;
         var _loc5_:RegExp = null;
         var _loc6_:RegExp = null;
         var _loc7_:String = null;
         var _loc2_:HangarShipMoveItemsCommand = param1.getBody() as HangarShipMoveItemsCommand;
         if(_loc2_.result != 1)
         {
            if(_loc2_.errorMessage.enumBaseKey == BaseStackCommand.BASEKEY_eqt_error_playerMayNotEquip2)
            {
               _loc3_ = /<li>/gi;
               _loc4_ = new RegExp("</li>","gi");
               _loc5_ = /<ul>/gi;
               _loc6_ = new RegExp("</ul>","gi");
               _loc7_ = BPLocale.getItemInCategory("base","eqt_error_playerMayNotEquip2").replace(_loc5_,"").replace(_loc6_,"").replace(_loc3_,"").replace(_loc4_,"");
               GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(_loc7_));
            }
         }
         else
         {
            WarpControlsProxy.getProxy(this.facade).shipsItemMove(_loc2_);
         }
      }
   }
}

