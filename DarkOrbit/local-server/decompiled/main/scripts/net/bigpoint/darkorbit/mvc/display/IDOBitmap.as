package net.bigpoint.darkorbit.mvc.display
{
   import flash.geom.Rectangle;
   
   public interface IDOBitmap extends IDODisplayObject
   {
      
      function set texture(param1:Object) : void;
      
      function setSubtexture(param1:Object, param2:Rectangle) : void;
   }
}

