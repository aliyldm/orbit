package net.bigpoint.darkorbit.mvc.gui.highlights.controller
{
   import net.bigpoint.darkorbit.com.module.HighlightTypeModule;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightProxy;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.UpdateHighlightItemModel;
   import net.bigpoint.darkorbit.mvc.gui.highlights.view.IHighLighter;
   import net.bigpoint.darkorbit.mvc.gui.highlights.view.ProgressBarHighlighter;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UpdateItemHighlightCommand extends DOAbstractSimpleCommand
   {
      
      public function UpdateItemHighlightCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:UpdateHighlightItemModel = null;
         var _loc3_:HighlightProxy = null;
         var _loc4_:Vector.<IHighLighter> = null;
         var _loc5_:ProgressBarHighlighter = null;
         var _loc6_:int = 0;
         super.execute(param1);
         _loc2_ = param1.getBody() as UpdateHighlightItemModel;
         _loc3_ = retrieveProxy(HighlightProxy.NAME) as HighlightProxy;
         if(_loc3_.hasHighlighterOfType(_loc2_.highlightItemVO))
         {
            switch(_loc2_.highlightItemVO.highlighterType)
            {
               case HighlightTypeModule.HIGHLIGHTTYPE_PROGRESS_BAR:
                  _loc4_ = _loc3_.getAllHighlightersByVo(_loc2_.highlightItemVO);
                  _loc5_ = null;
                  _loc6_ = 0;
                  while(_loc6_ < _loc4_.length)
                  {
                     if(_loc4_[_loc6_].vo.highlighterType == _loc2_.highlightItemVO.highlighterType)
                     {
                        _loc5_ = _loc4_[_loc6_] as ProgressBarHighlighter;
                     }
                     _loc6_++;
                  }
                  if(_loc5_ != null)
                  {
                     _loc5_.updateValue(_loc2_.newValue as Number);
                  }
            }
         }
      }
   }
}

