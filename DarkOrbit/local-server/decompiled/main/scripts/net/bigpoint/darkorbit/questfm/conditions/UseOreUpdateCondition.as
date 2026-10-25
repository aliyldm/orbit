package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   
   public class UseOreUpdateCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      public function UseOreUpdateCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         super.parseMatches(param1);
         if(param1.length > 1)
         {
            _loc2_ = param1[0];
            _loc3_ = "";
            switch(_loc2_)
            {
               case "LASER":
                  _loc3_ = BPLocale.getItem("lab_laser");
                  break;
               case "ROCKET":
                  _loc3_ = BPLocale.getItem("lab_raketen");
                  break;
               case "SPEED":
                  _loc3_ = BPLocale.getItem("lab_antrieb");
                  break;
               case "SHIELD":
                  _loc3_ = BPLocale.getItem("lab_schild");
            }
            _loc4_ = TextUtils.getTranslationByType("resource_ore_" + param1[1].toLowerCase(),ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME);
            _description = _description.replace(/%TARGET%/,_loc3_).replace(/%TYPE%/,_loc4_);
            if(_target > 1)
            {
               _target_plain = "/" + _target;
            }
         }
      }
      
      override public function get currentVerbose() : String
      {
         if(_target > 1)
         {
            return current.toString();
         }
         return super.currentVerbose;
      }
   }
}

