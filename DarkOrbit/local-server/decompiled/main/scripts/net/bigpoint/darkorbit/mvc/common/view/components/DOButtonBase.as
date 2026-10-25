package net.bigpoint.darkorbit.mvc.common.view.components
{
   import spark.components.Button;
   
   public class DOButtonBase extends Button
   {
      
      private static var _skinParts:Object = {
         "labelDisplay":false,
         "iconDisplay":false
      };
      
      public function DOButtonBase()
      {
         super();
         focusEnabled = false;
      }
   }
}

