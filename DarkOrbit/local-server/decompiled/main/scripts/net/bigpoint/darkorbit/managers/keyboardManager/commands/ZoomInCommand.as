package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   
   public class ZoomInCommand implements IKeyboardCommand
   {
      
      public static const NAME:String = "ZoomInCommand";
      
      public function ZoomInCommand()
      {
         super();
      }
      
      public function execute(param1:Map, param2:Vector.<String>) : void
      {
         ScreenManager.getInstance().mapView.zoomIn();
      }
   }
}

