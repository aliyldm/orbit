package
{
   import flash.display.BitmapData;
   
   [Embed(source="/_assets/28_hitpoints.png")]
   public dynamic class hitpoints extends BitmapData
   {
      
      public function hitpoints(param1:int = 30, param2:int = 30)
      {
         super(param1,param2);
      }
   }
}

