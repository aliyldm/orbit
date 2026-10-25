package net.bigpoint.darkorbit.mvc.commandCenter.view
{
   import com.bigpoint.utils.TimeFormatter;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.CommandCenterNewsVO;
   import net.bigpoint.darkorbit.mvc.commandCenter.view.builder.CommandCenterNewBuilder;
   import net.bigpoint.darkorbit.mvc.commandCenter.view.builder.CommandCenterNewsContainer;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class CommandCenterSlideShowAssigner extends DefaultItemDataAssigner
   {
      
      private var _view:CommandCenterNewsContainer;
      
      public function CommandCenterSlideShowAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         this.removeListeners();
         super.data = param1;
         var _loc2_:CommandCenterNewsVO = param1 as CommandCenterNewsVO;
         if(_loc2_)
         {
            if(this._view)
            {
               this._view.dispose();
               MovieClipUtils.removeDisplayObject(this._view);
            }
            ++_loc2_.clickCount;
            this._view = CommandCenterNewBuilder.instance.build(_loc2_.data);
            if(this._view)
            {
               addChild(this._view);
               this.addListeners();
            }
         }
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
      }
      
      private function removeListeners() : void
      {
         var _loc1_:CommandCenterNewsVO = data as CommandCenterNewsVO;
         if(_loc1_)
         {
            _loc1_.timer.changed.remove(this.updateTime);
         }
      }
      
      private function addListeners() : void
      {
         var _loc1_:CommandCenterNewsVO = data as CommandCenterNewsVO;
         if(_loc1_)
         {
            _loc1_.timer.changed.add(this.updateTime);
            this.updateTime();
         }
      }
      
      private function updateTime() : void
      {
         var _loc1_:CommandCenterNewsVO = null;
         if(this._view)
         {
            _loc1_ = data as CommandCenterNewsVO;
            if(_loc1_)
            {
               this._view.updateTime(TimeFormatter.getSmartFormatedTime(_loc1_.timer.value));
            }
         }
      }
   }
}

