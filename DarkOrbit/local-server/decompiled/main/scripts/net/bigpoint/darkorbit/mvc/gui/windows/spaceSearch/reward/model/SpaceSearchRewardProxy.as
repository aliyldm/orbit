package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model
{
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import org.puremvc.as3.multicore.interfaces.IFacade;
   
   public class SpaceSearchRewardProxy extends SimpleWindowProxy
   {
      
      public function SpaceSearchRewardProxy(param1:String)
      {
         super(param1,new SpaceSearchRewardData());
      }
      
      public static function getOrCreateProxy(param1:IFacade) : SpaceSearchRewardProxy
      {
         var _loc2_:SpaceSearchRewardProxy = param1.retrieveProxy(GuiConstants.SPACE_SEARCH_REWARD) as SpaceSearchRewardProxy;
         if(!_loc2_)
         {
            _loc2_ = new SpaceSearchRewardProxy(GuiConstants.SPACE_SEARCH_REWARD);
            param1.registerProxy(_loc2_);
         }
         return _loc2_;
      }
      
      public function get viewData() : SpaceSearchRewardData
      {
         return this.data as SpaceSearchRewardData;
      }
   }
}

