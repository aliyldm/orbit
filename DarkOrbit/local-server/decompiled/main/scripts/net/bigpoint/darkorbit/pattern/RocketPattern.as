package net.bigpoint.darkorbit.pattern
{
   public class RocketPattern extends AudibleResourcePattern
   {
      
      public static const R310:int = 1;
      
      public static const PLT_2026:int = 2;
      
      public static const PLT_2021:int = 3;
      
      public static const PLT_3030:int = 4;
      
      public static const PLD_8:int = 5;
      
      public static const WIZ:int = 6;
      
      public static const HSTRM01:int = 7;
      
      public static const UBR100:int = 8;
      
      public static const ECO10:int = 9;
      
      public static const ECO10_CPU:int = 52;
      
      public static const DCR_250:int = 10;
      
      public static const BDR_1211:int = 11;
      
      public static const SAR_01:int = 12;
      
      public static const SAR_02:int = 13;
      
      public static const CBR:int = 14;
      
      public static const BDR_1212:int = 16;
      
      public static const R_IC3:int = 18;
      
      public static const PIR_100:int = 19;
      
      public static const EMP_01:int = 40;
      
      public static const BEZIER:int = 200;
      
      public static const OBR_100:int = 27;
      
      public function RocketPattern(param1:int, param2:String)
      {
         super(param1,param2);
      }
      
      public function toString() : String
      {
         return "RocketPattern id:" + patternID + " resKey:" + resKey;
      }
   }
}

