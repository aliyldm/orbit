package net.bigpoint.darkorbit.items.item.traits
{
   public class RepairableTrait extends AbstractTrait
   {
      
      public static const TYPE:String = "repairable";
      
      public var baseCost:Number = 0;
      
      public var premiumCost:Number = 0;
      
      public var durability:Number = 0;
      
      public var currency:String;
      
      public var costIncreasePerLevel:Number = 0;
      
      public function RepairableTrait()
      {
         super();
         super.type = TYPE;
      }
   }
}

