package net.bigpoint.darkorbit.items.item.traits
{
   public class StackableTrait extends AbstractTrait
   {
      
      public static const TYPE:String = "stackable";
      
      public var maxQuantity:Number = 2147483647;
      
      public function StackableTrait()
      {
         super();
         super.type = TYPE;
      }
   }
}

