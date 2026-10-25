package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo
{
   public class SynthesisStartLevelUtil
   {
      
      public static const NO_FILTER:int = -1;
      
      public static const MAX_START_LEVEL:int = 5;
      
      public function SynthesisStartLevelUtil()
      {
         super();
      }
      
      public static function hasStartLevel(param1:Object) : Boolean
      {
         return param1 != null && "startLevel" in param1;
      }
      
      public static function hasServerStar(param1:Object) : Boolean
      {
         return param1 != null && "star" in param1;
      }
      
      public static function normalize(param1:Object) : int
      {
         if(!hasStartLevel(param1))
         {
            return 0;
         }
         return normalizeValue(Number(param1["startLevel"]));
      }
      
      public static function normalizeServerStar(param1:Object) : int
      {
         if(!hasServerStar(param1))
         {
            return 0;
         }
         return normalizeValue(Number(param1["star"]));
      }
      
      public static function hasMappedStartLevel(param1:Object) : Boolean
      {
         return hasStartLevel(param1) || hasServerStar(param1);
      }
      
      public static function normalizeMappedStartLevel(param1:Object) : int
      {
         if(hasServerStar(param1))
         {
            return normalizeServerStar(param1);
         }
         return normalize(param1);
      }
      
      private static function normalizeValue(param1:Number) : int
      {
         if(isNaN(param1) || param1 <= 0)
         {
            return 0;
         }
         return Math.min(int(param1),MAX_START_LEVEL);
      }
   }
}

