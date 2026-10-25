package net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.model.utils
{
   import net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.model.vo.EventProgressVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.model.vo.EventRewardVO;
   import net.bigpoint.darkorbit.utils.XMLUtils;
   
   public class EventProgressXMLParser
   {
      
      public function EventProgressXMLParser()
      {
         super();
      }
      
      public static function parse(param1:XML) : EventProgressVO
      {
         var _loc3_:String = null;
         var _loc4_:EventRewardVO = null;
         var _loc6_:XML = null;
         param1 = XMLUtils.clean(param1);
         var _loc2_:EventProgressVO = new EventProgressVO();
         _loc2_.title = param1.attributes.titleKey;
         _loc2_.description = param1.attributes.descriptionKey;
         _loc2_.source = param1.attributes.sourceKey;
         _loc3_ = param1.attributes.resetPrice.@uridium;
         if(_loc3_)
         {
            _loc2_.resetPriceCurrency = EventProgressVO.URIDIUM;
         }
         else
         {
            _loc3_ = param1.attributes.resetPrice.@credits;
            _loc2_.resetPriceCurrency = EventProgressVO.CREDITS;
         }
         _loc2_.resetPrice = parseInt(_loc3_);
         var _loc5_:int = 0;
         for each(_loc6_ in param1.rewards.reward)
         {
            _loc4_ = new EventRewardVO();
            _loc4_.lootID = _loc6_.@lootid;
            _loc4_.packageID = _loc6_.@packageid;
            _loc4_.setPackageItemIDs(_loc6_.@packageItemIds);
            _loc4_.itemShowTimeinSec = _loc6_.@itemShowTimeInSec;
            _loc4_.tooltipkey = _loc6_.@tooltipkey;
            _loc4_.amount = parseInt(_loc6_.@amount);
            _loc4_.unlockRequirement = parseInt(_loc6_.@unlockRequirement);
            if(_loc4_.unlockRequirement > _loc5_)
            {
               _loc5_ = _loc4_.unlockRequirement;
            }
            _loc2_.addReward(_loc4_);
         }
         _loc2_.sortRewards();
         _loc2_.maxUnlockRequirement = _loc5_;
         return _loc2_;
      }
   }
}

