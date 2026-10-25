package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class ActivateMapAssetCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      public function ActivateMapAssetCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         super.parseMatches(param1);
         if(param1.length)
         {
            _loc2_ = int(param1[0]);
            _loc3_ = InGameCatalog.instance.mapAssetLocakeys[_loc2_];
            if(!_loc3_)
            {
               return;
            }
            _loc4_ = BPLocale.getItem(_loc3_);
            _description = _description.replace(/%TYPE%/,_loc4_);
         }
      }
   }
}

