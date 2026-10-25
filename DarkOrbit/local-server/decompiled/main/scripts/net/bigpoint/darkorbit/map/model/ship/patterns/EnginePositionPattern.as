package net.bigpoint.darkorbit.map.model.ship.patterns
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.pattern.Pattern;
   
   public class EnginePositionPattern extends Pattern
   {
      
      public var enginePositions:Vector.<Vector.<PointLite>>;
      
      public var lowEnginePositions:Vector.<Vector.<PointLite>>;
      
      public function EnginePositionPattern(param1:Array, param2:Array = null)
      {
         super(0);
         this.enginePositions = Vector.<Vector.<PointLite>>(param1 || []);
         if(param2)
         {
            this.lowEnginePositions = Vector.<Vector.<PointLite>>(param2);
         }
      }
   }
}

