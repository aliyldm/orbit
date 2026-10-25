package away3d.library.naming
{
   import away3d.arcane;
   import away3d.library.assets.IAsset;
   
   use namespace arcane;
   
   public class NumSuffixConflictStrategy extends ConflictStrategyBase
   {
      
      private var _separator:String;
      
      private var _next_suffix:Object;
      
      public function NumSuffixConflictStrategy(param1:String = ".")
      {
         super();
         this._separator = param1;
         this._next_suffix = {};
      }
      
      override public function resolveConflict(param1:IAsset, param2:IAsset, param3:Object, param4:String) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         _loc5_ = param1.name;
         if(_loc5_.indexOf(this._separator) >= 0)
         {
            _loc7_ = _loc5_.substring(0,_loc5_.lastIndexOf(this._separator));
            _loc8_ = parseInt(_loc5_.substring(_loc7_.length - 1));
            if(isNaN(_loc8_))
            {
               _loc7_ = _loc5_;
               _loc8_ = 0;
            }
         }
         else
         {
            _loc7_ = _loc5_;
            _loc8_ = 0;
         }
         if(_loc8_ == 0 && this._next_suffix.hasOwnProperty(_loc7_))
         {
            _loc8_ = int(this._next_suffix[_loc7_]);
         }
         do
         {
            _loc8_++;
            _loc6_ = _loc7_.concat(this._separator,_loc8_);
         }
         while(param3.hasOwnProperty(_loc6_));
         this._next_suffix[_loc7_] = _loc8_;
         updateNames(param2.assetNamespace,_loc6_,param2,param1,param3,param4);
      }
      
      override public function create() : ConflictStrategyBase
      {
         return new NumSuffixConflictStrategy(this._separator);
      }
   }
}

