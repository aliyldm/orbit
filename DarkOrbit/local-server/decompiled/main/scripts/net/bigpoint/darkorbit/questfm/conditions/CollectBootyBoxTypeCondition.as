package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class CollectBootyBoxTypeCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      public function CollectBootyBoxTypeCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         super.parseMatches(param1);
         var _loc2_:String = param1.length ? InGameCatalog.instance.getBootyBoxName(param1[0]) : "-";
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

