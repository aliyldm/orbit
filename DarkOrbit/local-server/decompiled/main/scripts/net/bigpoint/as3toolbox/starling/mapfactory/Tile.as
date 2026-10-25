package net.bigpoint.as3toolbox.starling.mapfactory
{
   import starling.display.Image;
   
   public class Tile
   {
      
      public var id:int;
      
      internal var xOffset:int;
      
      internal var yOffset:int;
      
      internal var image:Image;
      
      public function Tile(param1:int, param2:Image)
      {
         super();
         this.id = param1;
         this.image = param2;
      }
   }
}

