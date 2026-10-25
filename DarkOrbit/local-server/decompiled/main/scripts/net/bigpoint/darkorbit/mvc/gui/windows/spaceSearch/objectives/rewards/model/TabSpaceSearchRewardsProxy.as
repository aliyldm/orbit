package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.rewards.model
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchSectorRewards;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchSectorRewardsCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.SpaceSearchXML;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model.BoundPackage;
   import org.puremvc.as3.multicore.interfaces.IFacade;
   
   public class TabSpaceSearchRewardsProxy extends SimpleWindowProxy
   {
      
      private var dict:Dictionary;
      
      public function TabSpaceSearchRewardsProxy(param1:String)
      {
         super(param1,new TabSpaceSearchRewardsData());
      }
      
      public static function getOrCreateProxy(param1:IFacade) : TabSpaceSearchRewardsProxy
      {
         var _loc2_:TabSpaceSearchRewardsProxy = param1.retrieveProxy(GuiConstants.SPACE_SEARCH_OBJECTIVES_REWARDS) as TabSpaceSearchRewardsProxy;
         if(!_loc2_)
         {
            _loc2_ = new TabSpaceSearchRewardsProxy(GuiConstants.SPACE_SEARCH_OBJECTIVES_REWARDS);
            param1.registerProxy(_loc2_);
         }
         return _loc2_;
      }
      
      public function get viewData() : TabSpaceSearchRewardsData
      {
         return this.data as TabSpaceSearchRewardsData;
      }
      
      public function updateData(param1:SpaceSearchSectorRewardsCommand) : void
      {
         var _loc5_:XML = null;
         var _loc6_:SpaceSearchSectorRewards = null;
         var _loc7_:TabSpaceSearchRewardsListVO = null;
         var _loc8_:BoundPackage = null;
         if(!this.dict)
         {
            _loc5_ = SpaceSearchXML.xmls["events_space_search_rewards"];
            if(_loc5_)
            {
               this.dict = SpaceSearchXML.createRangeRewardToResKeyMap(_loc5_);
            }
         }
         var _loc2_:Vector.<TabSpaceSearchRewardsListVO> = new Vector.<TabSpaceSearchRewardsListVO>();
         var _loc3_:int = 0;
         while(_loc3_ < param1.rewards.length)
         {
            _loc6_ = param1.rewards[_loc3_];
            _loc7_ = new TabSpaceSearchRewardsListVO();
            _loc7_.range = _loc6_.range;
            _loc7_.count = _loc6_.count;
            _loc7_.unlock = _loc6_.unlock;
            _loc7_.received = _loc6_.received;
            _loc8_ = this.dict[_loc7_.range] as BoundPackage;
            if(_loc8_)
            {
               _loc7_.bp = _loc8_;
               _loc2_.push(_loc7_);
            }
            _loc3_++;
         }
         var _loc4_:XML = SpaceSearchXML.xmls["events_space_search_rewards"];
         this.viewData.updateData(_loc2_);
      }
   }
}

