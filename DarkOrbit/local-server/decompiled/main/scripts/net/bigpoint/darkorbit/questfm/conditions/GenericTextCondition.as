package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   
   public class GenericTextCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private static const OFFSET:int = 3;
      
      public function GenericTextCondition()
      {
         super();
      }
      
      override public function get currentVerbose() : String
      {
         if(_target > 0)
         {
            return String(_current);
         }
         return "";
      }
      
      override public function init(param1:int, param2:Number, param3:Number, param4:Boolean, param5:Boolean, param6:Boolean, param7:Vector.<String>) : void
      {
         super.init(param1,param2,param3,param4,param5,param6,param7);
         _validatable = ParserUtility.parseBooleanFromInt(int(param7[0]));
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:String = BPLocale.getItem(param1[1]);
         var _loc3_:int = int(param1[2]) + OFFSET;
         var _loc4_:int = OFFSET;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = param1[_loc4_ + 1];
            _loc2_ = _loc2_.replace(_loc5_,_loc6_);
            _loc4_ += 2;
         }
         if(_target > 0)
         {
            _target_plain = "/" + _target.toString();
         }
         else
         {
            _target_plain = "";
         }
         _description = _loc2_;
         super.parseMatches(param1);
      }
   }
}

