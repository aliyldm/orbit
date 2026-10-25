package net.bigpoint.darkorbit.mvc.common.web.controller
{
   import net.bigpoint.darkorbit.com.module.PageRefreshCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.web.WebConstants;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PageRefreshRequestCommand extends DOAbstractSimpleCommand
   {
      
      public function PageRefreshRequestCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:PageRefreshCommand = param1.getBody() as PageRefreshCommand;
         if(_loc2_)
         {
            _loc3_ = WebConstants.WEB_URL_ACTIONS_MAP[_loc2_.pageType];
            _loc4_ = WebConstants.WEB_URL_TEXTKEYS_MAP[_loc2_.pageType];
            JavascriptProxy.referToURL(_loc3_,_loc4_,null,false,null,null,null,_loc2_.openPage);
         }
      }
   }
}

