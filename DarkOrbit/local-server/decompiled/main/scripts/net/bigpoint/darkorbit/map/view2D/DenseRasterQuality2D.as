package net.bigpoint.darkorbit.map.view2D
{
   import flash.display.Stage;
   import flash.display.StageQuality;
   
   public final class DenseRasterQuality2D
   {
      
      private static var owner:Stage;
      
      private static var previous:String;
      
      private static var applied:String;
      
      public function DenseRasterQuality2D()
      {
         super();
      }
      
      public static function update(param1:Stage, param2:Boolean) : void
      {
         if(Boolean(owner) && owner !== param1)
         {
            clear();
         }
         if(!param2)
         {
            clear();
            return;
         }
         if(!param1 || Boolean(owner))
         {
            return;
         }
         var _loc3_:String = param1.quality.toLowerCase();
         if(_loc3_ != "high" && _loc3_ != "best")
         {
            return;
         }
         previous = param1.quality;
         owner = param1;
         param1.quality = StageQuality.LOW;
         applied = param1.quality;
      }
      
      public static function clear() : void
      {
         if(Boolean(owner) && owner.quality == applied)
         {
            owner.quality = previous;
         }
         owner = null;
         previous = null;
         applied = null;
      }
   }
}

