package net.bigpoint.darkorbit.fui.components.list.dropdownbox
{
   import flash.filters.DropShadowFilter;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   
   public class StringItemDataAssigner extends DefaultItemDataAssigner
   {
      
      public function StringItemDataAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         if(label)
         {
            label.text = String(param1);
         }
      }
      
      override protected function drawSelection() : void
      {
         super.drawSelection();
         if(_selected)
         {
            label.filters = [new DropShadowFilter()];
         }
         else
         {
            label.filters = [];
         }
      }
   }
}

