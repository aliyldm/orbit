package net.bigpoint.darkorbit.fui.components.core.layout
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   
   public class AlignmentLayout extends AbstractAlignmentLayout implements ILayout
   {
      
      protected var _forceRedraws:Array = [InvalidationType.POSITION,InvalidationType.SIZE];
      
      public function AlignmentLayout(param1:Array = null)
      {
         super();
         if(param1)
         {
            this._forceRedraws = param1;
         }
      }
      
      public function execute(param1:DisplayObjectContainer = null) : void
      {
         var _loc6_:ICoreponent = null;
         var _loc2_:uint = uint(param1.numChildren);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc6_ = param1.getChildAt(_loc3_) as ICoreponent;
            if(_loc6_)
            {
               _loc6_.setAlignmentActivation(Alignment.ACIVATE_HORIZONTAL,true);
               _loc6_.setAlignmentActivation(Alignment.ACIVATE_VERTICAL,true);
               _loc6_.forceRedraws(this._forceRedraws,true);
            }
            _loc3_++;
         }
         var _loc4_:Container = param1 as Container;
         var _loc5_:Boolean = false;
         if(_loc4_)
         {
            if(_loc4_.isAutoSizeMode(LayoutAutoSizeMode.CHILDREN_WIDTH))
            {
               _loc4_.width = _loc4_.getCalculatedWidth();
               _loc5_ = true;
            }
            if(_loc4_.isAutoSizeMode(LayoutAutoSizeMode.CHILDREN_HEIGHT))
            {
               _loc4_.height = _loc4_.getCalculatedHeight();
               _loc5_ = true;
            }
         }
         if(_loc5_)
         {
            _loc4_.dispatchEvent(new Event(Coreponent.EVENT_CHILDRENSIZE_FORCE_TO_RESIZE));
         }
      }
   }
}

