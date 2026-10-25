package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions
{
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchRequest;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions.model.TabSpaceSearchMissionsData;
   
   public class TabSpaceSearchMissionsMediator extends SimpleWindowMediator
   {
      
      private var viewData:TabSpaceSearchMissionsData;
      
      private var view:TabSpaceSearchMissionsView;
      
      public function TabSpaceSearchMissionsMediator(param1:String, param2:SimpleWindow, param3:TabSpaceSearchMissionsData)
      {
         super(param1,param2);
         this.viewData = param3;
         this.viewData.changed.add(this.onDataChanged);
      }
      
      public function setView(param1:TabSpaceSearchMissionsView) : void
      {
         this.view = param1;
         this.onDataChanged();
      }
      
      public function refreshData() : void
      {
         var _loc1_:SpaceSearchRequest = new SpaceSearchRequest();
         _loc1_.action = SpaceSearchRequest.ACTION_ssMissionList;
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc1_);
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
         this.view.availableExchangeItemList = this.viewData.list;
      }
   }
}

