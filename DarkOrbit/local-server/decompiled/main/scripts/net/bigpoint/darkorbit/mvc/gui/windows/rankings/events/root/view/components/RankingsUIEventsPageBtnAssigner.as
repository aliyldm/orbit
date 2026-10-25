package net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.view.components
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.model.vo.RankingsUIEventsPageBtnVO;
   
   public class RankingsUIEventsPageBtnAssigner extends DefaultItemDataAssigner
   {
      
      private var _btn:Button;
      
      public function RankingsUIEventsPageBtnAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._btn = FuiComponentSelectorUtil.selectComponent("btn",this) as Button;
         this._btn.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:RankingsUIEventsPageBtnVO = param1 as RankingsUIEventsPageBtnVO;
         if(!_loc2_)
         {
            visible = false;
            return;
         }
         this._btn.tooltipData = _loc2_.title;
         if(_selected)
         {
            this._btn.enabled = false;
         }
         this.removeListeners();
         super.data = _loc2_;
         this.addListeners();
      }
      
      private function addListeners() : void
      {
         if(!this.VO)
         {
            return;
         }
         this.VO.selected.changed.add(this.onSelectionUpdate);
      }
      
      private function removeListeners() : void
      {
         if(!this.VO)
         {
            return;
         }
         this.VO.selected.changed.remove(this.onSelectionUpdate);
      }
      
      public function get VO() : RankingsUIEventsPageBtnVO
      {
         return data as RankingsUIEventsPageBtnVO;
      }
      
      private function onSelectionUpdate() : void
      {
         if(!this.VO)
         {
            return;
         }
         this._btn.enabled = !this.VO.selected.value;
      }
      
      private function onClick(param1:Event) : void
      {
         if(!this._btn.isEnabled())
         {
            return;
         }
         this._btn.enabled = false;
      }
   }
}

