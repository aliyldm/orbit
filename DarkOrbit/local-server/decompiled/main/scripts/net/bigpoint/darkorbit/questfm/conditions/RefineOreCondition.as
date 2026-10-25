package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   
   public class RefineOreCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      public function RefineOreCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         super.parseMatches(param1);
         var _loc2_:String = param1[0] ? param1[0] : "";
         _description = _description.replace(/%TYPE%/,TextUtils.getTranslationByType(_loc2_,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_SHORT));
         _target_plain = "/" + _target;
      }
      
      override public function get currentVerbose() : String
      {
         return _current.toString();
      }
   }
}

