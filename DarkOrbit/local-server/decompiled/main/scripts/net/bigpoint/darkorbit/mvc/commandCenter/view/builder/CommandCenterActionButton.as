package net.bigpoint.darkorbit.mvc.commandCenter.view.builder
{
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   
   public class CommandCenterActionButton extends Button
   {
      
      private var _xmlDefinition:XML;
      
      private var _layerName:String;
      
      public function CommandCenterActionButton(param1:XML, param2:String)
      {
         super();
         this._xmlDefinition = param1;
         this._layerName = param2;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._xmlDefinition = null;
      }
      
      override protected function handleButtonClicked(param1:MouseEvent) : void
      {
         var _loc3_:XML = null;
         super.handleButtonClicked(param1);
         var _loc2_:XMLList = this._xmlDefinition.child("onclick");
         if(_loc2_.length() > 0)
         {
            for each(_loc3_ in _loc2_)
            {
               dispatchEvent(new CommandCenterActionEvent(CommandCenterActionEvent.TRIGGERED,_loc3_,this._layerName));
            }
         }
      }
   }
}

