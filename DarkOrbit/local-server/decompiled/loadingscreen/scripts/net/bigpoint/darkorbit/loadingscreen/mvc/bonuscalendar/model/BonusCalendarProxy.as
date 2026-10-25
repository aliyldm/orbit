package net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.model
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.model.JavascriptProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.model.test.ItemListTestData;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.model.vo.ItemVO;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.notifications.BonusCalendarNotifications;
   import net.bigpoint.darkorbit.loadingscreen.utils.Session;
   import org.puremvc.as3.patterns.proxy.Proxy;
   
   public class BonusCalendarProxy extends Proxy
   {
      
      public static var NAME:String = "BonusCalendarProxy";
      
      private const loader:URLLoader = new URLLoader();
      
      private var _remainingSeconds:Number;
      
      private var _loginBonusActive:Boolean = false;
      
      private var jsonData:Object;
      
      public function BonusCalendarProxy()
      {
         super(NAME);
      }
      
      public function loadBonusCalendarList() : void
      {
         var _loc1_:String = Session.host + "flashAPI/dailyLogin.php";
         this.addLoaderListener();
         var _loc2_:URLRequest = new URLRequest(_loc1_);
         _loc2_.method = URLRequestMethod.POST;
         this.loader.load(_loc2_);
      }
      
      private function handleBonusCalendarListResponse() : void
      {
         sendNotification(BonusCalendarNotifications.ITEMLIST_RECEIVED,ItemListTestData.getItemList());
      }
      
      private function addLoaderListener() : void
      {
         this.loader.addEventListener(Event.COMPLETE,this.handleListLoaded);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.handleListLoadIOError);
         this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleListSecurityError);
      }
      
      private function removeLoaderListener() : void
      {
         this.loader.removeEventListener(Event.COMPLETE,this.handleListLoaded);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.handleListLoadIOError);
         this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleListSecurityError);
      }
      
      private function handleListLoaded(param1:Event) : void
      {
         if(this.loader.data != null)
         {
            JavascriptProxy.log("ILogger - handleLIstLoaded",this.loader.data);
            this.jsonData = JSON.parse(this.loader.data);
            if(!this.jsonData.isError)
            {
               this._remainingSeconds = this.jsonData.remainingSeconds;
               sendNotification(BonusCalendarNotifications.TIME_VALUE_RECEIVED,[this._remainingSeconds]);
               this.createItemListModel(this.jsonData.rewards);
               this.createPremiumRewardsModel(this.jsonData.rewards,this.jsonData.isPremium);
            }
         }
      }
      
      private function createItemListModel(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:ItemVO = null;
         var _loc2_:Vector.<ItemVO> = new Vector.<ItemVO>();
         var _loc4_:uint = param1.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param1[_loc5_];
            _loc3_ = _loc6_[0];
            _loc7_ = new ItemVO();
            _loc7_.parse(_loc3_);
            this.checkIfItemIsActive(_loc7_);
            _loc2_.push(_loc7_);
            _loc5_++;
         }
         sendNotification(BonusCalendarNotifications.ITEMLIST_RECEIVED,_loc2_);
      }
      
      private function createPremiumRewardsModel(param1:Array, param2:Boolean) : void
      {
         var _loc3_:ItemVO = null;
         var _loc4_:Vector.<ItemVO> = new Vector.<ItemVO>(2,true);
         var _loc5_:Object = param1[param1.length - 1];
         if(_loc5_.length == 2)
         {
            _loc3_ = this.createRewardItemFromReward(_loc5_[0]);
            _loc4_[0] = _loc3_;
            this.checkIfItemIsActive(_loc3_);
            _loc3_ = this.createRewardItemFromReward(_loc5_[1]);
            _loc3_.isPremium = param2;
            _loc4_[1] = _loc3_;
            this.checkIfItemIsActive(_loc3_);
         }
         sendNotification(BonusCalendarNotifications.PREMIUM_REWARDS_RECEIVED,_loc4_);
      }
      
      private function checkIfItemIsActive(param1:ItemVO) : void
      {
         if(param1.isActive())
         {
            if(!this._loginBonusActive)
            {
               this._loginBonusActive = true;
               sendNotification(BonusCalendarNotifications.DAILY_LOGIN_BONUS_ACTIVE);
            }
         }
      }
      
      private function createRewardItemFromReward(param1:Object) : ItemVO
      {
         var _loc2_:ItemVO = new ItemVO();
         _loc2_.parse(param1);
         return _loc2_;
      }
      
      private function handleListLoadIOError(param1:Event) : void
      {
         this.handleBonusCalendarListResponse();
      }
      
      private function handleListSecurityError(param1:SecurityErrorEvent) : void
      {
         this.handleBonusCalendarListResponse();
      }
      
      public function get remainingSeconds() : Number
      {
         return this._remainingSeconds;
      }
      
      public function get loginBonusActive() : Boolean
      {
         return this._loginBonusActive;
      }
   }
}

