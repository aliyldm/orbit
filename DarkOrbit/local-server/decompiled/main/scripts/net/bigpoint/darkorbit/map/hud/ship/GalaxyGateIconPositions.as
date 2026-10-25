package net.bigpoint.darkorbit.map.hud.ship
{
   import com.bigpoint.utils.PointLite;
   
   public class GalaxyGateIconPositions
   {
      
      public static const ALPHA:int = 0;
      
      public static const BETA:int = 1;
      
      public static const GAMMA:int = 2;
      
      public static const DELTA:int = 3;
      
      public static const EPSILON:int = 4;
      
      public static const ZETA:int = 5;
      
      public static const KRONOS:int = 6;
      
      private static const alphaIconPosition:PointLite = new PointLite(0,6);
      
      private static const betaIconPosition:PointLite = new PointLite(6,6);
      
      private static const gammaIconPosition:PointLite = new PointLite(12,6);
      
      private static const deltaIconPosition:PointLite = new PointLite(6,0);
      
      private static const epsilonIconPosition:PointLite = new PointLite(0,0);
      
      private static const zetaIconPosition:PointLite = new PointLite(12,0);
      
      private static const kronosIconPosition:PointLite = new PointLite(0,0);
      
      private static const alphaToDeltaAsset:String = "alphaToDelta_gg";
      
      private static const epsilonZetaAsset:String = "epsilonZeta_gg";
      
      private static const kronosAsset:String = "kronos_gg";
      
      public static const resKeyFromID:Array = [alphaToDeltaAsset,alphaToDeltaAsset,alphaToDeltaAsset,alphaToDeltaAsset,epsilonZetaAsset,epsilonZetaAsset,kronosAsset];
      
      public static const galaxyGateIconsPositionMap:Array = [alphaIconPosition,betaIconPosition,gammaIconPosition,deltaIconPosition,epsilonIconPosition,zetaIconPosition,kronosIconPosition];
      
      public static const NUMBER_OF_GATES:int = galaxyGateIconsPositionMap.length;
      
      public function GalaxyGateIconPositions()
      {
         super();
      }
   }
}

