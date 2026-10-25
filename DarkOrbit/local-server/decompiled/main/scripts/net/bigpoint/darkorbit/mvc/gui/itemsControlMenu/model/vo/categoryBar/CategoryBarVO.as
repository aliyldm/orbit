package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.categoryBar
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.HorizontalListLayout;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.vo.AbstractMenuBarVO;
   
   public class CategoryBarVO extends AbstractMenuBarVO
   {
      
      private var _categories:Vector.<CategoryVO>;
      
      public function CategoryBarVO(param1:String, param2:PointLite, param3:Vector.<CategoryVO>)
      {
         super(param1,HorizontalListLayout.ID,param2);
         this._categories = param3;
      }
      
      public function get categories() : Vector.<CategoryVO>
      {
         return this._categories;
      }
   }
}

