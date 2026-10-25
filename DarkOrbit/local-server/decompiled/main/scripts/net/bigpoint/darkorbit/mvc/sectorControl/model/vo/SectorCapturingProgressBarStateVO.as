package net.bigpoint.darkorbit.mvc.sectorControl.model.vo
{
   public class SectorCapturingProgressBarStateVO
   {
      
      public static const DIRECTION_UNKNOWN:int = 0;
      
      public static const DIRECTION_CAPTURING:int = 1;
      
      public static const DIRECTION_NEUTRALIZING:int = 2;
      
      public var participatingSector:String = null;
      
      public var faction:int = 0;
      
      public var direction:int = 0;
      
      public var progress:Number = 0;
      
      public function SectorCapturingProgressBarStateVO(param1:String = null, param2:int = 0, param3:int = 0, param4:Number = 0)
      {
         super();
         this.participatingSector = param1;
         this.direction = param2;
         this.faction = param3;
         this.progress = param4;
      }
   }
}

