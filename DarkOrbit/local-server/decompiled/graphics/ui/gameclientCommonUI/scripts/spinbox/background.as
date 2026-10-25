package spinbox
{
   import flash.display.BitmapData;
   
   [Embed(source="/_assets/11_spinbox.background.png")]
   public dynamic class background extends BitmapData
   {
      
      public function background(param1:int = 9, param2:int = 17)
      {
         super(param1,param2);
      }
   }
}

