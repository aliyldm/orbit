package
{
   import flash.display.BitmapData;
   
   [Embed(source="/_assets/350_damage.png")]
   public dynamic class damage extends BitmapData
   {
      
      public function damage(param1:int = 100, param2:int = 100)
      {
         super(param1,param2);
      }
   }
}

