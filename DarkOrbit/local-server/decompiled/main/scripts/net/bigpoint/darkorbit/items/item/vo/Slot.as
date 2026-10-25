package net.bigpoint.darkorbit.items.item.vo
{
   public class Slot
   {
      
      public var name:String;
      
      public var slotsetType:String;
      
      public var size:uint;
      
      public var acceptedTypes:Vector.<AcceptedType> = new Vector.<AcceptedType>();
      
      public function Slot()
      {
         super();
      }
      
      public function push(param1:AcceptedType) : void
      {
         this.acceptedTypes.push(param1);
      }
   }
}

