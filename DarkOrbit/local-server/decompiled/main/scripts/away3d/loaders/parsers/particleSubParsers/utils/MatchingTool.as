package away3d.loaders.parsers.particleSubParsers.utils
{
   public class MatchingTool
   {
      
      public function MatchingTool()
      {
         super();
      }
      
      public static function getMatchedClass(param1:*, param2:Array) : Class
      {
         var _loc3_:Class = null;
         var _loc4_:Class = null;
         for each(_loc4_ in param2)
         {
            if(_loc4_["identifier"] == param1)
            {
               _loc3_ = _loc4_;
               break;
            }
         }
         return _loc3_;
      }
   }
}

