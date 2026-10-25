package
{
   import flash.display.BitmapData;
   
   [Embed(source="/_assets/6_hitpoints.jpg")]
   public dynamic class hitpoints extends BitmapData
   {
      
      public function hitpoints(param1:int = 30, param2:int = 30)
      {
         super(param1,param2);
      }
   }
}

