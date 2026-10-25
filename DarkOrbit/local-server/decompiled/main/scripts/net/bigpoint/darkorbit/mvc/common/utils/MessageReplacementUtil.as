package net.bigpoint.darkorbit.mvc.common.utils
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.ReplacementModule;
   
   public class MessageReplacementUtil
   {
      
      public function MessageReplacementUtil()
      {
         super();
      }
      
      public static function repaceAll(param1:String, param2:Vector.<ReplacementModule>) : String
      {
         var _loc4_:ReplacementModule = null;
         var _loc5_:RegExp = null;
         var _loc3_:int = int(param2.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_)
         {
            _loc4_ = param2[_loc6_];
            _loc5_ = new RegExp(_loc4_.regex);
            param1 = param1.replace(_loc5_,_loc4_.value);
            _loc6_++;
         }
         return param1;
      }
      
      public static function repaceAllWithTextKey(param1:String, param2:Vector.<ReplacementModule>) : String
      {
         return repaceAll(BPLocale.getItem(param1),param2);
      }
   }
}

