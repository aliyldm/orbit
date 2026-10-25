package net.bigpoint.darkorbit.items.item.attributes
{
   public class HangarSlotAttributes extends GeneralAttributes
   {
      
      public var maxSlots:int;
      
      public var switchCooldownDefault:int;
      
      public var switchCooldownPremium:int;
      
      public var slotCosts:Vector.<HangarPrice> = new Vector.<HangarPrice>();
      
      public var costTypes:Vector.<String> = new Vector.<String>();
      
      public function HangarSlotAttributes()
      {
         super();
      }
   }
}

