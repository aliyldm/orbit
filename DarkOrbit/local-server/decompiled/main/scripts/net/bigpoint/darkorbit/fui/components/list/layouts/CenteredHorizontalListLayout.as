package net.bigpoint.darkorbit.fui.components.list.layouts
{
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   
   public class CenteredHorizontalListLayout extends HorizontalItemListLayout
   {
      
      public function CenteredHorizontalListLayout(param1:Container = null, param2:Container = null)
      {
         super(param1,param2);
      }
      
      override protected function layoutItems() : void
      {
         var _loc2_:ICoreponent = null;
         var _loc3_:int = 0;
         var _loc1_:uint = uint(getVisibleItemsCount());
         var _loc4_:int = _target.getCalculatedWidth();
         if(_loc4_ < sigmaItemSize * _loc1_)
         {
            super.layoutItems();
            return;
         }
         var _loc5_:int = _loc4_ / 2 - (_loc1_ - 1) * sigmaItemSize * 0.5 - sigmaItemSize * 0.5;
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = _itemsContainer.getChildAt(_loc3_) as ICoreponent;
            _loc2_.x = _loc5_ + sigmaItemSize * _loc3_;
            _loc2_.forceRedraw(InvalidationType.POSITION);
            _loc3_++;
         }
      }
   }
}

