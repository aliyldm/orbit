package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model
{
   import net.bigpoint.darkorbit.com.module.porting.voyagers.VoyagersClaimPassRewardRequest;
   import net.bigpoint.darkorbit.com.module.porting.voyagers.VoyagersPassCommand;
   import net.bigpoint.darkorbit.com.module.porting.voyagers.VoyagersUIRequest;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class SingularityDrivePassProxy extends SimpleWindowProxy
   {
      
      public static const NAME:* = "SingularityDrivePassProxy";
      
      private var _viewData:SingularityDrivePassViewData;
      
      public function SingularityDrivePassProxy()
      {
         super(NAME);
         this._viewData = new SingularityDrivePassViewData();
      }
      
      public static function getProxy() : SingularityDrivePassProxy
      {
         var _loc1_:SingularityDrivePassProxy = GameFacade.getInstance().retrieveProxy(SingularityDrivePassProxy.NAME) as SingularityDrivePassProxy;
         if(!_loc1_)
         {
            _loc1_ = new SingularityDrivePassProxy();
            GameFacade.getInstance().registerProxy(_loc1_);
         }
         return _loc1_;
      }
      
      public function get viewData() : SingularityDrivePassViewData
      {
         return this._viewData;
      }
      
      public function sendUIRequest() : void
      {
         var _loc1_:VoyagersUIRequest = new VoyagersUIRequest();
         connectionProxy.sendNettyRequest(_loc1_);
      }
      
      public function sendPassCliamRequest(param1:int, param2:Boolean) : void
      {
         var _loc3_:VoyagersClaimPassRewardRequest = new VoyagersClaimPassRewardRequest(param1,param2);
         connectionProxy.sendNettyRequest(_loc3_);
      }
      
      public function rcvRewardPass(param1:VoyagersPassCommand) : void
      {
         this._viewData.updateReward(param1);
      }
   }
}

