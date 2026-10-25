package spark.components
{
   import mx.core.mx_internal;
   import spark.components.supportClasses.ToggleButtonBase;
   
   use namespace mx_internal;
   
   public class ToggleButton extends ToggleButtonBase
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "iconDisplay":false,
         "labelDisplay":false
      };
      
      public function ToggleButton()
      {
         super();
      }
   }
}

