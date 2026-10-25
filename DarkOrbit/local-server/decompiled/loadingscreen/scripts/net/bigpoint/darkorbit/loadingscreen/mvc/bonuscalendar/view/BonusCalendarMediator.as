package net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.view
{
   import flash.display.Bitmap;
   import flash.events.Event;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.loadingscreen.application.ApplicationFacade;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.notifications.ApplicationNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.notifications.LoadingAnimationNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.view.StageMediator;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.model.ids.LibId;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.notifications.AssetNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.background.view.mediators.BackgroundContainerMediator;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.model.vo.ItemVO;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.notifications.BonusCalendarNotifications;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.view.components.ItemList;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class BonusCalendarMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "BonusCalendarMediator";
      
      private static var loadedAssetsCount:uint = 0;
      
      public function BonusCalendarMediator(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [AssetNotification.UI_LOADED,AssetNotification.BG_LOADED,BonusCalendarNotifications.ITEMLIST_RECEIVED,BonusCalendarNotifications.PREMIUM_REWARDS_RECEIVED,BonusCalendarNotifications.TIME_VALUE_RECEIVED,ApplicationNotification.INIT_APPLICATION,ApplicationNotification.RESIZE];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:Vector.<ItemVO> = null;
         var _loc5_:Vector.<ItemVO> = null;
         var _loc6_:Number = NaN;
         var _loc7_:SWFFinisher = null;
         _loc2_ = param1.getBody() as Array;
         switch(param1.getName())
         {
            case ApplicationNotification.INIT_APPLICATION:
               this.view.visible = false;
               break;
            case AssetNotification.BG_LOADED:
            case AssetNotification.UI_LOADED:
               ++loadedAssetsCount;
               _loc3_ = _loc2_[0] as String;
               if(_loc3_ == LibId.UI_ASSETS)
               {
                  _loc7_ = _loc2_[1] as SWFFinisher;
                  this.view.initializeComponents(_loc7_);
                  this.view.addEventListener(ItemList.EVENT_ALL_IMAGES_LOADED,this.handleAllItemsLoadedEvent);
                  this.resize();
               }
               if(loadedAssetsCount == 2)
               {
                  this.sendItemListRequest();
               }
               break;
            case BonusCalendarNotifications.ITEMLIST_RECEIVED:
               _loc4_ = param1.getBody() as Vector.<ItemVO>;
               this.view.list = _loc4_;
               this.resize();
               break;
            case BonusCalendarNotifications.PREMIUM_REWARDS_RECEIVED:
               sendNotification(LoadingAnimationNotification.HIDE);
               _loc5_ = param1.getBody() as Vector.<ItemVO>;
               this.view.data = _loc5_;
               break;
            case ApplicationNotification.RESIZE:
               this.resize();
               break;
            case BonusCalendarNotifications.TIME_VALUE_RECEIVED:
               _loc6_ = Number(_loc2_[0]);
               this.view.updateTimer(_loc6_);
         }
      }
      
      private function sendItemListRequest() : void
      {
         sendNotification(LoadingAnimationNotification.SHOW);
         sendNotification(BonusCalendarNotifications.SEND_ITEMLIST_REQUEST);
      }
      
      private function get view() : BonusCalendarView
      {
         return getViewComponent() as BonusCalendarView;
      }
      
      private function resize() : void
      {
         var _loc4_:int = 0;
         var _loc1_:StageMediator = facade.retrieveMediator(StageMediator.NAME) as StageMediator;
         var _loc2_:BackgroundContainerMediator = facade.retrieveMediator(BackgroundContainerMediator.NAME) as BackgroundContainerMediator;
         var _loc3_:Bitmap = _loc2_.getLogoAsDisplayObject();
         if(this.view != null && _loc3_ != null)
         {
            this.view.scaleX = this.view.scaleY = 1;
            this.view.y = _loc1_.stage.stageHeight - this.view.height >> 1;
            this.view.x = _loc1_.stage.stageWidth - this.view.width >> 1;
            _loc4_ = _loc1_.stage.stageHeight - this.view.height - this.view.y;
            if(_loc4_ > 0)
            {
               _loc2_.scaleLogo(_loc4_);
            }
         }
         this.setLoadingBarPosition();
      }
      
      private function setLoadingBarPosition() : void
      {
         var _loc1_:StageMediator = facade.retrieveMediator(StageMediator.NAME) as StageMediator;
         if(_loc1_.stage.stageHeight < this.view.loadingBarHeightThreshold)
         {
            this.view.loadingBarView.y = _loc1_.stage.stageHeight - this.view.loadingBarView.height;
         }
         else
         {
            this.view.resetLoginBonusPanelTitlePos();
         }
      }
      
      private function handleAllItemsLoadedEvent(param1:Event) : void
      {
         this.resize();
         ApplicationFacade(facade).appWindow.dispatchEvent(new Event("ready"));
         this.view.visible = true;
         this.view.showUI();
      }
   }
}

