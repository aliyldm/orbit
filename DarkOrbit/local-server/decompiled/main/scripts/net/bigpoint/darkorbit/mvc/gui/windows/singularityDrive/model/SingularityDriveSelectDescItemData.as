package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model
{
   public class SingularityDriveSelectDescItemData
   {
      
      private var _index:int;
      
      public function SingularityDriveSelectDescItemData(param1:int)
      {
         super();
         this._index = param1;
      }
      
      public function get index() : int
      {
         return this._index;
      }
   }
}

