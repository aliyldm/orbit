package net.bigpoint.darkorbit.items.item.attributes
{
   public class RecipeCosts
   {
      
      public var level:int;
      
      public var buildTimeSec:int;
      
      public var parts:Vector.<BuildPart> = new Vector.<BuildPart>(0);
      
      public var skipCosts:Vector.<BuildPart> = new Vector.<BuildPart>(0);
      
      public function RecipeCosts()
      {
         super();
      }
   }
}

