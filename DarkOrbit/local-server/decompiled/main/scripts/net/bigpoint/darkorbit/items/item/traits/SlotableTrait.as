package net.bigpoint.darkorbit.items.item.traits
{
   import net.bigpoint.darkorbit.items.item.vo.*;
   
   public class SlotableTrait extends AbstractTrait
   {
      
      public static const TYPE:String = "slotable";
      
      public var maxQuantity:int;
      
      public var slots:Vector.<Slot> = new Vector.<Slot>();
      
      public function SlotableTrait()
      {
         super();
         super.type = TYPE;
      }
      
      public function push(param1:Slot) : void
      {
         this.slots.push(param1);
      }
   }
}

