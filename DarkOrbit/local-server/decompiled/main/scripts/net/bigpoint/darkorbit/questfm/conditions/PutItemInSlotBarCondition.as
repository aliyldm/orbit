package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   
   public class PutItemInSlotBarCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private static var TRANS_BASE_KEY_SPECIAL_CASE:String = "PUT_ITEM_IN_ANY_SLOT_BAR";
      
      public function PutItemInSlotBarCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         super.parseMatches(param1);
         if(param1.length > 2)
         {
            _loc2_ = BPLocale.getItem(param1[0]);
            _loc3_ = parseInt(param1[1]);
            _loc4_ = TextUtils.getTranslationByType(param1[2],ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME);
            _description = _description.replace(/%SLOT%/,_loc3_).replace(/%BAR%/,_loc2_).replace(/%ITEM%/,_loc4_);
         }
         else if(param1.length > 1 && param1.length <= 2)
         {
            _loc5_ = BPLocale.getItem(param1[0]);
            _loc6_ = TextUtils.getTranslationByType(param1[1],ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME);
            _description = BPLocale.getItem("q2_condition_" + TRANS_BASE_KEY_SPECIAL_CASE);
            _description = _description.replace(/%BAR%/,_loc5_).replace(/%ITEM%/,_loc6_);
         }
      }
   }
}

