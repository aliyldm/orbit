package net.bigpoint.darkorbit.questfm
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.questfm.conditions.Condition;
   
   public class CollectBuildRecipeCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private static const SINGLE:String = "_single";
      
      private static const MULTI:String = "_multi";
      
      private static const ANY:String = "_any";
      
      private static const RECIPE_ID:String = "_recipeid";
      
      public function CollectBuildRecipeCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc5_:String = null;
         super.parseMatches(param1);
         var _loc2_:String = _target > 1 ? MULTI : SINGLE;
         var _loc3_:String = param1.length == 0 > 1 ? ANY : RECIPE_ID;
         var _loc4_:String = "q2_condition_" + _definition.TRANS_BASE_KEY + _loc3_ + _loc2_;
         _loc5_ = param1.length == 0 ? null : param1[0];
         _description = BPLocale.getItem(_loc4_).replace("%recipeId%",_loc5_ ? TextUtils.getTranslationByType(_loc5_,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME) : " ? ").replace("%amount%",_target);
         _target_plain = "/" + _target;
      }
      
      override public function get currentVerbose() : String
      {
         return _current.toString();
      }
   }
}

