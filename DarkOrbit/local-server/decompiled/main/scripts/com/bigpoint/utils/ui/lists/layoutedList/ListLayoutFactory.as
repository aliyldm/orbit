package com.bigpoint.utils.ui.lists.layoutedList
{
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.AbstractListLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.HorizontalGridLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.HorizontalListLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.ProActionHorizontalGridLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.ProActionVerticalGridLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.VerticalGridLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.VerticallListLayout;
   
   public class ListLayoutFactory
   {
      
      public function ListLayoutFactory()
      {
         super();
      }
      
      public static function getLayout(param1:String) : AbstractListLayout
      {
         switch(param1)
         {
            case HorizontalListLayout.ID:
               return new HorizontalListLayout();
            case HorizontalGridLayout.ID:
               return new HorizontalGridLayout();
            case VerticallListLayout.ID:
               return new VerticallListLayout();
            case VerticalGridLayout.ID:
               return new VerticalGridLayout();
            case ProActionHorizontalGridLayout.ID:
               return new ProActionHorizontalGridLayout();
            case ProActionVerticalGridLayout.ID:
               return new ProActionVerticalGridLayout();
            default:
               throw new Error("ListLayoutFactory, no layout specified for layoutId: " + param1);
         }
      }
   }
}

