package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   
   public class ZoomOutCommand implements IKeyboardCommand
   {
      
      public static const NAME:String = "ZoomOutCommand";
      
      public function ZoomOutCommand()
      {
         super();
      }
      
      public function execute(param1:Map, param2:Vector.<String>) : void
      {
         ScreenManager.getInstance().mapView.zoomOut();
      }
   }
}

