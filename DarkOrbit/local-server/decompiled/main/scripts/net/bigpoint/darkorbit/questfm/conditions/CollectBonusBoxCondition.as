package net.bigpoint.darkorbit.questfm.conditions
{
   public class CollectBonusBoxCondition extends Condition
   {
      
      public function CollectBonusBoxCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         super.parseMatches(param1);
         _description = description.replace(/%count%/,_target);
         if(_target > 0)
         {
            _target_plain = "/" + _target;
         }
         _helpIconData = getBitmapDataByKey("bonus_box");
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

