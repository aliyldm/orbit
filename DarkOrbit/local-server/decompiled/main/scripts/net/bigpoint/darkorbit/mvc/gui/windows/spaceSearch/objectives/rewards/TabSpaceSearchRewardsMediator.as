package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.rewards
{
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchRequest;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.rewards.model.TabSpaceSearchRewardsData;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.rewards.model.TabSpaceSearchRewardsListVO;
   
   public class TabSpaceSearchRewardsMediator extends SimpleWindowMediator
   {
      
      private var viewData:TabSpaceSearchRewardsData;
      
      private var view:TabSpaceSearchRewardsView;
      
      private var currentList:Vector.<TabSpaceSearchRewardsListVO>;
      
      public function TabSpaceSearchRewardsMediator(param1:String, param2:SimpleWindow, param3:TabSpaceSearchRewardsData)
      {
         super(param1,param2);
         this.viewData = param3;
         this.viewData.changed.add(this.onDataChanged);
      }
      
      public function refreshData() : void
      {
         var _loc1_:SpaceSearchRequest = new SpaceSearchRequest();
         _loc1_.action = SpaceSearchRequest.ACTION_ssSectorRewardsList;
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc1_);
      }
      
      public function setView(param1:TabSpaceSearchRewardsView) : void
      {
         this.view = param1;
         this.onDataChanged();
      }
      
      public function onDataChanged() : void
      {
         if(!this.viewData)
         {
            return;
         }
         if(!this.view)
         {
            return;
         }
         this.removeExchangeButtonsListener();
         this.view.availableExchangeItemList = this.viewData.list;
         this.addExchangeButtonsListener();
      }
      
      public function sendExchangeRequest(param1:TabSpaceSearchRewardsListVO) : void
      {
         var _loc2_:SpaceSearchRequest = new SpaceSearchRequest();
         _loc2_.action = SpaceSearchRequest.ACTION_ssSectorRewardsGet;
         _loc2_.count = param1.range;
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc2_);
      }
      
      private function addExchangeButtonsListener() : void
      {
         var _loc1_:TabSpaceSearchRewardsListVO = null;
         if(this.viewData.list)
         {
            for each(_loc1_ in this.viewData.list)
            {
               _loc1_.requestExchange.add(this.sendExchangeRequest);
            }
            this.currentList = this.viewData.list;
         }
      }
      
      private function removeExchangeButtonsListener() : void
      {
         var _loc1_:TabSpaceSearchRewardsListVO = null;
         if(this.currentList)
         {
            for each(_loc1_ in this.currentList)
            {
               _loc1_.requestExchange.remove(this.sendExchangeRequest);
            }
         }
      }
   }
}

