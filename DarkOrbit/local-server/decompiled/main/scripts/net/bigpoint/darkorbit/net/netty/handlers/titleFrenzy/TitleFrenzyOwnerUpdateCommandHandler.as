package net.bigpoint.darkorbit.net.netty.handlers.titleFrenzy
{
   import net.bigpoint.darkorbit.com.module.TitleFrenzyOwnerUpdateCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.overview.model.TitleFrenzyUIOverviewProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TitleFrenzyOwnerUpdateCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function TitleFrenzyOwnerUpdateCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:TitleFrenzyUIOverviewProxy = retrieveProxy(GuiConstants.TITLE_FRENZY_OVERVIEW) as TitleFrenzyUIOverviewProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.TITLE_FRENZY);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.TITLE_FRENZY_OVERVIEW) as TitleFrenzyUIOverviewProxy;
         }
         var _loc3_:TitleFrenzyOwnerUpdateCommand = param1.getBody() as TitleFrenzyOwnerUpdateCommand;
         _loc2_.updateOwnerInfo(_loc3_);
      }
   }
}

