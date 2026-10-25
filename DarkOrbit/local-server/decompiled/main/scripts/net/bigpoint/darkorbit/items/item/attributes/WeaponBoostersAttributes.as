package net.bigpoint.darkorbit.items.item.attributes
{
   import net.bigpoint.darkorbit.items.item.vo.*;
   
   public class WeaponBoostersAttributes extends GeneralAttributes
   {
      
      public var itemId:int;
      
      public var category:String;
      
      public var boosterTypes:Vector.<AcceptedType> = new Vector.<AcceptedType>();
      
      public function WeaponBoostersAttributes()
      {
         super();
      }
      
      public function push(param1:AcceptedType) : void
      {
         this.boosterTypes.push(param1);
      }
   }
}

