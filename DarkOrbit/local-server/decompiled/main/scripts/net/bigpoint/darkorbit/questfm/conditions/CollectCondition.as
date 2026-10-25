package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class CollectCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var oreID:int;
      
      public function CollectCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         super.parseMatches(param1);
         if(mandatory && _target > 0)
         {
            _target_plain = "/" + _target;
         }
         else
         {
            _description = BPLocale.getItem("q2_condition_" + _definition.TRANS_BASE_KEY + "_challenge");
         }
         this.oreID = int(param1[0]);
         var _loc2_:uint = uint(InGameCatalog.instance.ore_oldIDtoNewID[this.oreID]);
         _description = _description.replace(/%ore%/,InGameCatalog.instance.ore_names[_loc2_]);
         _helpIconData = getBitmapDataByKey("ore_" + this.oreID + ".png");
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

