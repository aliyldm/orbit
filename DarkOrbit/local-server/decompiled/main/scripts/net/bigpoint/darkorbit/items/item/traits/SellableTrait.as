package net.bigpoint.darkorbit.items.item.traits
{
   public class SellableTrait extends AbstractTrait
   {
      
      public static const TYPE:String = "sellable";
      
      public var costTypes:Vector.<String> = new Vector.<String>();
      
      public var credits:Number = 0;
      
      public var uridium:Number = 0;
      
      public function SellableTrait()
      {
         super();
         super.type = TYPE;
      }
   }
}

