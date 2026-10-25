package net.bigpoint.darkorbit.items.item.attributes
{
   public class RecipeAttributes extends GeneralAttributes
   {
      
      public var usingStrategy:String;
      
      public var stackable:Boolean;
      
      public var result:Vector.<BuildPart> = new Vector.<BuildPart>(0);
      
      public var targets:Vector.<String> = new Vector.<String>(0);
      
      public var visibility:String;
      
      public var maxUses:int;
      
      public var costScalingFactor:Number;
      
      public var costs:Vector.<RecipeCosts> = new Vector.<RecipeCosts>(0);
      
      public function RecipeAttributes()
      {
         super();
      }
   }
}

