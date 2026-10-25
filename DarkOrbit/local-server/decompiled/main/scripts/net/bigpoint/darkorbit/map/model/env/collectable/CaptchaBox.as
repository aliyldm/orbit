package net.bigpoint.darkorbit.map.model.env.collectable
{
   public class CaptchaBox extends Collectable
   {
      
      private var _captchaIndex:int;
      
      public function CaptchaBox(param1:String, param2:String, param3:int, param4:int, param5:Boolean, param6:int)
      {
         super("box_" + param1,param2,param3,param4,param5);
         this._captchaIndex = param6;
      }
      
      public function getIndex() : *
      {
         return this._captchaIndex;
      }
   }
}

