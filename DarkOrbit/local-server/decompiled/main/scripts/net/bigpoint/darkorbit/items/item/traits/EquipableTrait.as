package net.bigpoint.darkorbit.items.item.traits
{
   import net.bigpoint.darkorbit.items.item.attributes.*;
   
   public class EquipableTrait extends AbstractTrait
   {
      
      public static const TYPE:String = "equipable";
      
      public var entities:Vector.<String> = new Vector.<String>();
      
      public var boostList:Vector.<Boost> = new Vector.<Boost>();
      
      public function EquipableTrait()
      {
         super();
         super.type = TYPE;
      }
   }
}

