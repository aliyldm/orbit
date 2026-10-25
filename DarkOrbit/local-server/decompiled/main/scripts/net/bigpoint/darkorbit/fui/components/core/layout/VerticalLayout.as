package net.bigpoint.darkorbit.fui.components.core.layout
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.IContainer;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   
   public class VerticalLayout extends AbstractAlignmentLayout implements ILayout
   {
      
      public function VerticalLayout()
      {
         super();
      }
      
      public function execute(param1:DisplayObjectContainer = null) : void
      {
         var _loc4_:Boolean = false;
         this.container = param1;
         initChildrenMapping();
         prefilterAndAlignmentActivator(this.alignmentActivator);
         this.calculateChildrenSizes();
         var _loc2_:Container = this.container as Container;
         var _loc3_:Number = this.drawLayout();
         if(_loc2_)
         {
            _loc4_ = _loc2_.isAutoSizeMode(LayoutAutoSizeMode.CHILDREN_HEIGHT);
            if(_loc4_)
            {
               param1.height = _loc3_;
            }
            _loc2_.validate(InvalidationType.LAYOUT);
            _loc2_.dispatchEvent(new Event(Coreponent.EVENT_CHILDRENSIZE_FORCE_TO_RESIZE));
         }
      }
      
      protected function alignmentActivator(param1:ICoreponent) : void
      {
         param1.setAlignmentActivation(Alignment.ACIVATE_HORIZONTAL,true);
         param1.setAlignmentActivation(Alignment.ACIVATE_VERTICAL,false);
      }
      
      protected function calculateChildrenSizes() : void
      {
         var _loc1_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc9_:ICoreponent = null;
         childCount = allChildren.length;
         var _loc2_:uint = 0;
         var _loc4_:IContainer = container as IContainer;
         if(_loc4_)
         {
            _loc5_ = Number((container as IContainer).getCalculatedHeight());
         }
         else
         {
            _loc5_ = container.height;
         }
         var _loc6_:uint = childCount - 1;
         if(_loc6_ < 0)
         {
            _loc6_ = 0;
            remainingSize = _loc5_;
         }
         else
         {
            _loc7_ = _loc6_ * this.gap;
            remainingSize = _loc5_ - _loc7_;
         }
         _loc1_ = absoluteChildren.length;
         _loc3_ = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc9_ = absoluteChildren[_loc2_] as ICoreponent;
            if(_loc9_)
            {
               _loc9_.forceRedraw();
            }
            _loc3_ += absoluteChildren[_loc2_].height;
            _loc2_++;
         }
         remainingSizeAfterAbsolute = remainingSize - _loc3_;
         _loc3_ = 0;
         _loc1_ = relativeChildren.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ += (relativeChildren[_loc2_] as ICoreponent).relativeHeight * remainingSizeAfterAbsolute;
            _loc2_++;
         }
         remainingSizeAfterRelative = remainingSizeAfterAbsolute - _loc3_;
         var _loc8_:uint = fillChildren.length;
         if(_loc8_ > 0 && remainingSizeAfterRelative > 0)
         {
            fillElementSize = remainingSizeAfterRelative / _loc8_;
         }
      }
      
      protected function drawLayout() : Number
      {
         var _loc2_:ICoreponent = null;
         var _loc4_:ICoreponent = null;
         var _loc5_:Number = NaN;
         var _loc1_:Number = 0;
         var _loc3_:int = 0;
         for(; _loc3_ < childCount; _loc1_ += _loc2_ ? _loc2_.marginTop : 0,child.y = _loc1_,_loc1_ += child.height,_loc1_ += _gap,_loc1_ += _loc2_ ? _loc2_.marginBottom : 0,_loc3_++)
         {
            child = allChildren[_loc3_];
            _loc2_ = child as ICoreponent;
            if(!_loc2_)
            {
               continue;
            }
            _loc4_ = getSizeTypeRelatedChildrenVector(_loc2_).shift() as ICoreponent;
            switch(_loc4_.sizeHandling)
            {
               case Coreponent.SIZE_RELATIVE:
                  _loc5_ = _loc4_.relativeHeight * remainingSizeAfterAbsolute;
                  _loc4_.height = _loc5_;
                  _loc2_.invalidate(InvalidationType.SIZE);
                  break;
               case Coreponent.SIZE_FILL:
                  _loc4_.height = fillElementSize;
                  _loc2_.invalidate(InvalidationType.SIZE);
            }
         }
         _loc1_ -= _gap;
         return _loc1_ - (_loc2_ ? _loc2_.marginBottom : 0);
      }
   }
}

