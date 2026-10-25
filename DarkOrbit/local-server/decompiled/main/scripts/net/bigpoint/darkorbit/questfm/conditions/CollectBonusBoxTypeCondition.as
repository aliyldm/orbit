package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class CollectBonusBoxTypeCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      public function CollectBonusBoxTypeCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         super.parseMatches(param1);
         var _loc2_:String = param1.length ? BPLocale.getItem("package_boxes_" + param1[0]) : "-";
         _description = description.replace(/%count%/,_target + "x").replace(/%name%/,_loc2_);
         if(_target > 0)
         {
            _target_plain = "/" + _target;
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

