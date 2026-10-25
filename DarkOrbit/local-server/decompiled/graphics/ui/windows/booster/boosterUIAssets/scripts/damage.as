package
{
   import flash.display.BitmapData;
   
   [Embed(source="/_assets/36_damage.jpg")]
   public dynamic class damage extends BitmapData
   {
      
      public function damage(param1:int = 30, param2:int = 30)
      {
         super(param1,param2);
      }
   }
}

