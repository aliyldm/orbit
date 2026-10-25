package net.bigpoint.darkorbit.items.item.traits
{
   public class UpgradableTrait extends AbstractTrait
   {
      
      public static const TYPE:String = "upgradable";
      
      public var upgradeType:String;
      
      public var upgradeCurrency:String;
      
      public var bonusPerLevel:Number;
      
      public var levels:int;
      
      public var bonusCalculationType:String;
      
      public function UpgradableTrait()
      {
         super();
         super.type = TYPE;
      }
   }
}

