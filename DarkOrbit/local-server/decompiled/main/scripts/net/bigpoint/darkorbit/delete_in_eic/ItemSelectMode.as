package net.bigpoint.darkorbit.delete_in_eic
{
   public class ItemSelectMode
   {
      
      public static const ALL:ItemSelectMode = new ItemSelectMode();
      
      public static const NOT_EQUIPPED:ItemSelectMode = new ItemSelectMode();
      
      public static const ONLY_EQUIPPED:ItemSelectMode = new ItemSelectMode();
      
      public function ItemSelectMode()
      {
         super();
         if(Boolean(ALL) && Boolean(NOT_EQUIPPED) && Boolean(ONLY_EQUIPPED))
         {
            throw new Error("don\'t instantiate this class");
         }
      }
   }
}

