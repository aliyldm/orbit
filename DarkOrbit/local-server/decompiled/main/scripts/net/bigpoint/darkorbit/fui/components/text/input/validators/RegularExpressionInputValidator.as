package net.bigpoint.darkorbit.fui.components.text.input.validators
{
   import flash.events.Event;
   
   public class RegularExpressionInputValidator extends TextLengthInputValidator
   {
      
      public static const EVENT_REGEXP_INVALID:String = "event.invalid";
      
      protected static const DEFAULT_REGEXP:RegExp = /^[a-zA-Z0-9]*$/i;
      
      protected var regExpr:RegExp;
      
      public function RegularExpressionInputValidator(param1:RegExp = null, param2:uint = 3, param3:uint = 52)
      {
         super(param2,param3);
         this.setRegExpression(param1);
      }
      
      protected function setRegExpression(param1:RegExp = null) : void
      {
         if(param1 == null)
         {
            this.regExpr = DEFAULT_REGEXP;
         }
         else
         {
            this.regExpr = param1;
         }
      }
      
      override protected function validate() : Boolean
      {
         var _loc1_:Boolean = false;
         _valid = false;
         if(_instance)
         {
            _loc1_ = super.validate();
            if(_loc1_)
            {
               _loc1_ = this.regExpr.test(_instance.text);
               if(!_loc1_)
               {
                  dispatchEvent(new Event(EVENT_REGEXP_INVALID));
               }
               return _loc1_;
            }
         }
         return _valid;
      }
   }
}

