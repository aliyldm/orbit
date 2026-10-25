package net.bigpoint.darkorbit.mvc.questWindow.model.vo
{
   public class QuestFilterType
   {
      
      public static const UNDEFINED:int = -1;
      
      public static const AVAILABLE:int = 1;
      
      public static const COMPLETED:int = 2;
      
      public static const UNAVAILABLE:int = 3;
      
      public static const INLEVELRANGE:int = 4;
      
      public static const ATTEMPTED:int = 5;
      
      public static const UNATTEMPTED:int = 6;
      
      public var value:int = -1;
      
      public function QuestFilterType(param1:int)
      {
         super();
         this.value = param1;
      }
   }
}

