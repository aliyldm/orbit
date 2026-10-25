package net.bigpoint.darkorbit.map.view2D.effects
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.map.view2D.DenseEffectPolicy2D;
   
   public class CompactEffectGeometry2D
   {
      
      public static var beams:uint = 0;
      
      public static var bursts:uint = 0;
      
      public static var areas:uint = 0;
      
      public function CompactEffectGeometry2D()
      {
         super();
      }
      
      public static function beam(param1:DisplayObject) : void
      {
         if(DenseEffectPolicy2D.denseScene)
         {
            param1.scaleY *= 0.4;
            ++beams;
         }
      }
      
      public static function burst(param1:DisplayObject) : void
      {
         if(DenseEffectPolicy2D.denseScene)
         {
            param1.scaleX *= 0.6;
            param1.scaleY *= 0.6;
            ++bursts;
         }
      }
      
      public static function area(param1:Sprite, param2:DisplayObject, param3:String) : void
      {
         if(!DenseEffectPolicy2D.denseScene)
         {
            return;
         }
         param2.scaleX *= 0.45;
         param2.scaleY *= 0.45;
         ++areas;
      }
   }
}

