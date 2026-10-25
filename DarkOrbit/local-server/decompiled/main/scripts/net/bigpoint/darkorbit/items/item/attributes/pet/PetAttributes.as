package net.bigpoint.darkorbit.items.item.attributes.pet
{
   import net.bigpoint.darkorbit.items.item.attributes.GeneralAttributes;
   
   public class PetAttributes extends GeneralAttributes
   {
      
      public var hitpoints:int;
      
      public var experience:int;
      
      public var repairCostsUridium:Number;
      
      public var repairCostsCredits:Number;
      
      public var benefitsAccessibleEquipmentLevel:int;
      
      public var benefitsAdditionalDamage:int;
      
      public var benefitsAdditionalShield:int;
      
      public function PetAttributes()
      {
         super();
      }
   }
}

