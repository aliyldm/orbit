package net.bigpoint.darkorbit.map.view3D.settings
{
   public class AbstractSettings
   {
      
      public function AbstractSettings()
      {
         super();
      }
      
      protected function parseInt(param1:*, param2:int) : int
      {
         return param1 === undefined ? param2 : int(param1);
      }
      
      protected function parseUint(param1:*, param2:uint) : uint
      {
         return param1 === undefined ? param2 : uint(param1);
      }
      
      protected function parseBoolean(param1:*, param2:Boolean) : Boolean
      {
         return param1 === undefined ? param2 : Boolean(param1);
      }
      
      protected function parseNumber(param1:*, param2:Number) : Number
      {
         return param1 === undefined ? param2 : Number(param1);
      }
   }
}

