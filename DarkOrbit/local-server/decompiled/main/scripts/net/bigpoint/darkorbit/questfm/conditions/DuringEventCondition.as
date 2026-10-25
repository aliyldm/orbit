package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class DuringEventCondition extends Condition
   {
      
      public function DuringEventCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         super.parseMatches(param1);
         _loc2_ = "";
         for each(_loc3_ in param1)
         {
            if(_loc2_ != "")
            {
               _loc2_ += ", ";
            }
            _loc2_ += BPLocale.getItem("title_" + _loc3_);
         }
         _description = _description.replace(/%EVENT%/,_loc2_);
      }
   }
}

