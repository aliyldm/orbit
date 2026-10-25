package net.bigpoint.darkorbit.mvc.sectorControl.model.vo
{
   import com.bigpoint.utils.PointLite;
   import flash.utils.Dictionary;
   
   public class SectorControlStateVO
   {
      
      public var ticketsLeft:Vector.<PointLite> = new Vector.<PointLite>(4);
      
      public var playerAmounts:Vector.<PointLite> = new Vector.<PointLite>(4);
      
      public var bonusses:Vector.<Dictionary> = new Vector.<Dictionary>(4);
      
      public var controlPoints:Dictionary = new Dictionary();
      
      public function SectorControlStateVO()
      {
         super();
      }
   }
}

