package net.bigpoint.darkorbit.items.item.attributes
{
   public class GeneralAttributes
   {
      
      public var lootId:String;
      
      public var name:String;
      
      public var typeClass:String;
      
      public var typeValue:String;
      
      public var group:String;
      
      public var parentGroup:String;
      
      public var maxQuantity:uint = 0;
      
      public var uridium:Number = 0;
      
      public var credits:Number = 0;
      
      public var levels:Array;
      
      public var isFractionDependent:Boolean = false;
      
      public var damage:Number = 0;
      
      public var abilities:Vector.<Ability> = null;
      
      public function GeneralAttributes()
      {
         super();
      }
   }
}

