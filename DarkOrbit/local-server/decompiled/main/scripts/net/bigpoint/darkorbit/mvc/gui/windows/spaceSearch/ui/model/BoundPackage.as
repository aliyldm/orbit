package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model
{
   public class BoundPackage
   {
      
      public var lootID:String;
      
      public var title:String;
      
      public var rangeFrom:int;
      
      public var rangeTo:int;
      
      public var special:Boolean;
      
      public var lootAmount:int;
      
      public function BoundPackage(param1:String, param2:String, param3:int, param4:int, param5:int, param6:int)
      {
         super();
         this.lootID = param1;
         this.title = param2;
         this.rangeFrom = param3;
         this.rangeTo = param4;
         this.special = param5 == 2;
         this.lootAmount = param6;
      }
   }
}

