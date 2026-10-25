package net.bigpoint.darkorbit.mvc.common.view.components
{
   import net.bigpoint.as3toolbox.guicomponents.components.Scale9GridImage;
   
   public class MyScale9GridImage extends Scale9GridImage
   {
      
      private static var _skinParts:Object = {
         "upperRightImage":true,
         "lowerLeftImage":true,
         "lowerRightImage":true,
         "upperLeftImage":true,
         "middleLeftImage":true,
         "middleCenterImage":true,
         "lowerCenterImage":true,
         "upperCenterImage":true,
         "middleRightImage":true
      };
      
      public function MyScale9GridImage()
      {
         super();
      }
      
      override public function set source(param1:*) : void
      {
         if(param1 != null)
         {
            super.source = param1;
         }
      }
   }
}

