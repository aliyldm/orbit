package net.bigpoint.darkorbit.mvc.gui.windows.common.controller
{
   import net.bigpoint.darkorbit.com.module.HighlightTypeModule;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchRequest;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.highlights.HighLightItemNotification;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.model.BirthdayGate2025Constants;
   import net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.model.BirthdayGate2025Proxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions.model.TabSpaceSearchMissionsData;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions.model.TabSpaceSearchMissionsListVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions.model.TabSpaceSearchMissionsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.rewards.model.TabSpaceSearchRewardsData;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.rewards.model.TabSpaceSearchRewardsListVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.rewards.model.TabSpaceSearchRewardsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model.SpaceSearchRedDotProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model.SpaceSearchUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model.SpaceSearchUIProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class FeatureInitCommand extends DOAbstractSimpleCommand
   {
      
      public static const RED_DOT_HIGHLIGHTER:HighlightItemVO = new HighlightItemVO(GuiConstants.SPACE_SEARCH,FeaturesMenuConstants.MENU_ID,HighlightTypeModule.HIGHLIGHTTYPE_RED_DOT);
      
      private var spaceSearchMissionsData:TabSpaceSearchMissionsData;
      
      private var spaceSearchRewardsData:TabSpaceSearchRewardsData;
      
      private var spaceSearchUIData:SpaceSearchUIData;
      
      public function FeatureInitCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:SpaceSearchRequest = null;
         var _loc2_:String = param1.getBody() as String;
         if(_loc2_ == "space_search")
         {
            this.spaceSearchMissionsData = TabSpaceSearchMissionsProxy.getOrCreateProxy(this.facade).viewData;
            this.spaceSearchRewardsData = TabSpaceSearchRewardsProxy.getOrCreateProxy(this.facade).viewData;
            this.spaceSearchUIData = SpaceSearchUIProxy.getOrCreateProxy(this.facade).viewData;
            this.spaceSearchMissionsData.changed.add(this.onSpaceSearchChanged);
            this.spaceSearchRewardsData.changed.add(this.onSpaceSearchChanged);
            this.spaceSearchUIData.changed.add(this.onSpaceSearchChanged);
            _loc3_ = new SpaceSearchRequest();
            _loc3_.action = SpaceSearchRequest.ACTION_ssAtlas;
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc3_);
            _loc3_ = new SpaceSearchRequest();
            _loc3_.action = SpaceSearchRequest.ACTION_ssMissionList;
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc3_);
            _loc3_ = new SpaceSearchRequest();
            _loc3_.action = SpaceSearchRequest.ACTION_ssSectorRewardsList;
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc3_);
         }
         if(_loc2_ == BirthdayGate2025Constants.BIRTHDAY_2025)
         {
            BirthdayGate2025Proxy.getProxy(this.facade).sendViewInitRequest();
         }
      }
      
      private function onSpaceSearchChanged() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:TabSpaceSearchMissionsListVO = null;
         var _loc6_:TabSpaceSearchRewardsListVO = null;
         if(this.spaceSearchUIData.count > 0 && this.spaceSearchMissionsData.count > 0 && this.spaceSearchRewardsData.count > 0)
         {
            _loc1_ = true;
            if(this.spaceSearchUIData.prc == 100)
            {
               _loc1_ = false;
            }
            else if(this.spaceSearchUIData.quantity < this.spaceSearchUIData.cost)
            {
               _loc1_ = false;
            }
            _loc2_ = false;
            _loc3_ = 0;
            while(_loc3_ < this.spaceSearchMissionsData.list.length)
            {
               _loc5_ = this.spaceSearchMissionsData.list[_loc3_];
               if(!_loc5_.completed)
               {
                  _loc2_ = true;
                  break;
               }
               _loc3_++;
            }
            _loc4_ = false;
            _loc3_ = 0;
            while(_loc3_ < this.spaceSearchRewardsData.list.length)
            {
               _loc6_ = this.spaceSearchRewardsData.list[_loc3_];
               if(_loc6_.unlock && !_loc6_.received)
               {
                  _loc4_ = true;
                  break;
               }
               _loc3_++;
            }
            this.updateDotHighlighter(_loc4_);
            SpaceSearchRedDotProxy.getOrCreateProxy(this.facade).viewData.update(_loc1_,false,_loc4_);
         }
      }
      
      private function updateDotHighlighter(param1:Boolean) : void
      {
         if(param1)
         {
            facade.sendNotification(HighLightItemNotification.ADD_HIGHLIGHT,RED_DOT_HIGHLIGHTER);
         }
         else
         {
            facade.sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,RED_DOT_HIGHLIGHTER);
         }
      }
   }
}

