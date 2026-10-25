package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.darkorbit.map.model.Map;
   
   public class MapCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _map_ids:Vector.<int>;
      
      private var _map_names:Array;
      
      public function MapCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         super.parseMatches(param1);
         this._map_ids = new Vector.<int>();
         this._map_names = new Array();
         var _loc2_:String = "";
         for each(_loc3_ in param1)
         {
            _loc4_ = Map.getMissionMapName(parseInt(_loc3_));
            if(this._map_names.indexOf(_loc4_) == -1)
            {
               this._map_names.push(_loc4_);
               if(_loc2_ != "")
               {
                  _loc2_ += ", ";
               }
               _loc2_ += _loc4_;
            }
         }
         _description = _description.replace(/%map%/,_loc2_);
      }
   }
}

