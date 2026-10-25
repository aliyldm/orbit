package net.bigpoint.darkorbit.catalog
{
   public class SysItem
   {
      
      public var name:String;
      
      public var category:String;
      
      public function SysItem(param1:String, param2:String, param3:String, param4:String = "")
      {
         super();
         this.name = param2;
         this.category = param4;
      }
   }
}

