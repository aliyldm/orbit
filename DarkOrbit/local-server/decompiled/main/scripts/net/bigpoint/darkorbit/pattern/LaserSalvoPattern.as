package net.bigpoint.darkorbit.pattern
{
   public class LaserSalvoPattern
   {
      
      public var laserClass:int;
      
      public var type:int;
      
      public var laserPatternsUsed:Array = [];
      
      public function LaserSalvoPattern(param1:int, param2:int)
      {
         super();
         this.laserClass = param1;
         this.type = param2;
      }
      
      public function addLaserSalvo(param1:LaserPattern) : void
      {
         this.laserPatternsUsed.push(param1);
      }
   }
}

