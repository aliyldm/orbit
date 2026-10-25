package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.dragPreview
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   
   public class DragPreviewRounded extends DragPreview
   {
      
      private static const LINKAGE:String = "slotAndItemDragPreviewRounded";
      
      public function DragPreviewRounded(param1:SWFFinisher, param2:Bitmap)
      {
         super(param1,param2);
      }
      
      override public function get symbolLinkage() : String
      {
         return LINKAGE;
      }
   }
}

