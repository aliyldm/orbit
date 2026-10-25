package net.bigpoint.darkorbit.mvc.common.utils
{
   import flash.display.Sprite;
   
   public class Scale9GridUtils
   {
      
      private static var TL:String = "tl";
      
      private static var TC:String = "tc";
      
      private static var TR:String = "tr";
      
      private static var CL:String = "cl";
      
      private static var C:String = "c";
      
      private static var CR:String = "cr";
      
      private static var BL:String = "bl";
      
      private static var BC:String = "bc";
      
      private static var BR:String = "br";
      
      public function Scale9GridUtils()
      {
         super();
      }
      
      public static function setWidth(param1:Sprite, param2:uint) : void
      {
         var _loc3_:uint = uint(param1[TL].width);
         var _loc4_:uint = uint(param1[TR].width);
         var _loc5_:int = param2 - (_loc3_ + _loc4_);
         param1[TC].width = _loc5_;
         param1[C].width = _loc5_;
         param1[BC].width = _loc5_;
         var _loc6_:int = _loc5_ + _loc3_;
         param1[TR].x = _loc6_;
         param1[CR].x = _loc6_;
         param1[BR].x = _loc6_;
      }
      
      public static function setHeight(param1:Sprite, param2:uint) : void
      {
         var _loc3_:uint = uint(param1[TL].height);
         var _loc4_:uint = uint(param1[TC].height);
         var _loc5_:int = param2 - (_loc3_ + _loc4_);
         param1[CL].height = _loc5_;
         param1[C].height = _loc5_;
         param1[CR].height = _loc5_;
         var _loc6_:int = _loc5_ + _loc3_;
         param1[BR].y = _loc6_;
         param1[BC].y = _loc6_;
         param1[BL].y = _loc6_;
      }
   }
}

