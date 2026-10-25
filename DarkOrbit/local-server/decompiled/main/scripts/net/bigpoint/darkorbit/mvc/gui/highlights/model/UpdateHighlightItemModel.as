package net.bigpoint.darkorbit.mvc.gui.highlights.model
{
   public class UpdateHighlightItemModel
   {
      
      private var _highlightItemVO:HighlightItemVO;
      
      private var _newValue:Object;
      
      public function UpdateHighlightItemModel(param1:HighlightItemVO, param2:Object)
      {
         super();
         this._highlightItemVO = param1;
         this._newValue = param2;
      }
      
      public function get highlightItemVO() : HighlightItemVO
      {
         return this._highlightItemVO;
      }
      
      public function get newValue() : Object
      {
         return this._newValue;
      }
   }
}

