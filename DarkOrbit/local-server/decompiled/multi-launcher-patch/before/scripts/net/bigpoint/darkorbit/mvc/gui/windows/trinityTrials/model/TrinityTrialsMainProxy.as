package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model
{
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsClaimPassRewardRequest;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsDropLevelCommand;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsDropLevelOptionalRequest;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsPassCommand;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsRewardDescriptionCommand;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsUIRequest;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class TrinityTrialsMainProxy extends SimpleWindowProxy
   {
      
      public static const NAME:* = "TrinityTrialsMainProxy";
      
      private var _viewData:TrinityTrialsMainViewData;
      
      public function TrinityTrialsMainProxy()
      {
         super(NAME);
         this._viewData = new TrinityTrialsMainViewData();
      }
      
      public static function getProxy() : TrinityTrialsMainProxy
      {
         var _loc1_:TrinityTrialsMainProxy = GameFacade.getInstance().retrieveProxy(TrinityTrialsMainProxy.NAME) as TrinityTrialsMainProxy;
         if(!_loc1_)
         {
            _loc1_ = new TrinityTrialsMainProxy();
            GameFacade.getInstance().registerProxy(_loc1_);
         }
         return _loc1_;
      }
      
      public function get viewData() : TrinityTrialsMainViewData
      {
         return this._viewData;
      }
      
      public function sendUIRequest(param1:int = 0) : void
      {
         var _loc2_:TrinityTrialsUIRequest = new TrinityTrialsUIRequest(param1);
         connectionProxy.sendNettyRequest(_loc2_);
      }
      
      public function sendUpLevelRequest(param1:String, param2:int) : void
      {
         var _loc3_:TrinityTrialsDropLevelOptionalRequest = new TrinityTrialsDropLevelOptionalRequest(param1,param2);
         connectionProxy.sendNettyRequest(_loc3_);
      }
      
      public function sendPassCliamRequest(param1:int, param2:Boolean) : void
      {
         var _loc3_:TrinityTrialsClaimPassRewardRequest = new TrinityTrialsClaimPassRewardRequest(0,param2);
         connectionProxy.sendNettyRequest(_loc3_);
      }
      
      public function rcvRewardPass(param1:TrinityTrialsPassCommand) : void
      {
         this._viewData.updateReward(param1);
      }
      
      public function rcvUpLevelData(param1:TrinityTrialsDropLevelCommand) : void
      {
         this._viewData.updateLevel(param1);
      }
      
      public function rcvDropInfoData(param1:TrinityTrialsRewardDescriptionCommand) : void
      {
         this._viewData.updateDropInfoData(param1);
      }
   }
}

