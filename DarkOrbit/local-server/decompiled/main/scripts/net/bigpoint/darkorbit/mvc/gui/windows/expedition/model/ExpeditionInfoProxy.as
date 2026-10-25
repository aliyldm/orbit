package net.bigpoint.darkorbit.mvc.gui.windows.expedition.model
{
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionInfoRequest;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.ExpeditionNotification;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.model.vo.ExpeditionViewData;
   import org.puremvc.as3.multicore.interfaces.IFacade;
   
   public class ExpeditionInfoProxy extends SimpleWindowProxy
   {
      
      public static const NAME:String = "ExpeditionInfoProxy";
      
      public var viewData:ExpeditionViewData;
      
      public function ExpeditionInfoProxy()
      {
         super(NAME);
         this.viewData = new ExpeditionViewData();
      }
      
      public static function getProxy(param1:IFacade) : ExpeditionInfoProxy
      {
         var _loc2_:ExpeditionInfoProxy = param1.retrieveProxy(ExpeditionInfoProxy.NAME) as ExpeditionInfoProxy;
         if(!_loc2_)
         {
            _loc2_ = new ExpeditionInfoProxy();
            param1.registerProxy(_loc2_);
         }
         return _loc2_;
      }
      
      public function sendExpeditionInfoRequest() : void
      {
         var _loc1_:ExpeditionInfoRequest = new ExpeditionInfoRequest();
         connectionProxy.connectionManager.sendRequest(_loc1_);
      }
      
      public function rcvExpeditionInfo(param1:ExpeditionInfoCommand) : void
      {
         this.viewData.update(param1);
         sendNotification(ExpeditionNotification.DATA_AVAILABLED);
      }
   }
}

