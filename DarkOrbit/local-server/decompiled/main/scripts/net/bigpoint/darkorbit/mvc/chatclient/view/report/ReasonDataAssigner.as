package net.bigpoint.darkorbit.mvc.chatclient.view.report
{
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   
   public class ReasonDataAssigner extends DefaultItemDataAssigner
   {
      
      private var _checkbox:Button;
      
      public function ReasonDataAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         var _loc2_:ReasonVO = param1 as ReasonVO;
         label.text = _loc2_.toString();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._checkbox = FuiComponentSelectorUtil.selectComponent("checkbox",this) as Button;
      }
      
      override protected function drawSelection() : void
      {
         super.drawSelection();
         this._checkbox.enabled = !_selected;
      }
      
      override protected function handleButtonRollover(param1:MouseEvent) : void
      {
         super.handleButtonRollover(param1);
         label.registeredTextStyleName = "chat_reason_textstyle_over";
      }
      
      override protected function handleButtonRollout(param1:MouseEvent) : void
      {
         super.handleButtonRollout(param1);
         label.registeredTextStyleName = "chat_reason_textstyle";
      }
   }
}

