package net.bigpoint.darkorbit.mvc.common.view.components
{
   import spark.components.SkinnableContainer;
   
   public class DOViewContainerBase extends SkinnableContainer
   {
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      public function DOViewContainerBase()
      {
         super();
      }
   }
}

