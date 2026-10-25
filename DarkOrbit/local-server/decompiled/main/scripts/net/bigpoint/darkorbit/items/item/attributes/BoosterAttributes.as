package net.bigpoint.darkorbit.items.item.attributes
{
   public class BoosterAttributes extends GeneralAttributes
   {
      
      public var boosterId:int;
      
      public var shared:Boolean;
      
      public var realTime:Boolean;
      
      public var hours:int;
      
      public var eventBooster:Boolean;
      
      public var subscription:Boolean;
      
      public var boostList:Vector.<Boost> = new Vector.<Boost>();
      
      public var salvageEffects:Vector.<SalvageEffect> = new Vector.<SalvageEffect>();
      
      public var categories:Vector.<String> = new Vector.<String>();
      
      public function BoosterAttributes()
      {
         super();
      }
   }
}

