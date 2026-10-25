package net.bigpoint.darkorbit.map.view3D.utils
{
   public class AgalHelper
   {
      
      public function AgalHelper()
      {
         super();
      }
      
      public static function texture(param1:Object, param2:Object, param3:Object, param4:Object = "<2d,linear,clamp>") : Object
      {
         return "tex " + param1 + ", " + param2 + ", " + param3 + " " + param4 + "\n";
      }
      
      public static function add(param1:Object, param2:Object, param3:Object) : Object
      {
         return "add " + param1 + ", " + param2 + ", " + param3 + "\n";
      }
      
      public static function div(param1:Object, param2:Object, param3:Object) : Object
      {
         return "div " + param1 + ", " + param2 + ", " + param3 + "\n";
      }
      
      public static function sub(param1:Object, param2:Object, param3:Object) : Object
      {
         return "sub " + param1 + ", " + param2 + ", " + param3 + "\n";
      }
      
      public static function mul(param1:Object, param2:Object, param3:Object) : Object
      {
         return "mul " + param1 + ", " + param2 + ", " + param3 + "\n";
      }
      
      public static function sge(param1:Object, param2:Object, param3:Object) : Object
      {
         return "sge " + param1 + ", " + param2 + ", " + param3 + "\n";
      }
      
      public static function slt(param1:Object, param2:Object, param3:Object) : Object
      {
         return "slt " + param1 + ", " + param2 + ", " + param3 + "\n";
      }
      
      public static function mov(param1:Object, param2:Object) : Object
      {
         return "mov " + param1 + ", " + param2 + "\n";
      }
      
      public static function frc(param1:Object, param2:Object) : Object
      {
         return "frc " + param1 + ", " + param2 + "\n";
      }
      
      public static function lerp(param1:Object, param2:Object, param3:Object, param4:Object) : Object
      {
         var _loc5_:Object = "";
         _loc5_ = _loc5_ + sub(param1,param3,param2);
         _loc5_ = _loc5_ + mul(param1,param1,param4);
         return _loc5_ + add(param1,param1,param2);
      }
   }
}

