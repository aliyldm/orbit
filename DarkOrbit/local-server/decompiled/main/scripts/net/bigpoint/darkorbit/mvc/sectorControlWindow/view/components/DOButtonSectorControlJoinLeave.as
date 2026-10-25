package net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components
{
   import net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase;
   
   public class DOButtonSectorControlJoinLeave extends DOButtonBase
   {
      
      private static var _skinParts:Object = {
         "labelDisplay":false,
         "iconDisplay":false
      };
      
      public var state:String = "join";
      
      public function DOButtonSectorControlJoinLeave()
      {
         super();
      }
   }
}

