package net.bigpoint.darkorbit.fui.components.list.itemslotbar
{
   public interface ISlotsetVO
   {
      
      function get size() : uint;
      
      function get list() : Vector.<Object>;
      
      function get acceptedTypesAsArray() : Array;
      
      function get name() : String;
   }
}

